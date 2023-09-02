#!/bin/bash

version=$1
count=${version//[^.]}
if [[ ${#count} > 1 ]]; then
    ver=${version%.*}
else
    ver=$version
fi
verdict=$(echo "$ver >= 6.46" | bc)
if [[ $verdict == 0 ]];then
    echo less than
else
    echo greater than
fi
