#!/usr/bin/env bash

# Get results
FILES="cloverleaf_results/*.log"

for f in $FILES; do
    # Get the length of the results file
    nlines=$(grep -c $ $f)
    # echo $nlines
    # echo "Processing $f file..."

    # If the file isn't 22 lines long (the right length) for profiling
    # then don't process it 
    if [[ "$nlines" -eq "22" ]]; then
        # Get the wall time via sed/cut the 3rd line
        walltime=$(sed -n '3p' $f | cut -d' ' -f3)
        echo $f $walltime
    fi 
done


