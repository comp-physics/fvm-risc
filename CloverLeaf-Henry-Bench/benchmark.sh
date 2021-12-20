
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

 x_cells=2000
 y_cells=2000

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

#function module() {
#    echo module "$@"
#}

module load cuda
#CUDA_HOME="$CUDA_PATH"
CUDA_INC_LIB="-I$CUDA_HOME/include/CL -I$CUDA_HOME/include -L$CUDA_HOME/lib64"
module unload cuda

declare -a NAMING_IS_FUN=(
# OpenCL w/ Cuda
    "GCC|GNU|USE_OPENCL|$CUDA_INC_LIB|allocations/1.0 gcc/10.2.0 openmpi/4.1.1-gcc8.3.1 cuda/11.1.1"
    "NVHPC|GNU|USE_OPENCL|$CUDA_INC_LIB|allocations/1.0 nvhpc/21.7 openmpi/4.0.5-nvhpc21.7 cuda/11.1.1"
    "INTEL|INTEL|USE_OPENCL|$CUDA_INC_LIB|allocations/1.0 intel/2021.3.0 intelmpi/20.4-intel20.4 cuda/11.1.1"
    "AMD|GNU|USE_OPENCL|$CUDA_INC_LIB|allocations/1.0 aocc/2.3.0 openmpi/4.0.2-clang2.1 cuda/11.1.1"
# OpenMP
    "GCC|GNU|USE_OPENMP||allocations/1.0 gcc/10.2.0 openmpi/4.1.1-gcc8.3.1"
    "NVHPC|GNU|USE_OPENMP||allocations/1.0 nvhpc/21.7 openmpi/4.0.5-nvhpc21.7"
    "INTEL|INTEL|USE_OPENMP||allocations/1.0 intel/2021.3.0 intelmpi/20.4-intel20.4"
    "AMD|GNU|USE_OPENMP||allocations/1.0 aocc/2.3.0 openmpi/4.0.2-clang2.1"
)

declare -a OPTIMIZATION_LEVELS=(
    "STANDARD"
    "FAST|fast"
)

declare -a TILES_PER_CHUNK_OPTIONS=(1 2 4 8 16 32 64 128)

idx=0
for item in "${NAMING_IS_FUN[@]}"; do
    # Q: What optimization techniques are these sed calls using?
    # A: Yes.
    compiler_UI_name="$(echo "$item" | sed "s/|/\n/g" | sed -n 1p)"
    compiler_family="$(echo "$item" | sed "s/|/\n/g" | sed -n 2p)"
    dependency="$(echo "$item" | sed "s/|/\n/g" | sed -n 3p)"
    includes="$(echo "$item" | sed "s/|/\n/g" | sed -n 4p)"
    modules="$(echo "$item" | sed "s/|/\n/g" | sed -n 5p)"

    for optimization_level_item in "${OPTIMIZATION_LEVELS[@]}"; do
        optimization_level="$(echo "$optimization_level_item" | sed "s/|/\n/g" | sed -n 1p)"
        makefile_target="$(echo "$optimization_level_item" | sed "s/|/\n/g" | sed -n 2p)"
        BUILD_UUID="$compiler_UI_name-$(echo $dependency | sed "s/USE_//g")-$optimization_level"
        BUILD_DIR="builds/$BUILD_UUID"

	    module unload $(module list 2>&1 | sed -n 3p | sed "s/[0-9])//g")
        module load   $modules

        echo -en "Building $BUILD_DIR..."

        mkdir -p "$BUILD_DIR"

        make clean > "$BUILD_DIR/build.log" 2>&1

        make $makefile_target -j $(nproc) \
            EXTRA_INC="$includes"         \
            COMPILER="$compiler_family"   \
            "$dependency"=1 >> "$BUILD_DIR/build.log" 2>&1

        mv clover_leaf "$BUILD_DIR"

        cd "$BUILD_DIR"

        chmod +x ./clover_leaf

        RANKS_AND_THREAD=("1 $(nproc)")

        if [ "$dependency" == "USE_OPENMP" ]; then
            RANKS_AND_THREAD+=("$(nproc) 1")
        fi

        for ntilespc in "${TILES_PER_CHUNK_OPTIONS[@]}"; do
            for rank_and_thread in "${RANKS_AND_THREAD[@]}"; do
                mpi_ranks=$(echo "$rank_and_thread" | sed "s/\ /\n/g" | sed -n 1p)
                mp_threads=$(echo "$rank_and_thread" | sed "s/\ /\n/g" | sed -n 2p)

                RUN_UUID="$BUILD_UUID-$ntilespc""tpc-$mpi_ranks""mpi-$mp_threads""mp"

                echo -en "\rRunning $RUN_UUID..."

                # Q: How are you going to document this?
                # A: Yes.
                echo "$IN_FILE_TEMPLATE" |             \
                    sed s/"\^"/$ntilespc/g > clover.in

                # I love finding undocumented features (OCL_SRC_PREFIX)
                export OMP_NUM_THREADS=$mp_threads
                export OCL_SRC_PREFIX="../../"

                mpirun -v -n $mpi_ranks -bind-to none  \
                    ./clover_leaf   2>&1 | \
                    tail -22               \
                    > "../../results/run-$RUN_UUID.log"

                rm clover.in clover.out
            done
        done

        echo -e "\rDone with $BUILD_UUID.                                        "

        cd ../../
    done

    idx=$((idx+1))
done

tar -zcvf results.tar.gz results/

echo
echo
echo "shhh... There's a starman waiting in the sky."
echo
echo 
