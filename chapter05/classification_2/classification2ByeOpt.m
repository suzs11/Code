clear; clc;
outputFolder = fullfile('recurrence02');
rootFolder = fullfile(outputFolder, '2_Categories');

categories = {'logistic','randoms'};

imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource','foldernames');

tb1 = countEachLabel(imds);
minSetCount = min(tb1{:,2});

%splitting of Database into Training and Test Sets
imds = splitEachLabel(imds, minSetCount,'randomize');


logistic = find(imds.Labels=='logistic',1);
randoms = find(imds.Labels=='randoms',1);
[TrainSet,ValidSet] = splitEachLabel(imds, 0.7,'randomize');



%%
figure;
subplot(1,2,1)
imshow(readimage(imds, logistic));
subplot(1,2,2)
imshow(readimage(imds, randoms));

figure
numImages = 2916;
perm = randperm(numImages,20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
    drawnow;
end


%% Train Network with Augmented Images And  Bayesian Optimization
optimVars = [
    optimizableVariable('SectionDepth',[1 3],'Type','integer')
    optimizableVariable('InitialLearnRate',[1e-2 1],'Transform','log')
    optimizableVariable('Momentum',[0.8 0.98])
    optimizableVariable('L2Regularization',[1e-10 1e-2],'Transform','log')];

ObjFcn = makeObjFcn(TrainSet,ValidSet);
BayesObject = bayesopt(ObjFcn,optimVars, ...
                       'MaxTime',14*60*60, ...
                       'IsObjectiveDeterministic',false, ...
                       'UseParallel',false);

bestIdx = BayesObject.IndexOfMinimumTrace(end);
fileName = BayesObject.UserDataTrace{bestIdx};
savedStruct = load(fileName);
valError = savedStruct.valError;
disp('valError ='+valError)

[YPredicted,probs] = classify(savedStruct.trainedNet,ValidSet);
testError = 1 - mean(YPredicted == ValidSet.Labels);
disp('testError = '+testError)
NTest = numel(ValidSet.Labels);
testErrorSE = sqrt(testError*(1-testError)/NTest);
testError95CI = [testError - 1.96*testErrorSE, testError + 1.96*testErrorSE];
disp('testError95CI = '+testError95CI)

figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(ValidSet.Labels,YPredicted);
cm.Title = 'Confusion Matrix for Test Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';
figure
idx = randperm(numel(ValidSet.Labels),9);
for i = 1:numel(idx)
    subplot(3,3,i)
    imshow(ValidSet(:,:,:,idx(i)));
    prob = num2str(100*max(probs(idx(i),:)),3);
    predClass = char(YPredicted(idx(i)));
    label = [predClass,', ',prob,'%'];
    title(label)
end


%% test
% test_image = imread('5.jpg');
% shape = size(test_image);
% dimension=numel(shape);
% if dimension > 2
%     test_image = rgb2gray(test_image); %?????????
% end
% test_image = imresize(test_image, [28,28]); %???????????????28*28
% test_iamge = imbinarize(test_image,0.5); %?????????
% test_image = imcomplement(test_image); %???????????????????????????????????????????????????
% % ???????????????????????????????????????
% imshow(test_image);
% 
% load('Minist_LeNet5');
% % test_result = Recognition(trainNet, test_image);
% result = classify(trainNet, test_image);
% disp(test_result);

%% the Helper Functions
function ObjFcn = makeObjFcn(TrainSet,ValidSet)

ObjFcn = @valErrorFun;
    function [valError,cons,fileName] = valErrorFun(optVars)
        imageSize = [224 224 3];
        YTrain = TrainSet.Labels;
        numClasses = numel(unique(YTrain));
        numF = round(16/sqrt(optVars.SectionDepth));
        layers = [
            imageInputLayer(imageSize)
            
            % The spatial input and output sizes of these convolutional
            % layers are 32-by-32, and the following max pooling layer
            % reduces this to 16-by-16.
            convBlock(3,numF,optVars.SectionDepth)
            maxPooling2dLayer(3,'Stride',2,'Padding','same')
            
            % The spatial input and output sizes of these convolutional
            % layers are 16-by-16, and the following max pooling layer
            % reduces this to 8-by-8.
            convBlock(3,2*numF,optVars.SectionDepth)
            maxPooling2dLayer(3,'Stride',2,'Padding','same')
            
            % The spatial input and output sizes of these convolutional
            % layers are 8-by-8. The global average pooling layer averages
            % over the 8-by-8 inputs, giving an output of size
            % 1-by-1-by-4*initialNumFilters. With a global average
            % pooling layer, the final classification output is only
            % sensitive to the total amount of each feature present in the
            % input image, but insensitive to the spatial positions of the
            % features.
            convBlock(3,4*numF,optVars.SectionDepth)
            averagePooling2dLayer(8)
            
            % Add the fully connected layer and the final softmax and
            % classification layers.
            fullyConnectedLayer(numClasses)
            softmaxLayer
            classificationLayer];
        miniBatchSize = 256;
        validationFrequency = floor(numel(YTrain)/miniBatchSize);
        options = trainingOptions('sgdm', ...
            'InitialLearnRate',optVars.InitialLearnRate, ...
            'Momentum',optVars.Momentum, ...
            'MaxEpochs',60, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropPeriod',40, ...
            'LearnRateDropFactor',0.1, ...
            'MiniBatchSize',miniBatchSize, ...
            'L2Regularization',optVars.L2Regularization, ...
            'Shuffle','every-epoch', ...
            'Verbose',false, ...
            'Plots','training-progress', ...
            'ValidationData',{ValidSet,ValidSet.Labels}, ...
            'ValidationFrequency',validationFrequency);
        pixelRange = [-16 16];
        imageAugmenter = imageDataAugmenter( ...
                                            'RandXReflection',true, ...
                                            'RandXTranslation',pixelRange, ...
                                            'RandYTranslation',pixelRange);
        datasource = augmentedImageDatastore(imageSize,TrainSet,'DataAugmentation',imageAugmenter);
        validsource = augmentedImageDatastore(imageSize,ValidSet,'DataAugmentation',imageAugmenter);
        
        trainedNet = trainNetwork(datasource,layers,options);
        close(findall(groot,'Tag','NNET_CNN_TRAININGPLOT_UIFIGURE'));
        YPredicted = classify(trainedNet,validsource);
        valError = 1 - mean(YPredicted == ValieSet.Labels);
        fileName = num2str(valError) + ".mat";
        save(fileName,'trainedNet','valError','options')
        cons = [];      
    end
end

function layers = convBlock(filterSize,numFilters,numConvLayers)
layers = [
    convolution2dLayer(filterSize,numFilters,'Padding','same')
    batchNormalizationLayer
    reluLayer];
layers = repmat(layers,numConvLayers,1);
end