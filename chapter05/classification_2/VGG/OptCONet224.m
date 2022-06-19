digitDatasetPath = fullfile('../2_Categories224');
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
    
imageSize = [224 224 3];
augmentedTrainingSet56 = augmentedImageDatastore(imageSize, trainingSet, 'ColorPreprocessing', 'gray2rgb');
augmentedTestSet56 = augmentedImageDatastore(imageSize, testSet, 'ColorPreprocessing', 'gray2rgb');
% Design CNN Network
net=vgg16();
layersTransfer=net.Layers(1:end-3)
layers = [
    layersTransfer
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];
YValidation56 = testSet.Labels;
save augmentedTrainingSet56 augmentedTrainingSet56;
save  augmentedTestSet56  augmentedTestSet56;
save YValidation56 YValidation56
% Initialize the parameters for WOA Search
SearchAgents_no=30;   Max_iteration=5; dim = 4;
lb =  [0.5, 0.01, 5, 1.0000e-04];
ub = [0.9, 0.1, 10, 5.0000e-04]; 
% WOA Search Optimization
[Best_score,Best_pos,GWO_cg_curve] = GWO(SearchAgents_no,Max_iteration,lb,ub,dim,@error_rate);
K1 = Best_pos(1,1);
K2 = Best_pos(1,2);
K3 = Best_pos(1,3);
K4 = Best_pos(1,4);
options = trainingOptions('sgdm', ...
                                'ExecutionEnvironment','auto', ...
                                'LearnRateSchedule','piecewise', ... %学习率
                                'LearnRateDropFactor',0.5, ...  
                                'LearnRateDropPeriod',5, ...
                                'GradientThreshold',1, ...
                                'Momentum', K1,...
                                'InitialLearnRate',K2, ...
                                'MaxEpochs',ceil(K3), ...
                                'L2Regularization', K4,...    
                                'Shuffle','every-epoch', ...
                                'ValidationData',augmentedTestSet56, ...
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

