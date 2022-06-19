% This is the utility for .sh to call to getDimTau.m to 
% (1) find the optimal tau and Dim
% (2) generate RPs using the optimal tau and dim

clear
addpath=(genpath(pwd));
%nw = str2num(getenv('SLURM_CPUS_ON_NODE'));
%disp(['Num of CPUs on Node = ', num2str(nw)]);
%inputPath = getenv(inputPath);
inputPath = '../maldata9';
outputRow = 224;
outputCol = 224;
getDimTau(inputPath, outputRow, outputCol)


