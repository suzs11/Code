#!/bin/bash
#SBATCH -J ave9128
#SBATCH --nodes=4
#SBATCH -p low
#SBATCH --ntasks-per-node=4
#SBATCH --time=150:00:00
#SABTCH --output=%j.log
#SBATCH --mail-user=suzs11@163.com
#SBATCH --mail-type=ALL

export SLURM_CPUS_PER_NODE
export PATH=/public/software/matlab2019/bin:$PATH 

matlab -nodisplay -nosplash -nodesktop -r "run('./run_getDimTau.m');exit;"
