#!/bin/bash

TARGET_FILE=$1 # the yaml to insert into
TARGET_ID=$2 # the line after which to insert
SOURCE=$3 # the source script to insert
SOURCE_INDENT=$4 # the amount to indent

if [ "$#" -ne 4 ]; then
    echo "Invalid number of arguments provided.  Expected TARGET_FILE TARGET_ID SOURCE SOURCE_INDENT"
    exit 1
fi

tmpfile=$(mktemp)
cp $SOURCE $tmpfile
sed "s/^/$(printf ' %.0s' `seq 1 $SOURCE_INDENT`)/g" $tmpfile > ${tmpfile}.tmp && mv ${tmpfile}.tmp $tmpfile
sed "/${TARGET_ID}/r ${tmpfile}" $TARGET_FILE
rm $tmpfile