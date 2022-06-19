function delay = mdDelay(data, varargin)
%MDDELAY Estimates time delay for embedding of multivariate times series.
%   The function plots the mutual information for multivariate times series
%   data, so the user can estimate the optimal value of the time delay for
%   embedding the data. The function also returns an estimate of the
%   optimal time delay, using simple methods, such as the mean of the lag
%   for which the auto mutual information for each of the variables
%   (columns) is less than a threshold, such as 1/e.
%
%   This function currently implements the uniform multivariate embedding
%   method.
%
%   Inputs:
%   Required arguments:
%     data - a matrix with multiple timeseries, one in each column.
%
%   Optional arguments:
%     maxLag: The maximum time lag for which AMI is computed. Default = 10.
%
%     numBins: The number of bins used to construct the histograms for
%       computing AMI. Default = 10.
%
%     criterion: The citerion used for finding the optimal delay. Possible
%     values are:
%       'firstBelow' to use the lowest delay at which the AMI
%         function drops below the value set by the threshold parameter.
%       'localMin' to use the position of the first local minimum of the
%         AMI function.
%       Default: 'firstBelow'
%
%     threshold: The threshold value to select the delay when AMI drops
%       below threshold. Default = exp(-1)
%
%     plottype: Determines how the AMI is plotted. Possible values are
%     'mean', 'all', 'both', 'none'. Default = 'mean'
%
%   Outputs:
%     delay: The estimated optimal delay given the input and critera.
%
%   Version: 1.0, 22 June 2018
%   Authors:
%     Sebastian Wallot, Max Planck Insitute for Empirical Aesthetics
%     Dan Moenster, Aarhus University
%
%   Reference:
%     Wallot, S., \& M{\o}nster, D. (2018). Calculation of average mutual
%     information (AMI) and false-nearest neighbors (FNN) for the
%     estimation of embedding parameters of multidimensional time-series in
%     Matlab. Front. Psychol. - Quantitative Psychology and Measurement
%     (under review)


%
% Parse and validate the input
%
parser = inputParser;

% Optional parameter: plottype
defaultPlotType = 'mean';
validPlotTypes = {'mean', 'all', 'both', 'none'};
checkPlotType = @(x) any(validatestring(x, validPlotTypes));

% Optional parameter: numBins
defaultNumBins = 10;
checkNumBins = @(x) validateattributes(x, {'numeric'}, {'positive', 'numel', 1});

% Optional parameter: maxLag
defaultMaxLag = 10;
checkMaxLag = @(x) validateattributes(x, {'numeric'}, {'positive', 'numel', 1});

% Optional parameter: criterion
defaultCriterion = 'firstBelow';
validCriteria = {'firstBelow','firstDrop'};
checkCriterion = @(x) any(validatestring(x, validCriteria));

% Optional parameter: threshold
defaultThreshold = exp(-1);
checkThreshold = @(x) validateattributes(x, {'numeric'}, {'positive'});

addRequired(parser, 'data', @checkdata);
addOptional(parser, 'plottype', defaultPlotType, checkPlotType);
addOptional(parser, 'numBins', defaultNumBins, checkNumBins);
addOptional(parser, 'maxLag', defaultMaxLag, checkMaxLag);
addOptional(parser, 'criterion', defaultCriterion, checkCriterion);
addOptional(parser, 'threshold', defaultThreshold, checkThreshold);
parse(parser, data, varargin{:});

% Get the optional arguments if provided. Otherwise the specified defaults
% are used.
numBins = parser.Results.numBins;
maxLag = parser.Results.maxLag;
criterion = char(parser.Results.criterion);
threshold = parser.Results.threshold;
plotType = char(parser.Results.plottype);

