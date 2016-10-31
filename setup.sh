#!/bin/bash

for i in {000..100}
do
    touch $1/"testfile-${i}.txt"
done
