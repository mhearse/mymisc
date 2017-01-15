#!/bin/bash

# Print a sorted list of passwd lines with UID >= 100
# I was asked to code this during an interview.

getent passwd | sort -n -t\: -k3 $PASSWD |

while read line; do
    OURUID=$(echo $line | cut -f3  -d\:)
    if [ "$OURUID" -ge 100 ]; then
        echo $line
    fi
done