[~, ncol] = size(data);
if ncol ~= 1
    %
    % Calculation of the mutual information as a function of time lag
    %

    % Allocate a matrix, where each column will be the auto mutual information
    % as a function of time lag [0; maxlag] for a variable in the input data.
    auto_mi = zeros(maxLag + 1, ncol);

    % Allocate a vector to hold the estimated optimal time lag for each
    % dimension.
    lags = zeros(1, ncol);

    for c=1:ncol
        auto_mi(:,c) = autoMI(data(:, c), numBins, maxLag);
        if strcmp(criterion, 'firstBelow')
            lags(c) = findFirstBelowThreshold(auto_mi(:, c), threshold);
        elseif strcmp(criterion, 'firstDrop')
            lags(c) = findFirstDrop_(auto_mi(:, c));        
        end
    end
else
    % Allocate a vector to hold the estimated optimal time lag for each
    % dimension.
    lags = zeros(1, 1);
    auto_mi = autoMI(data, numBins, maxLag);
        if strcmp(criterion, 'firstBelow')
            lags = findFirstBelowThreshold(auto_mi, threshold);
        elseif strcmp(criterion, 'firstDrop')
            lags = findFirstDrop_(auto_mi);        
        end
end
    
    
    

%
% Call the relevant plotting function
%
switch plotType
    case 'mean'
        plotMeanMI(auto_mi, threshold);
        hold on
        plotdiffMI(auto_mi)
    case 'all'
        plotAllMI(auto_mi, threshold);
        hold on
        plotdiffMI(auto_mi)
    case 'both'
        plotMeanMI(auto_mi, threshold);
        plotAllMI(auto_mi, threshold);
        hold on
        plotdiffMI(auto_mi)
    case 'none'
end
%
% Return the estimated optimal time lag
%
delay = mean(lags);
end
%%
function check = checkdata(x)
   check = false;
   if (~isnumeric(x))
       error('Input is not numeric');
   elseif (numel(x) <= 1) 
       error('Input must be a vector or matrix');
   else
       check = true;
   end
end

function lag = findFirstBelowThreshold(ami, threshold)
    % First find the first element below the threshold. Then test whether
    % an element below the threshold was found, and recover if this is not
    % the case.
    idx = find(ami < threshold, 1, 'first');
    lag_ = idx;
    ami_2d = diff(ami(1:lag_),2);
    idx_row=find(abs(ami_2d)<max(abs(ami_2d))*0.1,1);
    if isempty(idx)
        disp('No value below threshold found. Will use first local minimum instead');
        % If there is more than one elemtent that has the minimum value
        % the min() function returns the first one.
        lag = findFirstDrop_(ami);
    else
        % A value of the index idx = 1 corresponds to lag = 0, so 1 is
        % subtracted from the index to get the lag.
        lag = idx_row;  
    end
    
end

