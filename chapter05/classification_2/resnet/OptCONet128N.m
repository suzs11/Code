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
input1 =[imageInputLayer([224 224 3],'Name','input'),
        convolution2dLayer(3,16,'Padding','same','Name','conv'),
        batchNormalizationLayer('Name','BN')];
%%
%Resnet18: 4 main(1to4) blocks with 2 sub blocks(A&B) in each block as defined below. 
%Each Sub block have 2 set of a coinvolution, batch
%normalization and a relu activation layer. So in 4 block there will be
%16 convolution layer in total and the input layer and output layer addes up to 18 layers. 

%Block 1
%Sub block 1A and 1B. 
block_1A = [
    convolution2dLayer(3,16,'Padding','same','Name','conv_1')
    batchNormalizationLayer('Name','BN_1')
    reluLayer('Name','relu_1')
    
    convolution2dLayer(3,16,'Padding','same','Name','conv_2')
    batchNormalizationLayer('Name','BN_2')
    reluLayer('Name','relu_2')];

block_1B = [
    convolution2dLayer(3,16,'Padding','same','Name','conv_3')
    batchNormalizationLayer('Name','BN_3')
    reluLayer('Name','relu_3')
    
    convolution2dLayer(3,16,'Padding','same','Name','conv_4')
    batchNormalizationLayer('Name','BN_4')
    reluLayer('Name','relu_4')];

%Block 2
%Sub block 2A and 2B
%Block 2A act as a maxpooling layer ie 3X3 convolution with stride of 2
block_2A = [
    convolution2dLayer(3,32,'Padding','same','Stride',2, 'Name','conv_5')
    batchNormalizationLayer('Name','BN_5')
    reluLayer('Name','relu_5')
    
    convolution2dLayer(3,32,'Padding','same','Name','conv_6')
    batchNormalizationLayer('Name','BN_6')
    reluLayer('Name','relu_6')];

block_2B = [
    convolution2dLayer(3,32,'Padding','same', 'Name','conv_7')
    batchNormalizationLayer('Name','BN_7')
    reluLayer('Name','relu_7')
    
    convolution2dLayer(3,32,'Padding','same','Name','conv_8')
    batchNormalizationLayer('Name','BN_8')
    reluLayer('Name','relu_8')];

%Block 3
%Sub block 3A and 3B
%Block 3A act as a maxpooling layer ie 3X3 convolution with stride of 2
block_3A = [
    convolution2dLayer(3,64,'Padding','same','Stride',2, 'Name','conv_9')
    batchNormalizationLayer('Name','BN_9')
    reluLayer('Name','relu_9')
    
    convolution2dLayer(3,64,'Padding','same','Name','conv_10')
    batchNormalizationLayer('Name','BN_10')
    reluLayer('Name','relu_10')];

block_3B = [
    convolution2dLayer(3,64,'Padding','same', 'Name','conv_11')
    batchNormalizationLayer('Name','BN_11')
    reluLayer('Name','relu_11')
    
    convolution2dLayer(3,64,'Padding','same','Name','conv_12')
    batchNormalizationLayer('Name','BN_12')
    reluLayer('Name','relu_12')];

%Block 4
%Sub block 4A and 4B
%Block 4A act as a maxpooling layer ie 3X3 convolution with stride of 2
block_4A = [
    convolution2dLayer(3,128,'Padding','same','Stride',2, 'Name','conv_13')
    batchNormalizationLayer('Name','BN_13')
    reluLayer('Name','relu_13')
    
    convolution2dLayer(3,128,'Padding','same','Name','conv_14')
    batchNormalizationLayer('Name','BN_14')
    reluLayer('Name','relu_14')];

block_4B = [
    convolution2dLayer(3,128,'Padding','same', 'Name','conv_15')
    batchNormalizationLayer('Name','BN_15')
    reluLayer('Name','relu_15')
    
    convolution2dLayer(3,128,'Padding','same','Name','conv_16')
    batchNormalizationLayer('Name','BN_16')
    reluLayer('Name','relu_16')];

%%

%1X1 Convolution with stride of 2 for Skip connection layer
connect1 = convolution2dLayer(1,32,'Padding','same','Stride',2, 'Name','skipconv_1');

connect2 = convolution2dLayer(1,64,'Padding','same','Stride',2, 'Name','skipconv_2');

connect3 = convolution2dLayer(1,128,'Padding','same','Stride',2, 'Name','skipconv_3');

%%
%output layer definition
outlayer = [    
    convolution2dLayer(1,25,'Padding','same', 'Name','conv_1x1')

    fullyConnectedLayer(2,'Name','fc1');

    softmaxLayer('Name','sm1');

    classificationLayer('Name','output')];
