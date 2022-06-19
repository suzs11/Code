#!/bin/bash 
#SBATCH -J 2resnet18
#SBATCH --nodes=1
#SBATCH -p low
#SBATCH --ntasks-per-node=20
#SBATCH --time=120:00:00
#SABTCH --output=%j.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=suzs11@163.com

export SLURM_CPUS_PER_NODE
export PATH=/public/software/matlab2019/bin:$PATH


matlab -nodisplay -nosplash -nodesktop -logfile 2resnet.log -r "run('./OptCONet128N.m');exit;"

echo "This is end"
date

