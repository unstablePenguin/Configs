#!/usr/bin/python3

import libtmux

server = libtmux.Server()
TARGET = "Work"

session = server.sessions.filter(session_name=TARGET)[0]

window  = session.new_window(window_name="Unifi", attach=True)

p1 = window.panes[0]
p1.send_keys(cmd="ssh unifi-pro", enter=True)
p2 = window.split_window()
p2.send_keys(cmd="ssh unifi+", enter=True)
p3 = window.split_window()
p3.send_keys(cmd="ssh unifi-lite", enter=True)
p4 = window.split_window()
p4.send_keys(cmd="ssh unifi", enter=True)

window.select_layout(layout="tiled")
