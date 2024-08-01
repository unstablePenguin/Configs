#!/usr/bin/env python3
""" This script adds new machine to ssh config and creates new sshkeys for it."""

# Imports {{{
from subprocess import Popen, PIPE, DEVNULL
from sys import exit
from pathlib import Path
from rich import print
from rich.prompt import Prompt
import typer
#}}}

#Global Variables {{{
VERSION = 'v0.1'
SSH_DIR = f'{Path.home()}/.ssh/'
SSH_CONFIG = f'{Path.home()}/.ssh/config'
SSH_KNOWNHOSTS = f'{Path.home()}/.ssh/known_host'
DEFAULT_CONFIG = "Host *\n    IdentitiesOnly yes\n"
REQUIRED_APPS = ["sshpass", "ssh"]
CHECK = '\u2705'
X = '\u2718'
#}}}
# Initialization {{{
app = typer.Typer(rich_markup_mode="rich")
#}}}
# Functions {{{
def check_required_apps(apps: list) -> list: #{{{
    """Checks for required applications. Returns list of not installed required applications."""
    installed = {}
    not_installed_tmp = []
    not_installed = []
    for binary in apps:
        try:
            Popen(binary, stdout=DEVNULL, stderr=DEVNULL)
            installed[binary] = True
        except:
            print(f"{X} Error: {binary} not installed. Please install and try again.")
            installed[binary] = False

    not_installed_tmp = [binary for binary in installed.items() if False in binary]
    if not_installed_tmp:
        not_installed = [ binary[0] for binary in not_installed_tmp]
        print(f"{X} Error: The following applications are required: {not_installed}")
        return not_installed
    #}}}
def get_ssh_config(config: str) -> bool: #{{{
    """Parses SSH config. Returns list of dictionaries if file exists else returns None."""
    ssh_config = Path(config)
    if ssh_config.exists():
        print(f'Reading {ssh_config}')
        with open(ssh_config, "r") as f:
            data = f.read()
        # Remove whitespace and newlines
        config = [ item.strip() for item in data.split("\n") ]
        config = [ value for value in config if value ]
        # Parse config to list of dicts for each host entry
        hosts = []
        for idx,val in enumerate(config):
            value = val.split()
            if value[0].casefold() == "host":
                if idx == 0:
                    group = idx
                else:
                    group = group + 1
                hosts.append({value[0] : value[1]})
            hosts[group][value[0]] = value[1]
        print(f"{CHECK} Successfully loaded {len(hosts)} hosts.")
        return hosts
    else:
        return None
#}}}
def create_default_config(ssh_config: str, contents: str) -> bool: #{{{
    """Creates default config. Returns True if success, False if failure."""
    print(f"{X} {ssh_config} does not exist, creating {ssh_config}")
    with open(ssh_config, "w", encoding="utf-8") as default_config_file:
        default_config_file.write(DEFAULT_CONFIG)
    if Path(ssh_config).exists():
        print(f"{CHECK} Successfully created {ssh_config}.")
        return True
    else:
        print(f"{X} Error: Failed to create {ssh_config}.")
        return False
#}}}
def check_identities_only(hosts: list) -> bool: #{{{
    """Checks for IdentitiesOnly and ControlMaster in ssh config. Takes list of
        dictionaries. Returns True if present and False if not."""
    star_host = [host for host in hosts if host["Host"] == "*"]
    if not star_host:
        print(f"{X} Global Host is not set in {SSH_CONFIG}.")
        return False
    elif "IdentitiesOnly" not in star_host[0].keys() or\
            star_host[0]["IdentitiesOnly"] != "yes":
        print(f"{X} IdentitiesOnly is not set to yes in {SSH_CONFIG}.")
        return False
    else:
        return True
    #}}}
def check_control_master(hosts: list) -> bool: #{{{
    """Checks for ControlMaster in ssh config.\
            Takes list of dictionaries. Returns True if present and False if not."""
    star_host = [host for host in hosts if host["Host"] == "*"]
    if not star_host:
        print(f"{X} Global Host ControlMaster is not set in {SSH_CONFIG}.")
        return False
    elif "ControlMaster" not in star_host[0].keys() or star_host[0]["ControlMaster"] != "auto":
        print(f"{X} ControlMaster is not set or is set to no.")
        return False
    else:
        return True
   #}}}
