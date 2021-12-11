#include <kernel_files/macros_cl.cl>

__kernel void ideal_gas
(__global const double * __restrict const density,
 __global const double * __restrict const energy,
 __global       double * __restrict const pressure,
 __global       double * __restrict const soundspeed)
{
    __kernel_indexes;

    if (/*row >= (y_min + 1) &&*/ row <= (y_max + 1)
    && /*column >= (x_min + 1) &&*/ column <= (x_max + 1))
    {
        double v, pres_by_ener, pres_by_vol, ss_sq;

        v = 1.0/density[THARR2D(0,0,0)];

        pressure[THARR2D(0,0,0)] = (1.4 - 1.0)
            *density[THARR2D(0,0,0)]*energy[THARR2D(0,0,0)];

        pres_by_ener = (1.4 - 1.0)*density[THARR2D(0,0,0)];

        pres_by_vol = - density[THARR2D(0,0,0)]*pressure[THARR2D(0,0,0)];

        ss_sq = v*v*(pressure[THARR2D(0,0,0)]*pres_by_ener - pres_by_vol);

        soundspeed[THARR2D(0,0,0)] = SQRT(ss_sq);
    }
}

