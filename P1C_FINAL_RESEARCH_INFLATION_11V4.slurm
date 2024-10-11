#!/bin/sh -l

#SBATCH -A abuganza
#SBATCH -N 1 -n 2 -t 100:00:00
#SBATCH --job-name=P1CExpJob11
module load abaqus/2022

unset SLURM_GTIDS
abaqus double job=P1CExpJob11 input=FINAL_P1C_Job11V4.inp user=1C_Research_Results_Simulation_Controller_11V4.f mp_mode=mpi interactive