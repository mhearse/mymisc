#!/usr/bin/env python

# Written by: Matt Hersant

import subprocess

lines = subprocess.check_output(['getent', 'passwd']).splitlines()

mystruct = {}
for line in lines:
    items = line.split(':')
    mystruct[int(items[2])] = items

for uid in sorted(mystruct.keys()):
    if uid >= 100:
        print ':'.join(mystruct[uid])
