#!/bin/bash
#
WORKDIR=$HOME/work

tmux new-session -d -s work -c $WORKDIR -n Desk
tmux select-pane -t work:1.1 -T Main
tmux pipe-pane -t 1 "cat >${WORKDIR}/main-pane.log"
tmux split-window -t 1 -c $WORKDIR
tmux select-pane -t 2 -T Log
tmux send-keys "journalctl -f -p 3 -q" C-m
tmux split-window -h -t 2 -c $WORKDIR
tmux select-pane -t 3 -T TcpDump
tmux send-keys "tcpdump -i enp10s0 'icmp'" C-m
tmux select-pane -t 1
tmux split-window -t 1 -h -c $WORKDIR
tmux select-pane -t 2 -T Tunnel_1
tmux pipe-pane -t 2 "cat >${WORKDIR}/Tun1.log"
tmux send-keys "ssh -qfNL {port}:{rhost}:{port} {host}"
tmux split-window -t 2 -c $WORKDIR
tmux select-pane -t 3 -T Tunnel_2
tmux pipe-pane -t 3 "cat >${WORKDIR}/Tun2.log"
tmux send-keys "ssh -qfNL {port}:{rhost}:{port} {host}"
tmux split-window -t 3  -c $WORKDIR
tmux select-pane -t 4 -T Tunnel_3
tmux send-keys "ssh -qfNL {port}:{rhost}:{port} {host}"
tmux split-window -t 4  -c $WORKDIR
tmux select-pane -t 5 -T Tunnel_4
tmux send-keys "ssh -qfNL {port}:{rhost}:{port} {host}"
#tmux selectw -t 1
#tmux pipe-pane 

tmux resize-pane -x 90 -y 90 -t work:1.1

tmux attach-session


#tmux new-window -n desk -c/$HOME/work/desk
#1: Desk* (7 panes) [232x60] [layout fc16,232x60,0,0[232x49,0,0{184x49,0,0,0,47x49,185,0[47x3,185,0,3,47x3,185,4,4,47x3,185,8,5,47x37,185,12,6]},232x10,0,50{116x10,0,50,1,115x10,117,50,2}]]
