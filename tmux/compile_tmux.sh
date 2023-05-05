#!/bin/bash

# This script downloads and compiles tmux and its dependencies
dnf install autoconf automake pkg-config byacc libtool "Development Tools"
# openssl-devel
# Get source for tmux libevent ncurses

# Build Libevent
git clone https://github.com/libevent/libevent.git 
cd libevent
sh automake.sh
# PKG_CONFIG_PATH=$PKG_CONFIG_PATH:
./configure
make && make install
#May need to export LD_LIBRARY_PATH=/usr/local/lib/
#
# Build Ncurses
wget https://invisible-island.net/datafiles/release/ncurses.tar.gz
tar -xzf ncurses.tar.gz
cd ncurses-6.3
./configure
make && make install

# Build Tmux
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
make install
