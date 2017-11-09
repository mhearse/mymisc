#!/bin/bash

OURPORT=1682

for num in {1..10000}
do
    KEY=$(uuid)
    VAL=$(openssl rand -hex 1024)
    echo "put$KEY$VAL" | nc 0.0.0.0 $OURPORT
done
