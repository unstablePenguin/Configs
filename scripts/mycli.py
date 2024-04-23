import argparse
from pathlib import Path

#Variables
pname = "mycli"
desc = "This is a basic command line template for my utilities"


parser = argparse.ArgumentParser(prog=pname,description=desc,)
parser.add_argument("--all", help="a: all")

args = parser.parse_args()
