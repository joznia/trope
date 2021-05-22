#!/usr/bin/env bash

# YUMmi installer

if [ "$EUID" -ne 0 ]; then
    echo 'This installer requires root'
    exit 1
fi


die () {
    if [ $? -gt 0 ]; then
        echo "$*" 1>&2 ; exit 1;
    fi
}

SRC="./main.py"
DEST="/usr/bin/yummi"
DESTP="/usr/bin/pacman"

base () {
    cp $SRC $DEST 
    die "install failed"
    chmod 0755 $DEST
}

if [ $1 == '-u' ]; then
    if [ -e $DEST ]; then
        unlink $DEST 
        die "install failed"
    fi
elif [ $1 == '-s' ]; then
    base
    ln -sf $DEST $DESTP
    chmod 0755 $DESTP
else
    base
fi

