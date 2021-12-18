# Setup
mkdir -p mpiobj obj

# OpenCL
module load allocations/1.0 gcc/10.2.0 openmpi/4.1.1-gcc8.3.1 cuda/11.1.1 nvhpc/21.7
make clean
make -j 4 COMPILER=GNU USE_OPENCL=1

# OpenMP
make clean
module unload gcc openmpi cuda nvhpc
module load allocations/1.0 gcc/10.2.0 cuda/11.1.1 openmpi/4.1.1-gcc8.3.1
make -j 4 COMPILER=GNU USE_OPENMP=1