def add_global_options(identities: bool, control: bool, hosts) -> list: #{{{
    """Adds Global Identities Only to ssh config. Takes 2 booleans and list.\
            Returns list of dictionaries. Ensure to write hosts to config."""
    star_host = [host for host in hosts if host["Host"] == "*"]
    if not star_host:
        hosts.insert(0,{'Host': "*", 'IdentitiesOnly': "yes", 'ControlMaster': "auto"})
        print(f"{CHECK} Successfully added IdentitiesOnly and ControlMaster to config.")
        return hosts
    if not identities:
        print(f"{X} Setting IdentitiesOnly to yes")
        star_index = [hosts.index(host) for host in hosts if host["Host"] == "*"][0]
        hosts[star_index]["IdentitiesOnly"] = "yes"
        print(f"{CHECK} Successfully added IdentitiesOnly to config.")
    if not control:
        print(f"{X} Setting ControlMaster to auto")
        star_index = [hosts.index(host) for host in hosts if host["Host"] == "*"][0]
        hosts[star_index]["ControlMaster"] = "auto"
        print(f"{CHECK} Successfully added ControlMaster to config and set it to auto.")
    return hosts
#}}}
def check_existing_host_ip(name, ipaddr, hosts) -> bool: #{{{
    """Checks for the existence of host and ip in list of dictionaries.Returns False if exists True if not."""
    exists_name = [host for host in hosts if host["Host"] == name]
    exists_ip = [host for host in hosts if "Hostname" in host.keys() and host["Hostname"] == ipaddr]
    if exists_name:
        print(f"{X} {name} already exists in {SSH_CONFIG}")
        return False
    elif exists_ip:
        print(f"{X} {ipaddr} already exists under {exists_ip[0]['Host']} in {SSH_CONFIG}")
        return False
    else:
        return True
#}}}
def check_jumphost_exists(jumphost: str, hosts: list) -> bool: #{{{
    """Checks for jumphost's existence in hosts list of dictionaries. Returns boolean."""
    jumphost_exists = [host for host in hosts if host["Host"] == jumphost ]
    if jumphost_exists:
        return True
    return False
#}}}
def write_config(hosts: list, ssh_config: str) -> bool: #{{{
    """Writes hosts list of dictionaries to file in ssh config format"""
    with open(ssh_config, "w") as f:
        for host in hosts:
            for key in host.keys():
                if key != "Host":
                    f.write(f"    {key} {host[key]}\n")
                else:
                    f.write(f"{key} {host[key]}\n")
    print(f"{CHECK} Successfully saved {len(hosts)} hosts to {SSH_CONFIG}.")
    return True
#}}}
def generate_keys(name: str, key_alg: str) -> str: #{{{
    """Generates ssh identity keyfiles. Returns string of keyfile_name."""
    key_filename = Path(SSH_DIR + name)

    if not key_filename.exists():
        command = ["ssh-keygen","-t", key_alg, "-q", "-f", key_filename]
        try:
            enter = Popen(["echo", "''"], stdout=PIPE)
            keygen = Popen(command, stdin=enter.stdout, stderr=DEVNULL)
            print(f"{CHECK} Successfully created ssh key pair {key_filename}.")
            return key_filename
        except:
            print(f"{X} Unable to create identity key files {key_filename}")
    else:
        print(f"{X} {key_filename} already exists.")
        return key_filename
#}}}
def generate_config_entry(SSH_CONFIG: str, name: str, ipaddr: str, username: str, port: int,key_filename: Path, jumphost: str=None) -> bool: #{{{
    """Adds host entry to ssh config. Returns bool indicating success or failure."""
    if jumphost:
        entry = f"Host {name}\n    Hostname {ipaddr}\n    User {username}\n    Port {port}\n    ProxyJump {jumphost}\n    ControlPath {SSH_DIR}+{name}\n    IdentityFile {key_filename}\n"
    else:
        entry = f"Host {name}\n    Hostname {ipaddr}\n    User {username}\n    Port {port}\n    ControlPath {SSH_DIR}+{name}\n    IdentityFile {key_filename}\n"

    try:
        with open(SSH_CONFIG, "a") as config_file:
            config_file.write(entry)
        print(f"{CHECK} Successfully added {name} at {ipaddr} to {SSH_CONFIG}")
        return True
    except:
        print(f"{X} Error: Unable to add {name} at {ipaddr} to {SSH_CONFIG}")
        return False
