#!/usr/bin/python3

import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from colorama import Fore, Back, Style
from signal import signal, SIGINT
from sys import exit

class Watcher:
    WATCH_DIR = "/tmp"
    def __init__(self):
        self.observer = Observer()

    def cleanup(self, signal_received, frame):
        self.observer.stop()
        print(f'Exiting gracefully')
        exit(0)

    def run(self):
        event_handler = Handler()
        self.observer.schedule(event_handler, self.WATCH_DIR, recursive=True)
        self.observer.start()
        signal(SIGINT, self.cleanup)
        print(f'Monitoring {self.WATCH_DIR} . . . Press Ctrl-C to exit.')
        
        try:
            while True:
                time.sleep(2)
        except:
            time.sleep(1)

        self.observer.join()


class Handler(FileSystemEventHandler):
    @staticmethod
    def on_created(event):
        #Read file, Get info, log info, delete file
        print(f"Reading {event.src_path}")
        print(f'Getting the info from {event.src_path}')
        print(f'Deleting {event.src_path}')

if __name__ == '__main__':
    w = Watcher()
    w.run()
