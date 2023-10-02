#!/usr/bin/python3

# Define Session titles
titles = ["California", "Florida", "Texas"]

def mksession(name, config):
    server.new_session(session_name=name)
    if config:
        sess = server.sessions.filter(session_name=name)[0]
        w1 = sess.windows[0]
        panes = {}
        w1.split_window(attach=False, vertical=True)
        w1.split_window(attach=False, vertical=False)

        for x,y in enumerate(w1.panes):
            key = str("p" + str(x))
            panes[key] = y
        w1.select_pane(target_pane=p0)

