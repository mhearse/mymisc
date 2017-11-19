#!/bin/bash

OURIP=0.0.0.0
OURPORT=1682
OURDIR=/tmp/pmdirnet
RAMDIR_SIZE=128m

[ "$1" == "stop" ] && {
    PIDFILE=$OURDIR/tcpserver.pid
    [ -f $PIDFILE ] && kill $(cat $PIDFILE)
    sudo umount $OURDIR
    exit
}

mountpoint -q $OURDIR || {
    sudo mount -t tmpfs -o size=$RAMDIR_SIZE tmpfs $OURDIR
}

lsof -Pi :$OURPORT -sTCP:LISTEN 2>&1 > /dev/null || {
    tcpserver -c 500 -HR $OURIP $OURPORT $(readlink -f $0) &
    echo $! > $OURDIR/tcpserver.pid
}

[ ! -d $OURDIR ] && mkdir $OURDIR

read -r INPUT

echo $INPUT | 
while IFS= read -r METHOD KEY VALUE
do
    DIRSUBSTR=${KEY:0:4}
    case $METHOD in
        put) [ ! -d $OURDIR/$DIRSUBSTR ] && mkdir $OURDIR/$DIRSUBSTR; echo $VALUE > $OURDIR/$DIRSUBSTR/$KEY
            ;;
        get) cat $OURDIR/$DIRSUBSTR/$KEY
            ;;
        del) unlink $OURDIR/$DIRSUBSTR/$KEY
    esac
done

