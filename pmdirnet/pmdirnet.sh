#!/bin/bash -x

OURIP=0.0.0.0
OURPORT=1682
OURDIR=/tmp/pmdirnet
RAMDIR_SIZE=128m

lsof -Pi :$OURPORT -sTCP:LISTEN 2>&1 > /dev/null || {
    tcpserver -c 500 -HR $OURIP $OURPORT $(readlink -f $0) &
}

[ ! -d $OURDIR ] && mkdir $OURDIR

# Mount ramdir
sudo mount -t tmpfs -o size=$RAMDIR_SIZE tmpfs $OURDIR

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

