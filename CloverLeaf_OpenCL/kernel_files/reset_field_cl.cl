#include <kernel_files/macros_cl.cl>

__kernel void reset_field
(__global       double* __restrict const density0,
 __global const double* __restrict const density1,
 __global       double* __restrict const energy0,
 __global const double* __restrict const energy1,
 __global       double* __restrict const xvel0,
 __global const double* __restrict const xvel1,
 __global       double* __restrict const yvel0,
 __global const double* __restrict const yvel1)
{
    __kernel_indexes;

    if(/*row >= (y_min + 1) &&*/ row <= (y_max + 1) + 1
    && /*column >= (x_min + 1) &&*/ column <= (x_max + 1) + 1)
    {
        xvel0[THARR2D(0, 0, 1)] = xvel1[THARR2D(0, 0, 1)];
        yvel0[THARR2D(0, 0, 1)] = yvel1[THARR2D(0, 0, 1)];
    }

    if(row <= (y_max + 1)
    && column <= (x_max + 1))
    {
        density0[THARR2D(0, 0, 0)] = density1[THARR2D(0, 0, 0)];
        energy0[THARR2D(0, 0, 0)]  = energy1[THARR2D(0, 0, 0)];
    }
}

