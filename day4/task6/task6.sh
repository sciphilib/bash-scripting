#!/bin/bash

ARGS=4
E_BADARGS=85

if [ $# -ne "$ARGS" ]; then
    echo "Usage: $(basename $0) filename1 filename2 filename3 output-dir-name"
    exit $E_BADARGS
fi

TARNAME=archive.tar

tar -cf $TARNAME "$1"; tar -tvf $TARNAME;
tar -rf $TARNAME "$2"; tar -tvf $TARNAME;
tar -rf $TARNAME "$3"; tar -tvf $TARNAME;
tar --delete --file=$TARNAME "$2"; tar -tvf $TARNAME;

mkdir "$4"
tar -xf $TARNAME --directory "$4"

