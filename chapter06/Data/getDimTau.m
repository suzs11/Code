function getDimTau( inputPath, outputRow, outputCol)
% This function find the optimal Dim and Tau of Recurrence Plots of input images

% inputPath: the folder containing the malware sequences
% Examples of inputPath: 
%     inputPath = 'Data_128_from_256_from_256_seq';
%     inputPath = 'Data2_128_from_256_from_256_seq';

% outputPath is automatically generated, using [inputPath, '_rc_optDimTau']

% For every instance of a subfoder inside inputPath
% Step 1 (done): find the optimal time delay tau of every instance using mdDelay. 
% Step 2 (not done yet): find the optimal dimension D of every instance using mdFnn
% Step 3 (easy to do after step 2): generate RP of instances using the optimal delay tau and dimension D found by steps 1 and 2.


% Typical run of mdDelay and mdFnn:
% tau = mdDelay(data, ’maxLag’, 25, ’plottype’, ’all’);
% [fnnPerc, embTimes] = mdFnn(data, 15, 'maxEmb', 10, 'numSamples', 500, 'Rtol', 10, 'Atol', 2, 'doPlot', true);


% This is for parallel computing in XSEDE settings
% p = gcp('nocreate'); 
% % if there is no parallel pool, create one
% if isempty(p)
%     profileName = 'local';
%     numWorkers = nw;
%     poolobj = startPool(profileName, numWorkers);
% end
addpath(genpath(pwd))
currentFolder = pwd;

% Get a list of all files and folders in this folder.
files = dir(inputPath);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
% get rid of '.' and '..'
cond = zeros(1,length(subFolders));
for i = 1:length(subFolders)
    cond(i) = any(strcmp(subFolders(i).name, {'.', '..'}));
end
subFolders = subFolders(~cond);
for i = 1:length(subFolders)
    disp(subFolders(i).name);
end

% for UNIX
outputPath = [inputPath, '_rc_optDimTau_', num2str(outputRow), '_', num2str(outputCol)];
for k = 1:length(subFolders)    
    className = subFolders(k).name;
    disp(className);
    cd([inputPath, '/', subFolders(k).name]);
    % for each subfolder
    fList = ls('*bytes.png');
    fileList = strsplit(fList);
    fileList = fileList(1:end-1);
    fileList = fileList';
    numfiles = size(fileList,1); 
    
    outputFolder = [currentFolder, '/', outputPath, '/', subFolders(k).name];
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    
    ptype = 'none';    
    % Step 1: find the optimal delay tau
    maxDelay = 30;
    criterion = 'firstDrop';  
    kDelay = zeros(1,numfiles);
    parfor j = 1:numfiles
        file = deblank(fileList{j,:});        
        I = imread(file);
        % convert I to 1D sequence, row-major
        [row, col] = size(I);        
        data1 = reshape(I', [row*col, 1]);
 	  if length(data1)<1000000
        data2 = imresize(data1,0.005);
        else
        data2 = imresize(data1,(10000/length(data1)))
        end
        data = im2double(data2);
        % get the optimal tau   
        tau = w_mdDelay(data, 'criterion', criterion, 'maxLag', maxDelay, 'numBins', 128, 'plottype', ptype);
        kDelay(j) = tau;     
        % step 2: find the optimal embedding dimension
        [fnnPerc, embTimes] = mdFnn(data, tau, 'maxEmb', 15, 'doPlot', false, 'numSamples', 500, 'Rtol', 10, 'Atol', 2); 
        % get the min of fnnPerc
        minFnnP = min(fnnPerc);
        dim_1 = find(fnnPerc==minFnnP, 1, 'first');        
        idx = findchangepts(fnnPerc, 'Statistic', 'rms', 'MinDistance', 3);
        dim_2 = idx(1);
        dim = min([dim_1, dim_2]);
        
        disp([num2str(j) '  tau= ', num2str(tau), '  ', 'dim= ', num2str(dim), '   ', 'dim_1= ', num2str(dim_1), ' dim_2= ', num2str(dim_2), '  ', num2str(fnnPerc)]);  
        
        % step 3: generate RPs of size outputRow*outputCol using the optimal tau and dim
        % The RC files is written into outputFolder = [currentFolder, '/', outputPath, '/', subFolders(k).name];
        % outputFolder example:  Data2_128_from_256_from_256_seq_rc_optDimTau_256_256        
        [row, col] = size(I);
        % phase space 
        signal = data;
        ps  = phasespace(signal,dim,tau);
        % recurrence plot
        temp_J = pdist(ps);
        temp_J = squareform(temp_J);
        if isa(temp_J, 'double')
            temp_J = uint8(255 * mat2gray(temp_J));            
        end        
        % resize recurrence plot to (outputRow, outputCol)
        temp_J = imresize(temp_J, [outputRow, outputCol], 'bilinear');                   
        outputFile = [outputFolder, '/', 'resized_rc_', file];
        imwrite(temp_J,outputFile); 
    end
    
    % Calculate the statistic of delay in a class       
    [hFreq, hTau] = aux(kDelay, maxDelay, numfiles);
    hold off;
    
    cd(currentFolder);
end

p = gcp('nocreate'); 
if isempty(p)==false
    % closing the paralle pool
    closePool(poolobj);
end

    function [hFreq, hTau] = aux(kDelay, maxDelay, numfiles)
        % This funciton takes results of delay and finds the highest frequency of tau and the most frequent tau
        % kDelay: list of delays in a subfolder (class)
        % maxDelay: max allowed delay
        % numfiles: number of malware binary files in a subfolder (class)
        kDelay = kDelay';
        [GC,GR] = groupcounts(kDelay);
        numC = length(GC);
        Y = zeros(1, maxDelay);
        for kk = 1:numC
            Y( GR(kk) ) = GC(kk);
        end
        % Plotting frequency of tau vs tau
        plot(1:maxDelay, Y/numfiles);
        hold on
        % Get the highest frequency of tau and the most frequent tau
        [hFreq, hFreqTau_pos] = max(GC);
        hFreq = hFreq/numfiles;
        hTau = GR(hFreqTau_pos);
        
        disp(['Class ', subFolders(k).name, ' Min tau = ', num2str(min(kDelay)), ' Max tau = ', num2str(max(kDelay)), ' Avg = ', num2str(mean(kDelay)), ' Std = ', num2str(std(kDelay)), ...
            ' highest Frequency = ', num2str(hFreq), ' most frequent Tau = ', num2str(hTau) ]);
        disp(['Frequencies of Tau:', num2str(GC'/numfiles)]);
        disp([' ']);
        
        
    end

end

