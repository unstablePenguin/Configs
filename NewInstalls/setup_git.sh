#!/usr/bin/env bash
#This script is to setup git.

# Variables

# Functions

# Main
function main()
{
    git config --global user.name unstablePenguin
    git config --global user.email niftycello@pm.me
    ssh-keygen -t ed25519 -f ~/.ssh/github -q -N ""
    ssh-add ~/.ssh/github
    git remote set-url origin git@github.com:unstablePenguin/Configs.git
    printf 'Add your ssh key to your github account\n\tcat /home/redadmin/.ssh/github.pub | xsel'

}

main

