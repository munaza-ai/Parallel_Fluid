
#FC = gfortran
FC = nvfortran

#PROFIL := -fprofile-arcs -ftest-coverage #-fprofile-generate
#FCFLAGS = -O0 -Wall -pedantic -fcheck=all -fbacktrace  $(PROFIL)-I. `nf-config --fflags` (profiling the code directly
#FCFLAGS = -O0 -Wall -pedantic -fcheck=all -fbacktrace -I. `nf-config --fflags` #without optimization
#FCFLAGS = -Ofast -I. `nf-config --fflags` -fPIC #for ofast

#FCFLAGS = -Ofast -fopenacc -I. `nf-config --fflags` -fPIC
FCFLAGS = -Ofast -I. `nf-config --fflags` -fPIC
LDFLAGS = -L`nc-config --libdir` `nf-config --flibs`  #-L /leonardo/prod/spack/06/install/0.22/linux-rhel8-icelake/gcc-12.2.0/netcdf-fortran-4.6.1-resb6kl33jm3j5jlfi4ssuqxom53xwra/bin/nf-config


#module purge
#module load netcdf-fortran/4.6.1--hpcx-mpi--2.19--nvhpc--24.5
#module load gcc/12.2.0
#module load nvhpc
#module load binutil (system bin not work for nv


all: model

model : model.f90 module_parameters.o module_types.o module_physics.o \
        module_output.o
	$(FC) $(FCFLAGS) $^ -o $@ $(LDFLAGS)

module_parameters.o : module_parameters.f90
	$(FC) $(FCFLAGS) $< -c

module_types.o : module_types.F90 module_parameters.o
	$(FC) $(FCFLAGS) $< -c

module_output.o : module_output.F90 module_physics.o
	$(FC) $(FCFLAGS) $< -c

module_physics.o : module_physics.f90 module_types.o
	$(FC) $(FCFLAGS) $< -c

clean :
	rm -f *.o *.mod model *.nc

