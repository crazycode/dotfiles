#!/bin/bash

for tf in $(ls *.tar); do
    echo "load $tf ..."
    docker load --input $tf
    echo "done."
done
