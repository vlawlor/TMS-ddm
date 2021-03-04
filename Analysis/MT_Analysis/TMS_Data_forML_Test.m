

clear all
close all
clc


%% load file - this file contains all subject data
fileName =  '/Users/mttread/Documents/ANALYSES/RCDC_Modeling/TMS_Modeling/TMS/TMS_SVC_IDP.xlsx';
dataAll = importIDP(fileName);
%22= IDP_signed 23 = SVH

%optional conversion of IDP to unsigned
%dataAll(:,22) = abs(dataAll(:,22));

%% initialize conditions
outDir = '/Users/mttread/Documents/ANALYSES/RCDC_Modeling/TMS_Modeling/TMS/ML_test';
if exist(outDir)==0, mkdir(outDir); end
cd(outDir);

%% subj loop
subjlist = [902 904 906 907 908 910 911 912 913 914];

sample = subjlist;
testSample = [];
trainSample = [];
for i = 1:10
    testSample= [testSample; sample(1:3)];
    trainSample = [trainSample; sample(4:end)];
    sample = sample(2:end);
    if i>10
        sample = [sample subjlist(i-10)];
    else
        sample = [sample subjlist(i)];
    end
end
   
        
for s = 1:10
            %Break file into each subject's data
            %replace timeout trials
            TimeOut = dataAll(:,7)<2; %identify timeouts
            data = dataAll(TimeOut,:); 
            
            %disp(size(data));
            
            idx1 = dataAll(:,1)==testSample(s,1);
            idx2 = dataAll(:,1)==testSample(s,2);
            idx3 = dataAll(:,1)==testSample(s,3);
            idxTest = logical(idx1+idx2+idx3);
            %disp(sum(idxTest));
            idxTrain = ~idxTest;
            %disp(sum(idxTrain));
            testData = dataAll(idxTest,:);
            trainData = dataAll(idxTrain,:);
            
            for i = 1:2
                if i ==1
                    data = testData;
                     fileName1 = ['TestData_IDP_fold' num2str(s) '.csv'];
                     fileName2 = ['TestData_SVH_fold' num2str(s) '.csv'];
                     Out1 = [data(:,1) data(:,7) data(:,8) data(:,9) data(:,22) data(:,16)];
                     Out2 = [data(:,1) data(:,7) data(:,8) data(:,9) data(:,23) data(:,16)];
                     csvwrite(fileName1,Out1);
                     csvwrite(fileName2,Out2);
                elseif i == 2
                    data = trainData;
                     fileName1 = ['TrainData_IDP_fold' num2str(s) '.csv'];
                     fileName2 = ['TrainData_SVH_fold' num2str(s) '.csv'];
                     Out1 = [data(:,1) data(:,7) data(:,8) data(:,9) data(:,22) data(:,16)];
                     Out2 = [data(:,1) data(:,7) data(:,8) data(:,9) data(:,23) data(:,16)];
                     csvwrite(fileName1,Out1);
                    csvwrite(fileName2,Out2);
                end
 
            end
        end
% outfile = '/Users/mttread/Documents/ANALYSES/RCDC_Modeling/TMS_Modeling/TMS/TMS_SVH_Quantiles_IDP.xlsx';
% xlswrite(outfile,out); 