%% %%
% % Yong's code
% function lag = findFirstDrop(ami, maxLag)
%     % This function finds the position at which the mean of ami changes most significantly    
%     maxNumPts = 1;
%     idx = findchangepts(ami);  %变点检测默认找一个变化最大的点
%     delta0 = ami(1) - ami(idx(1));
%     
%     delta = ami(1) - ami(idx(end));
%     threshold = delta0 * 0.1;
%     runLen = 1;
%     lag = idx(end) - 1;
%     while delta > threshold        
%         deltaPrev = delta;
%         maxNumPts = maxNumPts+1;
%         idx = findchangepts(ami, 'MaxNumChanges', maxNumPts);
%         if length(idx)>=2 && runLen<maxLag 
%             delta = ami(idx(end-1)) - ami(idx(end));
%         else            
%             break;
%         end
%         % if new delta <= previous delta
%         if abs(delta-deltaPrev)<= 0.001
%             % update runLen
%             runLen = runLen+1; 
%         else
%             % reset runLen to 1
%             runLen = 1;
%             % reset lag = idx(end) -1
%             lag = idx(end) - 1;
%         end
%         if runLen>=10
%             disp(idx')
%             disp(['runLen = ', num2str(runLen), ' maxNumPts = ', ...
%                   num2str(maxNumPts), ' lag = ', num2str(lag)]);  
%             pause
%         end
%     end
%     
%     
%     % A value of the index idx = 1 corresponds to lag = 0, so 1 is
%     % subtracted from the index to get the lag.
%     lag = idx(end) - 1;     
%     %disp([' numPoints =', num2str(length(idx)), ' lag =', num2str(lag) ]);
% end

% function lag = findFirstLocalMinimum(ami)
%     % Find all local minima
%     idx = find(diff(ami) > 0);
%     if ~isempty(idx)
%         % Select the first local minimum
%         idx = idx(1);
%     else
%         disp('No local minimium found. Will use global minimum instead');
%         disp('Consider increasing maxLag');
%         % If there is more than one elemtent that has the minimum value
%         % the min() function returns the first one.
%         [~, idx] = min(ami);
%     end
%     % A value of the index idx = 1 corresponds to lag = 0, so 1 is ...
%     % subtracted from the index to get the lag.
%     lag = idx - 1;
% end
%% %%

function lag = findFirstDrop_(ami)
    % Find all local minima
    idx = find(diff(ami) > 0);
    if ~isempty(idx)
        % Select the first local minimum
        idx = idx(1);
    else
        disp('No local minimium found. Will use global minimum instead');
        disp('Consider increasing maxLag');
        % If there is more than one elemtent that has the minimum value
        % the min() function returns the first one.
        [~, idx] = min(ami);
    end
    % A value of the index idx = 1 corresponds to lag = 0, so 1 is ...
    % subtracted from the index to get the lag.
    lag_ = idx - 1;
    ami_2d = diff(ami(1:lag_),2);
    idx_row=find(abs(ami_2d)<max(abs(ami_2d))*0.1, 1,'first');
    lag = idx_row;
end


%% The Plots
function plotMeanMI(ami, threshold)
    [nlag, ~] = size(ami);
    maxlag = nlag - 1;
    % Compute a vector with the mean of each row.
    y = mean(ami, 2);  
    % Vector with standard deviation of each row.
    stddev = std(ami, 0, 2);  
    % Construct a vector with lags for x-axis.
    x = (0:maxlag)';
    figure();
    hold off
    % Plot shaded area indicating standard deviation if it is non-zero.
    if ~max(stddev) == 0
        yu = y + stddev;
        yl = y - stddev;
        % To make this work the vectors need to be transposed to
        % become row vectors.
        fill([x' fliplr(x')], [yu' fliplr(yl')], [.9 .9 .9], 'linestyle', 'none')
        hold on
    end
    plot(x, y, 'b','linewidth',2);
    refline(0, threshold)
    limits = ylim;
    ylim([0, limits(2)]);
    xlabel('Time lag');
    ylabel('Mutual Information');
    %fplot(@humps,[min(x), max(x)]);
end

function plotAllMI(ami, threshold)
    [nlag, ncol] = size(ami);
    maxlag = nlag - 1;
    figure();
    hold off
    for c = 1:ncol
        plot(0:maxlag, ami(:, c), 'b','linewidth',2);
        hold on
    end
    refline(0, threshold)
    limits = ylim;
    ylim([0, limits(2)]);
    xlabel('Time lag')
    ylabel('Mutual Information')
    %fplot(@humps,[0,maxlag]);
end

function plotdiffMI(ami)
   [nlag, ncol] = size(ami);
   maxlag = nlag-2;
   %ami_d = zeros(maxlag, ncol);
   figure();
   hold off
   for i = 1:ncol
        ami_d = diff(ami(:,i))./diff(0:maxlag);
        plot(0:maxlag, abs(ami_d(:,i)), 'r', 'linewidth',2);
        hold on
   end
   hline = refline([0,0]);
   hline.Color = 'r';
   xlabel('Time lag')
   ylabel('\fontname{Times new roman}differential Mutual information')
end