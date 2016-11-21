#!/bin/bash
mkdir -p $1

for i in {000..100}
do
    touch $1/"testfile-${i}.txt"
done

mkdir $1/copiedfiles
