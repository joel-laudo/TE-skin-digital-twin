#!/bin/bash
# FILENAME: GenerateINPS.sub
#SBATCH -A abuganza
#SBATCH -N 4 -n 96 -t 100:00:00
#SBATCH --job-name=GenerateINPs
echo "Ped_1_GenerateINPS.sub"


module load matlab

unset DISPLAY
matlab -nodisplay -singleCompThread -r Ped_2R_Generate_Final_Inflation_INPs_V1