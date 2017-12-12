#!/bin/bash

OURIP=0.0.0.0
OURPORT=1682
MAXCLIENTS=50
MAXSLEEP=1

RETVAL=""
for req in uuid nc
do
    which $req > /dev/null 2>&1 || {
        echo "Client progam needs: $req"
        RETVAL=1
    }
done

[ ! -z "$RETVAL" ] && exit

for num in {1..10000}
do
    while [ "$(ps -ef | grep $OURPORT | wc -l)" -ge "50" ] 
    do
        echo "Sleeping cause there's too many clients: $MAXCLIENTS"
        sleep $MAXSLEEP
    done
    KEY=$(uuid)
    VAL=$(openssl rand -hex 1024)
    echo "put$KEY$VAL" | nc $OURIP $OURPORT &
done
