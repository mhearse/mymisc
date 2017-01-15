#!/bin/bash

getent passwd | sort -n -t\: -k3 $PASSWD |

while read line; do
    OURUID=$(echo $line | cut -f3  -d\:)
    if [ "$OURUID" -ge 100 ]; then
        echo $line
    fi
done
