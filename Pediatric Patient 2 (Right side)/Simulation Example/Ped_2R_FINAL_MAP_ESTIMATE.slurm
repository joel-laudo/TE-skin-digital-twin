#!/bin/sh -l

#SBATCH -A abuganza
#SBATCH -N 1 -n 24 -t 120:00:00
#SBATCH --job-name=Ped2RExpJobMAPV3
module load intel/19.1.3.304
module load abaqus/2022

unset SLURM_GTIDS
abaqus double job=Ped_2R_ExpJobMAPV3 input=FINAL_Ped_2R_Job1_MAP_V3.inp user=Ped_2R_FINAL_Simulation_Controller_MAP.f mp_mode=mpi interactive