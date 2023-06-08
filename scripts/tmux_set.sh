#!/bin/bash
#
WORKDIR=$HOME/work

#First Session
tmux new-session -s work -d -c $WORKDIR -n Desk
tmux select-pane -t work:1.1 -T Main
#tmux pipe-pane -t work:1.1 "cat >${WORKDIR}/main-pane.log"
tmux split-window -t work:1.1 -c $WORKDIR
tmux select-pane -t work:1.2 -T Log
tmux send-keys -t work:1.2 "journalctl -f -p 3 -q"
tmux split-window -h -t work:1.2 -c $WORKDIR
tmux select-pane -t work:1.3 -T TcpDump
tmux send-keys -t work:1.3 "tcpdump -i enp10s0 'icmp'"
tmux select-layout -t work:1.1 main-vertical
tmux resize-pane -t work:1.1 -x 150
## Session 1 window 2
tmux new-window -t work -n Red/Gin
tmux split-pane -t work:2.1
tmux select-layout -t work:2.1 even-vertical
tmux select-pane -t work:2.1 -T Red
tmux send-keys -t work:2.1 "$HOME/Configs/scripts/cartwheel.sh" C-m
tmux select-pane -t work:2.2 -T Gin
tmux send-keys -t work:2.2 "$HOME/Configs/scripts/rand_chars.sh" C-m

# Session 2 Multi-window setup
tmux new-session -d -s Notepad -c $WORKDIR -n Notes "vim"
tmux new-window -t Notepad -n Options "vim myoptions.txt"
tmux new-window -t Notepad -n Survey "vim landsurvey.txt"
tmux select-window -t Notepad:1
tmux send-keys -t Notepad:1 "\ww" C-m
#tmux pipe-pane 

#tmux resize-pane -x 90 -y 90 -t work:1.1

#1: Desk* (7 panes) [232x60] [layout fc16,232x60,0,0[232x49,0,0{184x49,0,0,0,47x49,185,0[47x3,185,0,3,47x3,185,4,4,47x3,185,8,5,47x37,185,12,6]},232x10,0,50{116x10,0,50,1,115x10,117,50,2}]]
termite -e "tmux attach -t work" &
termite -e "tmux attach -t Notepad" &
