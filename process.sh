#!/usr/bin/env bash

FILES="cloverleaf_results/*.log"

for f in $FILES; do
    nlines=$(grep -c $ $f)
    # echo $nlines
    # echo "Processing $f file..."
    if [[ "$nlines" -eq "22" ]]; then
        walltime=$(sed -n '3p' $f | cut -d' ' -f3)
        echo $f $walltime
    fi 
done


