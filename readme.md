# FVM-RISCV

* Spencer Bryngelson and Hyesoon Kim

## Step 0: What we are doing

* Testing different architectures for a specific computational method (FVM)
  * Method: Finite volume method (solves hyperbolic PDEs that are conservation laws)
    * Good example problems
      * Compressible flow equations: Euler equations, which is just a simpilification of Navier--Stokes in the no-viscosity limit
      * Burgers' equation 

    * There are different finite volume methods
      * Examples
        * Standard linear finite volume
        * Flux limiters
        * Slope limiters
        * Godunov methods
        * Reconstruction schemes (MUSCL/WENO) + Riemann solvers (HLL/HLLC/Roe/etc.)
      * References
        * Wikipedia/Scholarpedia
        * Books: 
          * In the Box -> People/Spencer/finite_volume_methods or books/finite_volume
          * OR Search "Leveque" on the Zotero

* We want to take a rather straightforward implementation of the above method and benchmark/test it on 
  * Different hardware (Intel CPU, AMD CPU, different NVIDIA GPU, etc.)
    * This is also why we applied for access to CRNCH/ROGUES gallary (they have wacky stuff), like ARM CPUs (a couple different ones, actually)
    * Also hope for AMD GPU, but not sure yet

  * Want the implementation to be sufficiently straightforward that we can mess around "a bit" with
    * Method: Meaning different FVM variations (per above)
    * Optimization: Meaning tiling, and other algorithmic optimizations one might make for a given architecture, or just in genereal


## Step 1: Identify benchmarks

* Need to identify codebases that we will use for benchmarking/testing (one or two or three), "mini-apps" are often good for this
  * Some examples in MSTeams message
    * https://github.com/adamdempsey90/fvm
    * https://uk-mac.github.io/CloverLeaf/
    * https://uk-mac.github.io/TeaLeaf/
    * https://asc.llnl.gov/codes/proxy-apps/lulesh
    * https://github.com/lanl/PENNANT
    * https://github.com/Mantevo/miniFE
    * CLAWPACK!!!! https://github.com/orgs/clawpack/repositories

  * Requirements: That they can actually run on the hardware we have access to. 
    * Best case: without too much work on our part
    * For example: we need these codes to be able to run via OpenCL or CUDA for GPU support
      * At the same time, same codebase needs to run on CPUs
      * If it has MPI: Somehow try to be sure it isn't effecting performance 

  * Preference: That the codebase perhaps either has (or could easily have) different "methods" per above subsection

  * How to find these things: Google, Github, Gitlab, etc.

  * Before spending *too* much time on any one code, make sure you can actually compile it and run it on some standard hardware (your laptop, Phoenix, etc.) 

## Step 1.5: Document them

Document
* what each benchmark is capable of
* what hardware it should be able to run on (hopefully everything)
* what methods it has in it
* how "complicated it is"

## Step 2: Run and optimize benchmarks 

Run
* Run each benchmark and each method within each benchmark using appropriate compilers on different hardware 
  * Intel CPU gets Intel compiler, for example
  * Nvidia GPU gets Cuda compiler

Optimize
* Identify optimization opportunities for the different codes
  * This will be partially hardware dependent (e.g., GPUs vs. x86 vs. ARM would likely see some different optimizations)
* Implement some of them and see what happens


