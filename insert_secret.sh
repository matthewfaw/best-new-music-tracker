#!/bin/bash

FILE=$1
SECRET_KEY=$2
SECRET_VALUE=$(echo $3 | base64)

if [ "$#" -ne 3 ]; then
    echo "Expected arguments: FILE SECRET_KEY SECRET_VALUE"
    exit 1
fi

sed "s/<${SECRET_KEY}>/${SECRET_VALUE}/g" ${FILE}