#}}}
def copy_id_remote(password: str, key_file: Path, username: str, ipaddr: str, port: str, jumphost: str=None) -> bool: #{{{
    """Copies ssh keyfile to remote host.Returns True."""
    if jumphost:
        command = ["sshpass", "-p", password,
                   "ssh-copy-id", "-f",
                   "-o", "StrictHostKeyChecking=no",
                   "-o", f"ProxyJump={jumphost}",
                   "-p", str(port), "-i", key_file, username + "@" + ipaddr]
        try:
            Popen(command, stdout=DEVNULL, stderr=DEVNULL)
            print(f"{CHECK} Successfully transferred keyfile to {ipaddr}")
        except:
            print(f"{X} Unable to transfer keyfile to {ipaddr}")
            return False

    else:
        command = ["sshpass", "-p", password,
                   "ssh-copy-id", "-f", "-o", "StrictHostKeyChecking=no",
                   "-p", str(port), "-i", key_file, username + "@" + ipaddr]
        try:
            Popen(command, stdout=DEVNULL, stderr=DEVNULL)
            print(f"{CHECK} Successfully transferred keyfile to {ipaddr}")
        except:
            print(f"{X} Unable to transfer keyfile to {ipaddr}")
            return False
    return True
#}}}
#}}}
# Main parameters {{{
@app.command()
def main(
        name: str = typer.Argument(help="Nickname or hostname for remote machine"),
        username: str = typer.Option("", "-u",
                                     "--username",
                                     prompt=True,
                                     help="Username on remote machine"),
        ipaddr: str = typer.Option("", "-i",
                                   "--ipaddr",
                                   help="IP Address or FQDN"),
        port: int = typer.Option(22, "-p",
                                 "--port",
                                 help="Port for SSH service on remote machine"),
        password: str = typer.Option("",hidden=True),
        DEBUG: bool = typer.Option(False,hidden=True),
        jumphost: str = typer.Option("", "-J",
                                     "--jumphost",
                                     help="Nickname of host to jump through to reach remote machine."),
        key_alg: str = typer.Option("ED25519", "-k", "--key_algorithm",
                                    help="Select the key generation algorithm rsa or ed25519")
        ) -> None:
    """Adds machine to ssh config and creates new sshkeys for it."""
#}}}
    missing = check_required_apps(REQUIRED_APPS)
    if missing:
        exit()
    # If password null get password
    if not password:
        password = Prompt.ask("Enter the password for the remote machine :lock:", password=True)
    if DEBUG is True:
        print(f"Args: {name} {username} {password} {ipaddr} {port} {jumphost}")
    print(f"Welcome to AddHost {VERSION}")
    hosts = get_ssh_config(SSH_CONFIG)
    # If SSH config does not exist create one.
    if not hosts:
        create_default_config(SSH_CONFIG, DEFAULT_CONFIG)
        hosts = get_ssh_config(SSH_CONFIG)
    # If IdentitiesOnly is not set or set to no set to yes and write to ssh config.
    identities = check_identities_only(hosts)
    control = check_control_master(hosts)
    if not identities or not control:
        add_global_options(identities, control, hosts)
        write_config(hosts, SSH_CONFIG)
    if jumphost and not check_jumphost_exists(jumphost, hosts):
        print(f"{X} {jumphost} is not in {SSH_CONFIG}. Unable to use {jumphost} as JumpHost.")
        exit()
    # If host already exists do not add to config or generate keys.
    if check_existing_host_ip(name, ipaddr, hosts):
        key_filename = generate_keys(name, key_alg)
        if jumphost:
            generate_config_entry(SSH_CONFIG, name, ipaddr, username, port, key_filename, jumphost)
            copy_id_remote(password, key_filename, username, ipaddr, port, jumphost)
        else:
            generate_config_entry(SSH_CONFIG, name, ipaddr, username, port, key_filename)
            copy_id_remote(password, key_filename, username, ipaddr, port)

if __name__ == "__main__":
    app()
