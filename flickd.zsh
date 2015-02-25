#! /usr/bin/env zsh

# flickd — run flickpaper continuously as daemon

TMPDIR=${TMPDIR=/tmp}

#daemonize -o $TMPDIR/flickpapr.log -p $TMPDIR/flickpapr.pid -v $PWD/flickloop.zsh
daemonize -o $TMPDIR/flickpapr.log -p $TMPDIR/flickpapr.pid -v ${0:a:h}/flickloop.zsh
