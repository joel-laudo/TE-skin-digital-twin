#!/bin/sh -l
#SBATCH -A abuganza
#SBATCH -N 2 -n 48 -t 100:00:00
#SBATCH --job-name=Ped1MAPSim42
module load intel/19.1.3.304
module load abaqus/2022
unset SLURM_GTIDS
abaqus double job=Ped1MAPSim42 input=FINAL_Ped_1_Job2_MAP_4NEW.inp user=Ped_1_Simulation_Controller_MAPV3.f mp_mode=mpi interactive
