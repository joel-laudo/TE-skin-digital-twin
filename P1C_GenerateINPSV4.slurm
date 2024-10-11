#!/bin/bash
# FILENAME: GenerateINPS.sub
#SBATCH -A abuganza
#SBATCH -N 1 -n 24 -t 100:00:00
#SBATCH --job-name=GenerateINPs
echo "GenerateINPS.sub"


module load matlab

unset DISPLAY
matlab -nodisplay -singleCompThread -r P1C_Generate_Final_Inflation_INPs_V4