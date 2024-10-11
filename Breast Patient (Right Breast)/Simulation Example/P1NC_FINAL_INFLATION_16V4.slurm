#!/bin/sh -l

#SBATCH -A abuganza
#SBATCH -N 1 -n 2 -t 100:00:00
#SBATCH --job-name=P1NCExpJob16
module load intel/19.1.3.304
module load abaqus/2022

unset SLURM_GTIDS
abaqus double job=P1NC_ExpJob16 input=FINAL_P1NC_Job16V4.inp user=P1NC_Simulation_Controller_16V1.f mp_mode=mpi interactive