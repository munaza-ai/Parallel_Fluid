#!/bin/bash
#SBATCH --job-name=benchmark_par_fluid
#SBATCH --error=logs4/%x_%j.err
#SBATCH --output=logs4/%x_%j.out
#SBATCH --nodes=1 #We set the number of nodes equal to 1 to avoid loss of performance due to communication between nodes!!!
#SBATCH --ntasks-per-node=1 #We run the simulation for 1, 2, 4, 8 tasks per node!!!!
##SBATCH --ntasks-per-socket=1 #memory system work.
#SBATCH --cpus-per-task=1
#SBATCH --distribution=block:block
#SBATCH --mem-bind=local
#SBATCH --hint=nomultithread
#SBATCH --time=00:35:00               # Time limit hrs:min:sec
#SBATCH -p dcgp_usr_prod


module purge 
module load netcdf-fortran/4.6.1--gcc--12.2.0-spack0.22
#module load netcdf-fortran/4.6.1--openmpi--4.1.6--gcc--12.2.0-spack0.22
module load gcc/12.2.0 

#export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export OMP_NUM_THREADS=1
export GOTO_NUM_THREADS=1


#Compile:
make

#Run:
srun ./model
