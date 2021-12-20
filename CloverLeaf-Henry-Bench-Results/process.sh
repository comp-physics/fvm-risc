
CSV_TABLE_COL_NAMES="Compiler,Library,Target,Tiles Per Chunk,# MPI Ranks,# OpenMP Threads,Runtime"

echo "$CSV_TABLE_COL_NAMES" > cpu.csv
echo "$CSV_TABLE_COL_NAMES" > gpu.csv

for f in cpu/run-*.log gpu/run-*.log; do
    filename="$(echo "$f" | sed "s/cpu\/run-//g" | sed "s/gpu\/run-//g" | sed "s/.log//g")"
    compiler="$(echo "$filename" | sed "s/-/\n/g" | sed -n 1p)"
    library="$(echo "$filename" | sed "s/-/\n/g" | sed -n 2p)"
    target="$(echo "$filename" | sed "s/-/\n/g" | sed -n 3p)"
    tpc="$(echo "$filename" | sed "s/-/\n/g" | sed -n 4p | sed "s/tpc//g")"
    ranks="$(echo "$filename" | sed "s/-/\n/g" | sed -n 5p | sed "s/mpi//g")"
    threads="$(echo "$filename" | sed "s/-/\n/g" | sed -n 6p | sed "s/mp//g")"

    csv_filename="cpu.csv"

    if [[ "$library" == "OPENCL" ]]; then
        csv_filename="gpu.csv"
    fi

    runtime="$(cat "$f" | tail -n 20 | head -n 1 | sed "s/Wall\ clock\ //g")"

    echo "$compiler,$library,$target,$tpc,$ranks,$threads,$runtime" >> "$csv_filename"
done
