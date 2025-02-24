#!/bin/bash

# This scripts sets some creature comforts in gnome desktop environmets
# Get current keys and values with:
#     gsettings list-recursively | grep org.gnome.desktop.interface

if [[ -e /usr/share/backgrounds/brad-huchteman-stone-mountain.jpg ]]; then
    gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/brad-huchteman-stone-mountain.jpg
fi

gsettings set org.gnome.desktop.background show-desktop-icons 'false'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false

# set https_proxy
# Nerdfont hack
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/Hack.zip
mkdir hack && cd hack
mv ../Hack.zip . && unzip Hack.zip
rm Hack.zip LICENSE.md readme.md
mv *.ttf /usr/share/fonts/
fc-cache -fv

gsettings set org.gnome.desktop.interface monospace-font-name 'Hack Nerd Font Mono 12'
gsettings set org.gnome.desktop.interface font-name 'Hack 12'

cat << eof > gnome-terminal-profiles.dconf
[:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
visible-name='red'
default-size-columns=260
default-size-rows=80
use-system-font=false
use-transparent-background=true
font='Hack Nerd Font Mono 14'
scrollbar-policy='never'
background-transparency-percent=25
audible-bell=false
eof
dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf
# check these out
# org.gnome.SessionManager auto-save-session false
# org.gnome.desktop.wm.preferences theme 'Adwaita'
# org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 11'
# org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
