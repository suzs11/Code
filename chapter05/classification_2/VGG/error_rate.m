    function [accuracy] = error_rate(kernel_pars)
    % load P; load TV; load TVT; load T;

    load augmentedTrainingSet56; load augmentedTestSet56;
    load YValidation56;
    net=vgg16();
    layersTransfer=net.Layers(1:end-3)
    layers = [
    
    layersTransfer
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

    options = trainingOptions('sgdm', ...
                                        'ExecutionEnvironment','auto', ...
                                        'LearnRateSchedule','piecewise', ... %学习率
                                        'LearnRateDropFactor',0.2, ...  
                                        'LearnRateDropPeriod',5, ...
                                        'GradientThreshold',1, ...
                                        'Momentum', kernel_pars(1),...
                                        'InitialLearnRate',kernel_pars(2), ...
                                        'MaxEpochs',ceil(kernel_pars(3)), ...
                                        'L2Regularization', kernel_pars(4),...    
                                        'Shuffle','every-epoch', ...
                                        'MiniBatchSize', 32,...
                                        'ValidationData',augmentedTestSet56, ...
                                        'ValidationFrequency',30, ...
                                        'Verbose',false,...
                                        'Plots','none');
     net = trainNetwork(augmentedTrainingSet56,layers,options);     
     [YPred] = classify(net,augmentedTestSet56);  
     
     accuracy = sum(YPred == YValidation56)/numel(YValidation56);
     display('Momentum is :  '+string(kernel_pars(1)));
     display('InitialLeranRate is :'+string(kernel_pars(2)));
     display('L2Regularizatio is :'+string(kernel_pars(4)));
     display('MaxEpochs is: '+string(ceil(kernel_pars(3))));
     formatSpace = 'The accuracy of test set classification is %f7\n';
     fprintf(formatSpace,accuracy)
     %diary 'log9_56_N.txt'
     