%%
%Definition of addition layer to combine two connection
add1 = additionLayer(2,'Name','add_1');
add2 = additionLayer(2,'Name','add_2');
add3 = additionLayer(2,'Name','add_3');
add4 = additionLayer(2,'Name','add_4');
add5 = additionLayer(2,'Name','add_5');
add6 = additionLayer(2,'Name','add_6');
add7 = additionLayer(2,'Name','add_7');
add8 = additionLayer(2,'Name','add_8');
%%
%Layer definition for Resnet 18
%{
layerGraph:A layer graph specifies the architecture of a deep learning 
network with a more complex graph structure in which layers can have 
inputs from multiple layers and outputs to multiple layers 
%}
%addLayers: add layer to the network
%connectLayers: connects the source layer to the destination layer.
lgraph = layerGraph;

lgraph = addLayers(lgraph,input1);
lgraph = addLayers(lgraph,block_1A);
lgraph = addLayers(lgraph,add1);
lgraph = connectLayers(lgraph,'BN','conv_1');
lgraph = connectLayers(lgraph,'BN','add_1/in1');
lgraph = connectLayers(lgraph,'relu_2','add_1/in2');

lgraph = addLayers(lgraph,block_1B);
lgraph = addLayers(lgraph,add2);
lgraph = connectLayers(lgraph,'add_1','conv_3');
lgraph = connectLayers(lgraph,'relu_4','add_2/in1');
lgraph = connectLayers(lgraph,'add_1','add_2/in2');

lgraph = addLayers(lgraph,block_2A);
lgraph = addLayers(lgraph,add3);
lgraph = addLayers(lgraph,connect1);
lgraph = connectLayers(lgraph,'add_2','conv_5');
lgraph = connectLayers(lgraph,'add_2','skipconv_1');
lgraph = connectLayers(lgraph,'relu_6','add_3/in1');
lgraph = connectLayers(lgraph,'skipconv_1','add_3/in2');

lgraph = addLayers(lgraph,block_2B);
lgraph = addLayers(lgraph,add4);
lgraph = connectLayers(lgraph,'add_3','conv_7');
lgraph = connectLayers(lgraph,'relu_8','add_4/in1');
lgraph = connectLayers(lgraph,'add_3','add_4/in2');
% 
lgraph = addLayers(lgraph,block_3A);
lgraph = addLayers(lgraph,add5);
lgraph = addLayers(lgraph,connect2);
lgraph = connectLayers(lgraph,'add_4','conv_9');
lgraph = connectLayers(lgraph,'add_4','skipconv_2');
lgraph = connectLayers(lgraph,'relu_10','add_5/in1');
lgraph = connectLayers(lgraph,'skipconv_2','add_5/in2');
% % 
lgraph = addLayers(lgraph,block_3B);
lgraph = addLayers(lgraph,add6);
lgraph = connectLayers(lgraph,'add_5','conv_11');
lgraph = connectLayers(lgraph,'relu_12','add_6/in1');
lgraph = connectLayers(lgraph,'add_5','add_6/in2');
% 
lgraph = addLayers(lgraph,block_4A);
lgraph = addLayers(lgraph,add7);
lgraph = addLayers(lgraph,connect3);
lgraph = connectLayers(lgraph,'add_6','conv_13');
lgraph = connectLayers(lgraph,'add_6','skipconv_3');
lgraph = connectLayers(lgraph,'relu_14','add_7/in1');
lgraph = connectLayers(lgraph,'skipconv_3','add_7/in2');
% 
lgraph = addLayers(lgraph,block_4B);
lgraph = addLayers(lgraph,add8);
lgraph = connectLayers(lgraph,'add_7','conv_15');
lgraph = connectLayers(lgraph,'relu_16','add_8/in1');
lgraph = connectLayers(lgraph,'add_7','add_8/in2');
% 
lgraph = addLayers(lgraph,outlayer);
lgraph = connectLayers(lgraph,'add_8','conv_1x1');

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
net = trainNetwork(augmentedTrainingSet56,lgraph,options);
[YPred, Scores] = classify(net,augmentedTestSet56);

display('The Best Momentum is: '+string(K1));
display('The Best InitialLeranRate is:'+string(K2));
display('The Best L2Regularizatio is:'+string(K4));
display('The Best MaxEpochs is'+string(K3));

accuracy = sum(YPred == YValidation56)/numel(YValidation56);
TestError = 1-mean(YPred==YValidation56);
formatSpace = 'The best accuracy of test set classification is %f7\n';
fprintf(formatSpace,accuracy)

