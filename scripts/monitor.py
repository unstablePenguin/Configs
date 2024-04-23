#!/usr/bin/python3

import sys
import time
import logging
from watchdog.observers import Observer
from watchdog.events import LoggingEventHandler
from watchdog.events import FileSystemEventHandler

class Watcher:
    WATCH_DIR = "/tmp/"

    def __init__(self):
        self.observer = Observer()

    def run(self):
        event_handler = Handler()
        self.observer.schedule(event_handler, self.WATCH_DIR, recursive=True)
        self.observer.start()
        try:
            while True:
                time.sleep(1)
        except:
            self.observer.stop()
            print("Error")

        self.observer.join()
class Handler(FileSystemEventHandler):
    @staticmethod
    def on_any_event(event):
        if event.is_directory:
            return None
        elif event.event_type == 'created':
            print(f'{event.src_path} Created or Modified.')
            getInfo(event.src_path)
#        elif event.event_type == 'modified':
#            print(f'{event.src_path} modified')

def getInfo(infile):
    if "red" in infile:
        with open(infile) as f:
            content = f.readlines()
            print(content)

if __name__ == '__main__':
    w = Watcher()
    print("Initializing watcher on", w.WATCH_DIR)
    w.run()
