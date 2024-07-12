#!/usr/bin/env python3
# This script reads numbers from a file and prints to stdout and a file at random intervals.

# Imports
from subprocess import run, PIPE
from argparse import ArgumentParser
from pathlib import Path
from random import randint
from datetime import datetime
from time import sleep
from signal import signal, SIGINT
from colorama import Fore, Style

# Time format
fmt = "%F %T - "

# Variables
COMMAND = "./echo"
ERROR_LOG = f"{datetime.utcnow().strftime('%F_%T_')}run_wild_error.log"
RUN_LOG = "run_wild.log"

# Colors
RED = Fore.RED
GRN = Fore.GREEN
BLU = Fore.BLUE
YLW = Fore.YELLOW
RST = Style.RESET_ALL

# Init parser
parser = ArgumentParser(prog="Run_Wild",
                        description="""Run_Wild outputs numbers to the screen and a file at random intervals.""",
                        epilog=f"{YLW}Example:{RED} run_wild.py {GRN}-m {YLW}0 {GRN}-M {YLW}300 {BLU}numbers.txt output{RST}\n")
parser.add_argument("infile", help="Input file to read numbers from.")
parser.add_argument("outfile", help="Output file to write to.")
parser.add_argument("--min", "-m", help=f"{GRN}Minimum time to delay in seconds.{BLU} Default{YLW} 1 {BLU}second{RST}", default=1, type=int)
parser.add_argument("--max", "-M", help=f"{GRN}Maximum time to delay in seconds.{BLU} Default{YLW} 300 {BLU}seconds{RST}", default=300, type=int)
args = parser.parse_args()


# Functions
def handleInterrupt(signum, frame):
    # \n to offset the ^C when ctrl+c is pressed
    tee(f"\n{BLU}[-]{GRN} Gracefully {YLW}Exiting.{GRN} Goodbye{RST}", RUN_LOG)
    exit(code=2)

def readInfile(INFILE):
    """Reads INFILE. Returns list."""
    infile = Path(INFILE)

    if infile.is_file():
        tee(f"{BLU}[-]{GRN} Reading data from {YLW}{infile.absolute()}{RST}", RUN_LOG)
        with open(infile) as file:
            return file.read().split()

def tee(data, file):
    """Prints data to screen and file"""
    print(data)
    with open(file, "a") as f:
        f.write(data + "\n")

# Main
def main():
    # Init signal handler for signal interrupt
    signal(SIGINT, handleInterrupt)
    OUTFILE = Path(f"{args.outfile}_{datetime.utcnow().strftime('%F_%T')}.log")

    tee(f"{GRN}[+] {YLW}{datetime.utcnow().strftime(fmt)}{GRN} Successfully initialized program.{RST}", RUN_LOG)
    tee(f"{BLU}[-]{GRN} Output file: {YLW}{OUTFILE.absolute()}{RST}", RUN_LOG)
    MIN = args.min
    MAX = args.max
    tee(f"{BLU}[-]{GRN} Delay Settings in seconds{YLW} -{GRN} Min: {YLW}{MIN}  {GRN}Max: {YLW}{MAX}{RST}", RUN_LOG)
    if MIN >= MAX:
        tee(f"{RED}[!] Error: Minimum must be less than Maximum{RST}", RUN_LOG)
        exit(code=1)

    data = readInfile(args.infile)
    if data: 
        tee(f"{GRN}[+] {YLW}{datetime.utcnow().strftime(fmt)}{GRN} Successfully loaded {YLW}{len(data)} {GRN}items{RST}", RUN_LOG)
    for number in data:
        delay = randint(MIN, MAX)
        sleep(delay)
        try:
            process = run(f"{COMMAND} {number}", stdout=PIPE , stderr=PIPE, shell=True, text=True)
            tee(f"{GRN}[+] {YLW}{datetime.utcnow().strftime(fmt)}{RST}{COMMAND} {number}", OUTFILE)
            if process.returncode != 0:
                tee(f"{RED}[!] {datetime.utcnow().strftime(fmt)}Error: Non-zero exit status for command.\n{COMMAND} {number}\n{process.stderr}{RST}",ERROR_LOG)
        except:
            tee(f"{RED}[!] {datetime.utcnow().strftime(fmt)}Error: Failed to execute.\n{COMMAND} {number}\n{process.stderr}{RST}",ERROR_LOG)
        tee(process.stdout, OUTFILE)
if __name__ == "__main__":
    main()

