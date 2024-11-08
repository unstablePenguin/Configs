#!/usr/bin/env python3
# This class is a network host for ssh.
from pathlib import Path
from rich import print
from dataclasses import dataclass, field

# Imports
# Globals
SSH_DIR = f"{Path.home()}/.ssh/"

# Class
@dataclass
class Host:
    name: str
    user: str
    ipaddr: str
    port: int = 22
    keyfile: str = field(init=False)
    controlpath: str = field(init=False)

    def __post_init__(self):
        self.keyfile = SSH_DIR + self.name
        self.controlpath = f"{SSH_DIR}{self.name}.sock"

    def __str__(self) -> str:
        return f"Host {self.name}\n    Hostname {self.ipaddr}\n    User {self.user}\n    Port {self.port}\n    ControlPath {self.controlpath}\n    Identityfile {self.keyfile}\n"

if __name__ == "__main__":
    exit()
