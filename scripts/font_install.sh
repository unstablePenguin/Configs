#!/usr/bin/env bash
#This script installs font

# Variables

# Functions
check_arg()
{
    echo -e "[-] Checking for $1\n"
    arg=$1
    [[ -f $arg ]] || echo -e "[!] Error: $arg does not exist.\n" 
    return 0
}
install_font()
{
    echo -e "[-] Installing $1\n"
    font=$1
    global fontdir=${font%%.*}
    mkdir $fontdir
    pushd
    mv $font $fontdir
    cd $fontdir
    tar -xvf $font
    mv *.ttf /usr/share/fonts/
    fc-cache -fv && echo -e "[+] Successfully Installed $font\n"
}
cleanup()
{
    popd
    rm -rf $fontdir
}
# Main
function main()
{
    if [[ $# < 1 ]]; then
        echo -e "[!] Error: No font provided.\n" && exit 1
    fi
    if [[ $2 ]]; then
        for font in $@; do 
            check_arg $font && install_font $font
        done
    else
        check_arg $1 && install_font $1
    fi
    return 0
}

main $@

