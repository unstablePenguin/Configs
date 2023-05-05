#!/bin/bash

# This script downloads and compiles tmux and its dependencies
dnf install autoconf automake pkg-config byacc libtool
# Get source for tmux libevent ncurses

# Build Libevent
git clone https://github.com/libevent/libevent.git 
cd libevent
sh automake.sh
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:
./configure
find 
make && make install

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
