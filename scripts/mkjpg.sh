#!/usr/bin/env bash
#This script creates an image with the text provided.
# -b background color
# -c font color
# -o output filename
USAGE="Usage: ${basename} [-b background color] [-c font color] {-o OUTFILE} {'Message'}"
# Variables
# Functions
# Main
while getopts ":b:c:o:" option; do
    case ${option} in
        b ) # For -b
            BG=$OPTARG
            ;;&
        c )
            FC=$OPTARG
            ;;&
        o )
            OUTFILE=$OPTARG
            ;;&
        \?) # For invalid inputs
            printf "Invalid option: ${OPTARG}\n"
            printf $USAGE
            exit 1
    esac
done
shift $(expr $OPTIND - 1)
MESSAGE=$@
#printf "Options:\n\t-b ${BG}\n\t-c ${FC}\n\t-o ${OUTFILE}\n\nMessage: ${MESSAGE}\n"
convert -size 500x300 xc:${BG} +repage\
        -size 300x200  -fill ${FC} -background None\
        -font CourierNewB -gravity center\
        caption:"${MESSAGE}"\
        +repage  -gravity Center  -composite -strip\
        ${OUTFILE}.jpg
feh ${OUTFILE}.jpg

