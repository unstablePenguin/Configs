#!/usr/bin/env bash
#This script resets testing env

# Variables
CONFIG=/home/redadmin/.ssh/config
KEYS=/home/redadmin/.ssh/testing*

TEST2_KEYS=/home/redadmin/.ssh/rednet-pfsense*

# Functions

# Main
function main()
{
ssh testing "rm /home/redadmin/.ssh/authorized_keys"
rm $CONFIG && echo "Keys removed" || echo "Unable to remove keys."
rm $KEYS && echo "Keys removed" || echo "Unable to remove keys."
rm $TEST2_KEYS
}

main

