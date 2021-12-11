#include <kernel_files/macros_cl.cl>

__kernel void set_field
(__global const double* __restrict const density0,
 __global       double* __restrict const density1,
 __global const double* __restrict const energy0,
 __global       double* __restrict const energy1)
{
    __kernel_indexes;

    if(/*row >= (y_min + 1) &&*/ row <= (y_max + 1)
    && /*column >= (x_min + 1) &&*/ column <= (x_max + 1))
    {
        density1[THARR2D(0, 0, 0)] = density0[THARR2D(0, 0, 0)];
        energy1[THARR2D(0, 0, 0)]  = energy0[THARR2D(0, 0, 0)];
    }
}

