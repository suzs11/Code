cd /public/home/qushixian_st3/Main/CNN9_56;
digitDatasetPath = fullfile('Data_9_rc_optDimTau_56_56');
imds = imageDatastore(digitDatasetPath, ...
        'IncludeSubfolders',true,'LabelSource','foldernames');
%tbl = countEachLabel(imds);
%minSetCount = min(tbl{:,2});
start_time_train=cputime;
% net = resnet50();
no_person = 3;
%splitting of Database into Training and Test Sets
[trainingSet, testSet] = splitEachLabel(imds, 0.8, 'randomize');
% Data Augmentation
    
imageSize = [56 56 3];
augmentedTrainingSet25 = augmentedImageDatastore(imageSize, trainingSet, 'ColorPreprocessing', 'gray2rgb');
augmentedTestSet25 = augmentedImageDatastore(imageSize, testSet, 'ColorPreprocessing', 'gray2rgb');
% Design CNN Network
layers = [
    imageInputLayer([56 56 3])
    
    convolution2dLayer(5,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(5,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(25)
    softmaxLayer
    classificationLayer];
YValidation25 = testSet.Labels;
save augmentedTrainingSet25 augmentedTrainingSet25;
save  augmentedTestSet25  augmentedTestSet25;
save YValidation25 YValidation25
% Initialize the parameters for WOA Search
SearchAgents_no=30;   Max_iteration=5; dim = 4;
lb =  [0.5, 0.01, 5, 1.0000e-04];
ub = [0.9, 0.1, 10, 5.0000e-04]; 
% WOA Search Optimization
%[Best_score,Best_pos,GWO_cg_curve] = GWO56(SearchAgents_no,Max_iteration,lb,ub,dim,@error_rate56);
%K1 = Best_pos(1,1);
K1 = 0.5;
%K2 = Best_pos(1,2);
K2 = 0.07301;
%K3 = Best_pos(1,3);
K3 = 6;
%K4 = Best_pos(1,4);
K4 = 0.0001;
analyzeNetwork(layers)
options = trainingOptions('sgdm', ...
                                'ExecutionEnvironment','auto', ...
                                'LearnRateSchedule','piecewise', ... %学习率
                                'LearnRateDropFactor',0.2, ...  
                                'LearnRateDropPeriod',5, ...
                                'GradientThreshold',1, ...
                                'Momentum', K1,...
                                'InitialLearnRate',K2, ...
                                'MaxEpochs',ceil(K3), ...
                                'L2Regularization', K4,...   
                                'MiniBatchSize', 32,...
                                'Shuffle','every-epoch', ...
                                'ValidationData',augmentedTestSet56, ...
                                'ValidationFrequency',30, ...
                                'Verbose',false, ...
                                'Plots','training-progress');
% Train the CNN network, Parameters optimized using WOA 
net = trainNetwork(augmentedTrainingSet56,layers,options);
[YPred, Scores] = classify(net,augmentedTestSet56);

display('The Best Momentum is: '+string(K1));
display('The Best InitialLeranRate is:'+string(K2));
display('The Best L2Regularizatio is:'+string(K4));
display('The Best MaxEpochs is'+string(K3));

accuracy = sum(YPred == YValidation56)/numel(YValidation56);
TestError = 1-mean(YPred==YValidation56);
formatSpace = 'The best accuracy of test set classification is %f7\n';
fprintf(formatSpace,accuracy)

figc = figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(YValidation56,YPred);
cm.Title = 'Confusion Matrix for Test Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';
%saveas(figc,'images/cnnConfusion.eps','epsc')
