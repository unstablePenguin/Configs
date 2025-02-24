#!/usr/bin/env python3
# This script tests libtmux gnome deplyment.

# Imports
import libtmux
from subprocess import Popen
from sys import argv

# Variables
SESSION_NAME = "Banana"
GEOMETRY = "--geometry=120x120+0+0"
WIDTH = GEOMETRY.split("=")[1].split("x")[0]
HEIGHT= GEOMETRY.split("x")[1].split("+")[0]

GNOME_COMMAND = ["/usr/bin/gnome-terminal",
                 "--title=Situational_Awareness",
                 "--name=initial_tmux",
                 "--hide-menubar",
                 GEOMETRY,
                 "--", "tmux", "new-session", "-As", SESSION_NAME]

XFCE_COMMAND = ["/usr/bin/xfce4-terminal",
                "--title=Situational_Awareness",
                "--hide-menubar",
                "--hide-borders",
                "--hide-scrollbar",
                "--maximize",
                f"--command=tmux new-session -As {SESSION_NAME}"]
# Setup
# Initialize server
server = libtmux.Server()

# Get Session
if server.has_session(target_session=SESSION_NAME):
    session = [sess for sess in server.sessions if sess.name == SESSION_NAME][0]
else:
    session = server.new_session(session_name=SESSION_NAME)
# Args
if len(argv) > 1 and argv[1] == "--gnome":
    COMMAND = GNOME_COMMAND
else:
    COMMAND = XFCE_COMMAND

# Functions
# Setup window 1 Working
def window1_setup():
    # for bottom and side lists to add or remove panes change range stop
    window = session.windows[0]
    bottom_size_list = [x for x in range(2,4)]
    bottom_size_list.reverse()
    side_size_list = [x for x in range(2,4)]
    side_size_list.reverse()
    pane1 = window.panes[0]
    pane2 = window.split_window(target=pane1.id, percent=20, vertical=True)
    bottom_row = [window.split_window(target=pane2.id, percent=100//pane, vertical=False) for pane in bottom_size_list]
    pane3 = window.split_window(target=pane1.id, percent=20,vertical=False)
    side_row = [window.split_window(target=pane3.id, percent=100//pane, vertical=True) for pane in side_size_list]
    # Send commands to panes
    bp1 = pane2
    bp1.send_keys("ls /tmp", enter=True)
# Main
def main():
    terminal = Popen(COMMAND)
    window1_setup()
# to divide into equal parts the first division is the percentage of 100 the last is 50% and each split is the number of remaining panes to be created.

if __name__ == "__main__":
    main()

