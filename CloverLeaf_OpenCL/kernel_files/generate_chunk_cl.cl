#include <kernel_files/macros_cl.cl>

__kernel void generate_chunk
(__global const double * __restrict const vertexx,
 __global const double * __restrict const vertexy,
 __global const double * __restrict const cellx,
 __global const double * __restrict const celly,
 __global       double * __restrict const density0,
 __global       double * __restrict const energy0,
 __global       double * __restrict const xvel0,
 __global       double * __restrict const yvel0,

 __global const double * __restrict const state_density,
 __global const double * __restrict const state_energy,
 __global const double * __restrict const state_xvel,
 __global const double * __restrict const state_yvel,
 __global const double * __restrict const state_xmin,
 __global const double * __restrict const state_xmax,
 __global const double * __restrict const state_ymin,
 __global const double * __restrict const state_ymax,
 __global const double * __restrict const state_radius,
 __global const int    * __restrict const state_geometry,

 const int g_rect,
 const int g_circ,
 const int g_point,

 const int state)
{
    __kernel_indexes;

    if (row >= (y_min + 1) - 2 && row <= (y_max + 1) + 2
    && column >= (x_min + 1) - 2 && column <= (x_max + 1) + 2)
    {
        const double x_cent = state_xmin[state];
        const double y_cent = state_ymin[state];

        if (g_rect == state_geometry[state])
        {
            if (vertexx[1 + column] >= state_xmin[state]
            && vertexx[column] <  state_xmax[state]
            && vertexy[1 + row]    >= state_ymin[state]
            && vertexy[row]    <  state_ymax[state])
            {
                energy0[THARR2D(0, 0, 0)] = state_energy[state];
                density0[THARR2D(0, 0, 0)] = state_density[state];

                //unrolled do loop
                xvel0[THARR2D(0, 0, 1)] = state_xvel[state];
                yvel0[THARR2D(0, 0, 1)] = state_yvel[state];

                xvel0[THARR2D(1, 0, 1)] = state_xvel[state];
                yvel0[THARR2D(1, 0, 1)] = state_yvel[state];

                xvel0[THARR2D(0, 1, 1)] = state_xvel[state];
                yvel0[THARR2D(0, 1, 1)] = state_yvel[state];

                xvel0[THARR2D(1, 1, 1)] = state_xvel[state];
                yvel0[THARR2D(1, 1, 1)] = state_yvel[state];
            }
        }
        else if (state_geometry[state] == g_circ)
        {
            double x_pos = cellx[column]-x_cent;
            double y_pos = celly[row]-y_cent;
            double radius = SQRT(x_pos*x_pos + y_pos*y_pos);

            if (radius <= state_radius[state])
            {
                energy0[THARR2D(0, 0, 0)] = state_energy[state];
                density0[THARR2D(0, 0, 0)] = state_density[state];

                //unrolled do loop
                xvel0[THARR2D(0, 0, 1)] = state_xvel[state];
                yvel0[THARR2D(0, 0, 1)] = state_yvel[state];

                xvel0[THARR2D(1, 0, 1)] = state_xvel[state];
                yvel0[THARR2D(1, 0, 1)] = state_yvel[state];

                xvel0[THARR2D(0, 1, 1)] = state_xvel[state];
                yvel0[THARR2D(0, 1, 1)] = state_yvel[state];

                xvel0[THARR2D(1, 1, 1)] = state_xvel[state];
                yvel0[THARR2D(1, 1, 1)] = state_yvel[state];
            }
        }
        else if (state_geometry[state] == g_point)
        {
            if (vertexx[column] == x_cent && vertexy[row] == y_cent)
            {
                energy0[THARR2D(0, 0, 0)] = state_energy[state];
                density0[THARR2D(0, 0, 0)] = state_density[state];

                //unrolled do loop
                xvel0[THARR2D(0, 0, 1)] = state_xvel[state];
                yvel0[THARR2D(0, 0, 1)] = state_yvel[state];

                xvel0[THARR2D(1, 0, 1)] = state_xvel[state];
                yvel0[THARR2D(1, 0, 1)] = state_yvel[state];

                xvel0[THARR2D(0, 1, 1)] = state_xvel[state];
                yvel0[THARR2D(0, 1, 1)] = state_yvel[state];

                xvel0[THARR2D(1, 1, 1)] = state_xvel[state];
                yvel0[THARR2D(1, 1, 1)] = state_yvel[state];
            }
        }
    }
}

__kernel void generate_chunk_init
(__global       double * density0,
 __global       double * energy0,
 __global       double * xvel0,
 __global       double * yvel0,
 __global const double * state_density,
 __global const double * state_energy,
 __global const double * state_xvel,
 __global const double * state_yvel)
{
    __kernel_indexes;

    if(row >= (y_min + 1) - 2 && row <= (y_max + 1) + 2
    && column >= (x_min + 1) - 2 && column <= (x_max + 1) + 2)
    {
        energy0[THARR2D(0, 0, 0)] = state_energy[0];
        density0[THARR2D(0, 0, 0)] = state_density[0];
        xvel0[THARR2D(0, 0, 1)] = state_xvel[0];
        yvel0[THARR2D(0, 0, 1)] = state_yvel[0];
    }
}

