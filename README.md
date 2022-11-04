# VirtualGlacierLab
Infrastructure for the Virtual Glacier Lab.

##Practical usage:

### Choosing number of cores to use and which cores to use:
*Example:*  mpiexec -n 4 taskset -c 37-41 pismr -i pism_Greenland_5km_v1.1.nc

### How to mount your M-drive:
*Example:*  sudo mount -t cifs -o username=USR //netapp.geus.dk/Brugere2/USR /media/USR/

Remember to unmount before changing your password.

![Virtual Glacier Lab and GMMI](https://raw.githubusercontent.com/GEUS-Glaciology-and-Climate/VirtualGlacierLab/main/Figures/GMMILogo-Farve.png)


