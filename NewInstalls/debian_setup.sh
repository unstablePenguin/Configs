#!/usr/bin/env bash
#This script install and configures a new debian machine.

# Install Software
PACKAGES="git ptpython tmux vim virtualenv"
PY_PACKAGES="python3-cmd2 python3-yaml"
apt purge nano
apt update && apt upgrade -y
apt install $PACKAGES

