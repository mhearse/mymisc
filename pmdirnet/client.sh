#!/bin/bash

OURIP=0.0.0.0
OURPORT=1682

for num in {1..10000}
do
    KEY=$(uuid)
    VAL=$(openssl rand -hex 1024)
    echo "put$KEY$VAL" | nc $OURIP $OURPORT
done
