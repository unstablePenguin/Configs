#!/bin/bash
#
# This Parses user data into arrays and prints to files

files=$(find . -maxdepth 1 -name "user.data*")

for f in $files; do

    names+=($(awk '/name/{print $3}' $f))
    pubkeys+=($(awk '/pubkey/{print $3}' $f))
    raws+=($(awk '/raw/{print $3}' $f))

    echo $f
    for n in ${!names[@]};do
        echo "Name : ${names[$n]}, Pubkey : ${pubkeys[$n]}, Raw : ${raws[$n]}"
    done

done

