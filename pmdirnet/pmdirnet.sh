#!/bin/bash

OURPORT=8080
OURFIFO=/tmp/pmdirnet.fifo
OURDIR=/tmp/pmdirnet

if [ -p $OURFIFO ]; then
    rm -f $OURFIFO
fi

mkfifo $OURFIFO

while true
do
    cat $OURFIFO | nc -l -p $OURPORT -N | 
    while read -r INPUT
    do
        if [ ! -z $INPUT ]; then
            echo $INPUT |
            while IFS= read -r METHOD KEY VALUE
            do
                case $METHOD in
                     put) echo $VALUE > $OURDIR/$KEY; echo "" > $OURFIFO
                         ;;
                     get) cat $OURDIR/$KEY > $OURFIFO
                         ;;
                esac
            done
        fi
    done
done
