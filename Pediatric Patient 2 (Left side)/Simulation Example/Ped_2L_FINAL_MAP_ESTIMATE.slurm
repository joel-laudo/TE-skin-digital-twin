#!/bin/sh -l

#SBATCH -A abuganza
#SBATCH -N 1 -n 24 -t 120:00:00
#SBATCH --job-name=Ped2LExpJobMAPV2
module load intel/19.1.3.304
module load abaqus/2022

unset SLURM_GTIDS
abaqus double job=Ped_2L_ExpJobMAPV2 input=FINAL_Ped_2L_Job1_MAP_V2.inp user=Ped_2L_FINAL_Simulation_Controller_MAP.f mp_mode=mpi interactive