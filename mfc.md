# Benchmarking different FVM + Hardware combos using MFC

* 2D Case
* 1000 x 1000?
* One component
* Sort of imitating [this](https://github.com/UK-MAC/CloverLeaf/blob/master/documentation.txt)

## FVMs to test

WENO
* WENO1
* WENO3
* WENO5
* WENO5 + mp_weno
* WENO5 + mp_weno + mapped_weno

Then the above + 
* HLL
* HLLC

## Hardware to test

**Note: Take off ACC flag for CPU runs!**

* Summit V100 (1x GPU, 1MPI rank)
* Summit Power9 Core (1x CPU core)
* Bridges2 CPU Regular Memory Node: AMD EPYC 7742 (1x CPU core)
* Bridges2 GPU Node Running using CPU: Intel Gold 6248 Cascade Lake (1x CPU core)

## Compiler options

**Always use max. optimization flags like `-fast` or `-O3`**

GPU
* Summit V100: nvhpc

CPU (take out `-acc` flag)
* Summit CPU: compilers: `XL` (e.g. see [here](https://www.ibm.com/docs/el/xl-c-and-cpp-aix/16.1?topic=reference-compiler-options), `gcc`, `nvhpc`, `llvm`
* Bridges2 CPU Regular Memory Node using AMD CPU: Run using GCC and `flang` (see Bridges2 User guide,
      `openmpi/4.0.2-clang2.1` and `aocc/2.3.0`)
* Bridges2 GPU Node Running using Intel CPU: Run using GCC and Intel compilers


## What to document

How to do it 
* Use nvtx range for GPU
* Use Fortran timing routine for CPU

What to document
* Wall time for WENO+Riemann

## Computers

Bridges2
* Get an interactive GPU node: `interact --ntasks-per-node=5 --gres=gpu:v100-32:1 --partition GPU-shared -t 01:00:00`
* Get an interactive CPU node: `interact --ntasks-per-node=1 --partition RM-shared -t 01:00:00`
then `mpirun -n 1 simulation`



