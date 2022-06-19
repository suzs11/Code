clear;clc;
rootFolder = fullfile('4_Categories');
categories = {'lorenz','rossler','logistic','random'};
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource','foldernames');

tb1 = countEachLabel(imds);
minSetCount = min(tb1{:,2});
imds = splitEachLabel(imds, minSetCount,'randomize');
countEachLabel(imds);

lorenz   = find(imds.Labels=='lorenz',1);
rossler  = find(imds.Labels=='rossler',1);
logistic = find(imds.Labels=='logistic',1);
randoms  = find(imds.Labels=='random',1);

figure;
subplot(2,2,1);
imshow(readimage(imds, lorenz));
xlabel('lorenz')
subplot(2,2,2)
imshow(readimage(imds, rossler));
xlabel('rossler')
subplot(2,2,3)
imshow(readimage(imds, logistic));
xlabel('logistic')
subplot(2,2,4)
imshow(readimage(imds, randoms));
xlabel('randoms')

fig4 = figure;
numImages = 800;
perm = randperm(numImages,20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
    drawnow;
end
%saveas(fig4,'images/4cnnSample.eps','epsc')

%% The networks architecture
[trainingSet, testSet] = splitEachLabel(imds, 0.7, 'randomize');
layers = [ ...
    imageInputLayer([28 28 3])
    convolution2dLayer(5,20)
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(5,16)
    reluLayer
    maxPooling2dLayer(2,'stride',2)
    
    fullyConnectedLayer(4)
    softmaxLayer
    classificationLayer];

analyzeNetwork(layers)
options = trainingOptions('sgdm', ... %优化器                        
                          'ExecutionEnvironment','cpu', ...
                          'LearnRateSchedule','piecewise', ... %学习率
                          'LearnRateDropFactor',0.2, ...                        
                          'InitialLearnRate',0.07, ...
                          'Momentum', 0.3, ... % changing momentum
                          'GradientThreshold',1, ...
                          'shuffle','every-epoch', ...
                          'Verbose',false, ...
                          'LearnRateDropPeriod',5, ...
                          'MaxEpochs',20, ... %最大学习整个数据集的次数
                          'MiniBatchSize',35, ... %每次学习样本数
                          'ValidationData',{testSet,testSet.Labels}, ...
                          'Plots','training-progress'); %画出整个训练过程

%% The Data Set

[net,traininfo] = trainNetwork(trainingSet,layers,options);
%save 'CSNet4.mat' net
YPred = classify(net,testSet);
YTest = testSet.Labels;
accuracy = sum(YPred == YTest)/numel(YTest);
figl4=figure;
plot(traininfo.TrainingLoss,'MarkerFaceColor','r')
xlabel("Iteration")
ylabel("Loss")
%saveas(figl4,'images/4cnnLoss.eps','epsc')
figa4 = figure;
plot(traininfo.TrainingAccuracy,'MarkerFaceColor','b')
xlabel("Iteration")
ylabel("Accuracy(%)")
%saveas(figa4,'images/4cnnAccuracy.eps','epsc')

imageSize = net.Layers(1).InputSize;

w1 = net.Layers(2).Weights;
w1 = mat2gray(w1);

figure %the plots of the weights
montage(w1)
title('First Convolutional Layer Weight')

% figure
% plot(net)
% title('Architecture of ResNet-50')
% set(gca, 'YLim', [150,170]);

figc4 = figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(YTest,YPred);
cm.Title = 'A';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';
%saveas(figc4,'images/4cnnConfusion.eps','epsc')


%% Test
% testLabels = testSet.Labels;
% confMat = confusionmat(testLabels, YPred);
% confMat = bsxfun(@rdivide, confMat, sum(confMat,2));
% %sum(confMat)
% mean(diag(confMat));
% 
% newImage = imread(fullfile('test103.jpeg'));
% 
% ds = augmentedImageDatastore(imageSize, ...
%     newImage, 'ColorPreprocessing','gray2rgb');
% 
% imageFeatures = activations(net,...
%    ds, featureLayer, 'MiniBatchSize',32, 'OutputAs','columns');
% 
% label = predict(classifier, imageFeatures,'ObservationsIn','columns');
% sprintf('The loaded image belogs to %s class', label)
