# Cloverleaf

A description of what Cloverleaf is [here.](https://github.com/UK-MAC/CloverLeaf/blob/master/documentation.txt)

## References

Journal and conference papers
* [Zotero link](https://www.zotero.org/groups/4507615/comp-physics/collections/BJBJM25B)

Repositories
* [Original repo](https://github.com/UK-MAC/CloverLeaf)
* https://github.com/Mantevo/CloverLeaf
* https://github.com/orgs/UoB-HPC/repositories
* https://github.com/orgs/UoB-HPC/repositories?q=clover&type=source&language=&sort=

[Main Bristol Cpp/OpenCL repo](https://github.com/UoB-HPC/CloverLeaf)

Projects
* https://mantevo.github.io/
* http://uob-hpc.github.io/

## How to run 

For [this](https://github.com/UoB-HPC/cloverleaf_openmp_target) one I was able to run on

* Expanse
	* `srun --partition=debug --account=cit193 --pty --nodes=1 --ntasks-per-node=64 -t 00:30:00 --wait=0 --export=ALL /bin/bash`
	* `git clone https://github.com/UoB-HPC/cloverleaf_openmp_target.git`
	* `module unload gcc cmake cuda pgi openmpi gpu`
	* `module load cpu/0.15.4  gcc/9.2.0 openmpi cmake/3.18.2`
	* `cmake -Bbuild -H. -DCMAKE_BUILD_TYPE=Release`
	* Open `Cmakelists.txt` and remove the offload flag [here](https://github.com/UoB-HPC/cloverleaf_openmp_target/blob/1a61864290c1fa0ab3e1b4501dcb245e2c9f521c/CMakeLists.txt#L132] so that line 132 reads `set(OMP_OFFLOAD_FLAGS )
	* `cmake --build build --target clover_leaf --config Release`
	* `export OMPI_COMM_WORLD_RANK=0` 
	* `srun -n 1 ./build/clover_leaf --file InputDecks/clover_bm16_short.in`

* It works on Summit as well
* However, I don't think it has the `tiles` parameters


For [this one](https://github.com/UoB-HPC/CloverLeaf) using gcc, openmpi, cuda
* openmp

* Bridges2
	* `interact --ntasks-per-node=1 --partition RM-shared -t 01:00:00`
	* `module load allocations/1.0 gcc/10.2.0 openmpi/4.1.1-gcc8.3.1 cuda/11.1.1` 
	* 

* Some file differences

```
-#include "../kernels/update_tile_halo_kernel.c"
+#include "../kernels/update_tile_halo_kernel.cc"
```


