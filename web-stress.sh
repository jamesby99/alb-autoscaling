#!/usr/bin/env bash

for i in $(seq $1); do
    wget -q $2 > /dev/null
    echo $i
done