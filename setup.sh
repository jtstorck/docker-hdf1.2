#!/bin/bash
mkdir -p $1/testfiles

for i in {000..100}
do
    touch $1/testfiles/"testfile-${i}.txt"
done

mkdir $1/copiedfiles
