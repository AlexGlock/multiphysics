                            
# Multiphysics Code

This repo contains matlab code for multiphysics simulations. The folder ``electro-thermal`` contains an example for the Cell method coupling of stationary currents and
thermal propagation.

## Electro-Thermal

# The electromagnetic solution first

Calculation of the electric scalar Potential:

<img src="pictures/potential.png" alt="" width=500 height=500> 

and the stationary current densities:

<img src="pictures/current.png" alt="" width=500 height=500>

# Thermal coupling

Coupling via power loss over the primal-edges/dual-surfaces:

<img src="pictures/power.png" alt="" width=500 height=500>

Solving the thermal problem with powerloss as right hand side

<img src="pictures/thermal.png" alt="" width=500 height=500>

ToDo: find error in thermal system ...