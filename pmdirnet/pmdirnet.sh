#!/bin/bash

OURPORT=1682
OURDIR=/tmp/pmdirnet

lsof -Pi :$OURPORT -sTCP:LISTEN 2>&1 > /dev/null || {
    tcpserver -c 500 -HR 0.0.0.0 $OURPORT $(readlink -f $0)
}

[ ! -d $OURDIR ] && mkdir $OURDIR

read -r INPUT

echo $INPUT | 
while IFS= read -r METHOD KEY VALUE
do
    DIRSUBSTR=$OURDIR/${KEY:0:4}
    case $METHOD in
        put) [ ! -d $DIRSUBSTR ] && mkdir $DIRSUBSTR; echo $VALUE > $DIRSUBSTR/$KEY
            ;;
        get) cat $DIRSUBSTR/$KEY
            ;;
    esac
done

