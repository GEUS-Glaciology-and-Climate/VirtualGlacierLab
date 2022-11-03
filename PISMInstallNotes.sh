#........................................
#Authors: syhsv, aso
#Creation date: 2022-11-03
#
#Contents: Notes on PISM installation
#
#The purpose of this document is to facilitate the installation of PISM on 
#the Glacio01 server at GEUS. 
#
#Please also to refer to the PISM manual when installing PISM 
#
#This is a living document, so please feel free to update it according to 
#your experience when installing.   
#........................................

First: Make sure you only have one version of mpi installed. PISM may get confused if there are several versions floating around. Uninstall any extra versions.
You may check which mpi installation is present by typing 'ompi_info' at the command line.

#----------------------------
#Install PISM prerequisites.
#----------------------------

#..........
#Python3
#..........

Make sure python3 is installed, petsc uses python3 and things do not go well if python2 is used. 
Check which version of python you are running: In terminal window, simply start python by typing ‘python’, then ‘enter’. You should be able to see your python version number then. If it is python3, you are good to go, otherwise you need to install python3.
After installing python3, make sure any python calls point to python3 instead of python 2. This may be done by making an alias in your .bashrc file:

alias python=python3
export PYTHONPATH=/home/[user]/local/petsc/lib 

#...........
#Cython
#...........

Apparently, Petsc4python requires cython. The following should take of installing that:
/usr/bin/python3 -m pip install cython

#..........
#PETSc
#.........

Compiling PISM using the system-wide petsc installation did not work very well. Constantine recommends always installing your own petsc version and then building PISM on top of that....

Prerequisites for petsc are:

Make
Python3
C Compiler
Fortran Compiler
Git

Command to test the compilers: (taken from PETSc installation manual https://petsc.org/main/install/install_tutorial/)
printf '#include<stdio.h>\nint main(){printf("cc OK!\\n");}' > t.c && cc t.c && ./a.out && rm -f t.c a.out

While it is recommended that you have functional C++ and Fortran compilers installed, they are not directly required to run PETSc in its default state. If they are functioning, PETSc will automatically find them during the configure stage, however it is always useful to test them on your own. Run the following two commands (again taken from the PETSc installation manual)

printf '#include<iostream>\nint main(){std::cout<<"c++ OK!"<<std::endl;}' > t.cpp && c++ t.cpp && ./a.out && rm -f t.cpp a.out

printf 'program t\nprint"(a)","gfortran OK!"\nend program' > t.f90 && gfortran t.f90 && ./a.out && rm -f t.f90 a.out

If compilers are working, each command should print ‘<compiler_name> OK!’ on the command line.

From your version of ‘/home/[user]/Programs’ use git to get PETSc:

git clone -b release https://gitlab.com/petsc/petsc
Do the following:
cd petsc
petsc_prefix=$HOME/local/petsc
PETSC_DIR=$PWD
PETSC_ARCH=linux-opt
./configure --prefix=${petsc_prefix} --with-cc=mpicc --withcxx=mpicxx --with-fc=mpifort --with-shared-libraries --with-debugging=0 --with-petsc4py --download-f2cblaslapack

#NOTE: ASO had to add --download-openmpi=1  for ./configure to work. We have not rewolved why it was necesarry in that case and not for syhsv

Next, do

export PYTHONPATH=${petsc_prefix}/lib (as suggested by PISM manual)

Then do

make PETSC_DIR=/home/[user]/Programs/petsc PETSC_ARCH=linux-opt all

Now to install the libraries do:

make PETSC_DIR=/home/[user]/Programs/petsc PETSC_ARCH=linux-opt install

For me, this message came up on screen at this point:

To use petsc4py, add /home/[user]/local/petsc/lib to PYTHONPATH

Hence, add

export PYTHONPATH=/home/[user]/local/petsc/lib

to .bashrc file.

Proceed to do make check:

make PETSC_DIR=/home/[user]/Programs/petsc PETSC_ARCH=linux-opt check

This should complete the PETSc installation. Before proceeding to PISM installation, make sure to set PETSC_DIR and PETSC_ARCH in .bashrc file:

export PETSC_DIR=$HOME/Programs/petsc
export PETSC_ARCH=linux-opt
export PATH=$PETSC_DIR/$PETSC_ARCH/bin/:$PATH
export OMPI_MCA_btl=^openib

The last line is some voodoo fix dealing with potential openmpi problems. ASO recommended adding the line; both she and SHL have used it to bypass openmpi problems.

#......................
#Build PISM
#......................

Next, proceed to build PISM itself

First, get the latest source for PISM using Git:

git clone https://github.com/pism/pism.git pism-stable

This creates a directory called pism-stable on your computer.

Proceed to build PISM.

mkdir -p pism-stable/build
cd pism-stable/build
export CC=mpicc
export CXX=mpicxx
cmake -DPism_USE_PROJ=ON -DPism_BUILD_EXTRA_EXECS=ON -DCMAKE_INSTALL_PREFIX=/home/[user]/Models/PISM/pism ..
make -j install

-Here the option Pism_USE_PROJ enables a PISM module which computes longitudes and latitudes of grid boxes.
The option Pism_BUILD_EXTRA_EXECS is needed for the software test suite from the PISM developers to run.


After installing PISM, proceed to the 'Quick tests of the installation' as described in the PISM installation guide.
---------------------------------------------------------------------------
#........................................
#Update to newer versions of PISM:
#........................................

Go to your pism-stable directory (the one created when you did the first download of PISM using Git).
Pull newest version:

git pull

This will update to the latest version of PISM. After git pull:

make -C build install

to recompile and reinstall PISM.

-I have not tried to update and reinstall, but these are the steps suggested by the PISM manual for future reference.
