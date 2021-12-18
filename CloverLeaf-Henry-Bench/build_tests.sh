echo
echo
echo "While you wait, here are some lyrics from Pink Floyd's 'Time':"
echo "- Ticking away the moments that make up a dull day"
echo "- And you run and you run to catch up with the sun but it's sinking"
echo 
echo
echo "Oh, while you try to contemplate your mortality, you shall be told that logs can be found in builds/."
echo
echo 

set -e

IN_FILE_TEMPLATE=$(cat <<-END
*clover

 state 1 density=0.2 energy=1.0
 state 2 density=1.0 energy=2.5 geometry=rectangle xmin=0.0 xmax=5.0 ymin=0.0 ymax=2.0

 x_cells=960
 y_cells=960

 xmin=0.0
 ymin=0.0
 xmax=10.0
 ymax=10.0

 initial_timestep=0.04
 timestep_rise=1.5
 max_timestep=0.04
 end_time=0.5
 end_step=87
 profiler_on
 tiles_per_chunk ^
 test_problem 2
*endclover
END
)

used_dirs=(mpiobj obj builds results)
for used_dir in "${used_dirs[@]}"; do
    rm -rf "$used_dir"
    mkdir -p "$used_dir"
done

declare -a NAMING_IS_FUN=(
    "GNU|USE_OPENCL|-I$CUDA_PATH/include/CL -I$CUDA_PATH/include -L$CUDA_PATH/lib64|allocations/1.0 gcc/10.2.0 openmpi/4.1.1-gcc8.3.1 cuda/11.1.1 nvhpc/21.7"
    "GNU|USE_OPENMP||allocations/1.0 gcc/10.2.0 cuda/11.1.1 openmpi/4.1.1-gcc8.3.1"
)

TILES_PER_CHUNK_OPTIONS=(1 2 4 8 16 32 64)

idx=0
for item in "${NAMING_IS_FUN[@]}"; do
    # Q: What optimization techniques are these sed calls using?
    # A: Yes.
    compiler_family="$(echo "$item" | sed "s/|/\n/g" | sed -n 1p)"
    dependency="$(echo "$item" | sed "s/|/\n/g" | sed -n 2p)"
    includes="$(echo "$item" | sed "s/|/\n/g" | sed -n 3p)"
    modules="$(echo "$item" | sed "s/|/\n/g" | sed -n 4p)"

    module load "$modules"

    BUILD_UUID="$compiler_family-$dependency"
    BUILD_DIR="builds/$BUILD_UUID"

    mkdir -p "$BUILD_DIR"

    make clean > "$BUILD_DIR/build.log" 2>&1

    make -j 4                        \
         EXTRA_INC="$includes"       \
         COMPILER="$compiler_family" \
         "$dependency"=1 >> "$BUILD_DIR/build.log" 2>&1
    
    mv clover_leaf "$BUILD_DIR"

    cd "$BUILD_DIR"

    for ntilespc in "${TILES_PER_CHUNK_OPTIONS[@]}"; do
        # Q: How are you going to document this?
        # A: Yes.
        echo "$IN_FILE_TEMPLATE" |              \
             sed s/"\^"/$ntilespc/g > clover.in

        chmod +x ./clover_leaf

        # I love finding undocumented features (OCL_SRC_PREFIX)
        OMP_NUM_THREADS=1 OCL_SRC_PREFIX="../../"   \
            ./clover_leaf                    2>&1 | \
            tail -22                                \
            > "../../results/run-$BUILD_UUID-$ntilespc""t.log"

        rm clover.in clover.out
    done

    cd ../../

    module unload "$modules"

    idx=$((idx+1))
done

echo
echo
echo "shhh... There's a starman waiting in the sky."
echo
echo 