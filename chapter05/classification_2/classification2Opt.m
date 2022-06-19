clear all

outputFolder = fullfile('recurrence02');
rootFolder = fullfile(outputFolder, '2_Categories');

categories = {'logistic','randoms'};

imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource','foldernames');

tb1 = countEachLabel(imds);
minSetCount = min(tb1{:,2});

imds = splitEachLabel(imds, minSetCount,'randomize');
countEachLabel(imds);


logistic = find(imds.Labels=='logistic',1);
randoms = find(imds.Labels=='randoms',1);

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

%% The networks architecture
layers = [ ...
    imageInputLayer([224 224 3])
    convolution2dLayer(5,20)
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(5,16)
    reluLayer
    maxPooling2dLayer(2,'stride',2)
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

%% Learning Hyperparameters optimization
[trainingSet, testSet] = splitEachLabel(imds, 0.7, 'randomize');
%Momentum Values 
momentum = [0.9 0.7 0.5 0.3 0.1];
momentum_length = length(momentum); %length of Momentum vector for later use

%Learning Rate Values
learning_rate = [0.09 0.07 0.05 0.03 0.01]; %length of Learning Rate vector for later use
lr_length = length(learning_rate);

%Implement GridSearch based on the Optimal architecture found from the experiments previously
optimal_accuracy_cnn = -1; %Declare Accuracy
min_accuracy = 101; % Declare minimum accuracy
sum_accuracy = 0; % Summary of accuracy for the average accuracy
num_loops = 0; %Number of loops for the average accuracy
for i=1:lr_length
    for j=1:momentum_length
options = trainingOptions('sgdm', ... %优化器                        
                          'ExecutionEnvironment','cpu', ...
                          'LearnRateSchedule','piecewise', ... %学习率
                          'LearnRateDropFactor',0.2, ...                        
                          'InitialLearnRate',learning_rate(i), ...
                          'Momentum', momentum(j), ... % changing momentum
                          'GradientThreshold',1, ...
                          'shuffle','every-epoch', ...
                          'Verbose',false, ...
                          'LearnRateDropPeriod',5, ...
                          'MaxEpochs',60, ... %最大学习整个数据集的次数
                          'MiniBatchSize',256, ... %每次学习样本数
                          'ValidationData',{testSet,testSet.Labels}, ...
                          'Plots','training-progress'); %画出整个训练过程

        doTraining = 1; %是否训练
        if doTraining==1
            [trainNet,traininfo ]= trainNetwork(trainingSet,layers,options);  
            save result/cnn_net trainNet traininfo
            % 训练网络，XTrain训练的图片，YTrain训练的标签，layers要训练的网
            % 络，options训练时的参数
        else
            load result/cnn_net
        end
        save Minist_LeNet5 trainNet %训练完后保存模型
        Y_predicted_val = classify(trainNet,testSet); %Calculate predictions of this net
        Y_val = testSet.Labels; %Keep the labels of the validation images
    
        accuracy_validation_set = sum(Y_predicted_val == Y_val)/numel(Y_val); % Calculate the accuracy
        sum_accuracy = sum_accuracy + accuracy_validation_set; % add accuracy value to the sum
        num_loops = num_loops +1; % add 1 loop to the number of loops
        
        if(accuracy_validation_set > optimal_accuracy_cnn) %Calculate the best performing network based on the accuracy
            optimal_accuracy_cnn = accuracy_validation_set; % save the maximum accuracy if the condition is being satisfied
            optimal_net_cnn = trainNet; % save the optimal net if the condition is being satisfied
            optimal_options_cnn = options; % save the optimal options if the condition is being satisfied
            optimal_lr_cnn = learning_rate(i); %save the optimal learning rate if the condition is being satisfied
            optimal_momentum_cnn = momentum(j); %save the optimal momentum if the condition is being satisfied
        end
        if(accuracy_validation_set< min_accuracy) %Find the minimum accuracy
            min_accuracy = accuracy_validation_set; % save the minimum accuracy if the condition is satisfied
        end    
        disp('Accuracy validation: ' + string(accuracy_validation_set)) %Print the accuracy for each loop for testing purposes
        disp('Learning Rate: ' + string(learning_rate(i))) %Print the learning rate for each loop for testing purposes
        disp('Momentum: ' + string(momentum(j))) %Print the momentum for each loop for testing purposes
    end
end

avg_accuracy = (sum_accuracy*100)/num_loops; %Calculate the average accuracy of the Grid Search loops
%%
disp('Optimal Accuracy CNN Grid Search: ' + string(optimal_accuracy_cnn*100) + '%') %Print the Optimal Accuracy of the Grid Search
disp('Optimal Learning Rate CNN Grid Search: ' + string(optimal_lr_cnn)) %Print the Optimal Learning Rate of the Grid Search
disp('Optimal Momentum CNN Grid Search: ' + string(optimal_momentum_cnn)) %Print the Optimal Momentum of the Grid Search
disp('Average accuracy CNN Grid Search: ' + string(avg_accuracy) +'%') %Print the Average Accuracy of the Grid Search
disp('Minimum accuracy CNN Grid Search: ' + string(min_accuracy*100) +'%') %Print the Minimum Accuracy of the Grid Search


%% The Data Set and training 
%[trainingSet, testSet] = splitEachLabel(imds, 0.3, 'randomize');

%[net,traininfo] = trainNetwork(trainingSet,layers,options);

% YPred = classify(net,testSet);
% YTest = testSet.Labels;
% accuracy = sum(YPred == YTest)/numel(YTest);
% formatSpace = 'The accuracy of test set classification is %7.5\n';
% fprintf(formatSpace,accuracy)

figure;
plot(traininfo.TrainingLoss,'s','MarkerFaceColor','r')
figure;
plot(traininfo.TrainingAccuracy,'^','MarkerFaceColor','b')

figure
plot(trainNet)
title('Architecture of Networks')
set(gca, 'YLim', [150,170]);


%% Test
% testLabels = testSet.Labels;
% confMat = confusionmat(testLabels, predictLabels);
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
