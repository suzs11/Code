clear; clc;
rootFolder = fullfile('2_Categories64');
categories = {'logistic','randoms'};
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource','foldernames');
tb1 = countEachLabel(imds);
minSetCount = min(tb1{:,2});
imds = splitEachLabel(imds, minSetCount,'randomize');
countEachLabel(imds);

% logistic = find(imds.Labels=='logistic',1);
% randoms = find(imds.Labels=='randoms',1);
% figure;
% subplot(1,2,1)
% imshow(readimage(imds, logistic));
% subplot(1,2,2)
% imshow(readimage(imds, randoms));

numImages = 2000;
perm = randperm(numImages,20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
    drawnow;
end
%saveas(fig,'images/cnnSample.eps','epsc')

[trainingSet, testSet] = splitEachLabel(imds, 0.7, 'randomize');
%% The networks architecture
layers = [ ...
            imageInputLayer([64 64 3])
            convolution2dLayer(5,20)
            reluLayer
            maxPooling2dLayer(2,'Stride',2)

            convolution2dLayer(5,16)
            reluLayer
            maxPooling2dLayer(2,'stride',2)

            fullyConnectedLayer(2)
            softmaxLayer
            classificationLayer];
%% The architecture of the CNN
analyzeNetwork(layers)
options = trainingOptions( 'sgdm', ... %优化器                        
                                      'ExecutionEnvironment','cpu', ...
                                      'LearnRateSchedule','piecewise', ... %学习率
                                      'LearnRateDropFactor',0.2, ...                        
                                      'InitialLearnRate',0.09, ...
                                      'Momentum', 0.9, ... % changing momentum
                                      'GradientThreshold',1, ...
                                      'shuffle','every-epoch', ...
                                      'Verbose',true, ...
                                      'LearnRateDropPeriod',5, ...
                                      'MaxEpochs',150, ... %最大学习整个数据集的次数
                                      'MiniBatchSize',30, ... %每次学习样本数
                                      'ValidationData',{testSet,testSet.Labels}, ...
                                      'Plots','training-progress'); %画出整个训练过程
%% The Data Set and training 
[net,traininfo] = trainNetwork(trainingSet,layers,options);
save 'CSNet.mat' net

YPred = classify(net,testSet);
YTest = testSet.Labels;
accuracy = sum(YPred == YTest)/numel(YTest);
formatSpace = 'The accuracy of test set classification is %7.5f\n';
fprintf(formatSpace,accuracy)

figl=figure;
plot(traininfo.TrainingLoss,'MarkerFaceColor','r')
xlabel("Iteration")
ylabel("Loss")
%saveas(figl,'images/cnnLoss.eps','epsc')
figa = figure;
plot(traininfo.TrainingAccuracy,'MarkerFaceColor','b') 
acc = traininfo.TrainingAccuracy;
save acc.mat acc
xlabel("Iteration")
ylabel("Accuracy(%)")

% figure;
% plotperform(traininfo)
%saveas(figa,'images/cnnAccuracy.eps','epsc')


%plot(net.Layers)
%title('Architecture of Networks')
%set(gca, 'YLim', [150,170]);

figc = figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(YTest,YPred);
cm.Title = 'Confusion Matrix for Test Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';
%saveas(figc,'images/cnnConfusion.eps','epsc')

%% The accuracy vs data size
% figure;
% acc = [1.0, 1.0,1.0,1.0,1.0,1.0, 1.0, 0.9994,0.9989];
% size = [900,800,700,600,500,400,300,200,100];
% plot(size,acc,'s','MarkerFaceColor','#0072BD')
% xlim([0,1000]);
% ylim([0,1]);
% yticks([0:0.2:1.0])
% xlabel('Data Size')
% ylabel('Accuracy')
% figure;
% acc = [1.0, 1.0,1.0,1.0,1.0,1.0, 1.0, 0.9994,0.9989];
% size = [900,800,700,600,500,400,300,200,100];
% plot(size,acc,'s','MarkerFaceColor','#00FFFF')
% xlim([0,1000]);
% ylim([0,1]);
% yticks([0:0.2:1.0])
% xlabel('Data Size')
% ylabel('Accuracy')
diary chaos.out
