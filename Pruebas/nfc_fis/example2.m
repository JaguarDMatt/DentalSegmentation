%       Written by Dr. Bayram Cetiþli Suleyman Demirel University Computer
%       Engineeering Isparta Turkey
%The iris data has 150 samples, 4 attributes and 3 classes.
%       Written by Dr. Bayram Cetiþli Suleyman Demirel University Computer
%       Engineeering Isparta Turkey
clear all;
close all;
load iris.dat
%iris.dat has 150 samples, 4 features and 3 classes.
%Here, the data is equally divided to train and test sets
input=iris(1:2:end,1:4);
test=iris(2:2:end,1:4);
target_tr=iris(1:2:end,5);
target_te=iris(2:2:end,5);
%first classifier
%[fismat,outputs,recog_tr,recog_te,labels,performance]=scg_nfc(input,target_tr,test,target_te,epoch,class,clustersize);
[fismat,outputs,recog_tr,recog_te,labels,performance]=scg_nfc(input,target_tr,test,target_te,100,3,1);

%second classifier
%[fismat,outputs,recog_tr,recog_te,labels,performance]=scg_pow_nfc(input,target_tr,test,target_te,epoch,class,clustersize);
[fismat1,outputs,recog_tr,recog_te,labels,performance]=scg_pow_nfc(input,target_tr,test,target_te,100,3,1);

%third classifier
%[fismat,outputs,recog_tr,recog_te,labels,performance]=scg_nfclass_speedup(input,target_tr,test,target_te,stepsize,class,clustsize);
[fismat3,outputs,recog_tr,recog_te,labels,performance]=scg_nfclass_speedup(input,target_tr,test,target_te,100,3,1);

%feature selection
%[fismat,feature,outputs,recog_tr,recog_te,labels,performance]=nfc_feature_select(input,target_tr,test,target_te,epoch,class,clustersize);
[fismat4,feature,outputs,recog_tr,recog_te,labels,performance]=nfc_feature_select([input;test],[target_tr;target_te],test,target_te,1000,3);
%Classification with selected features
[fismat5,outputs,recog_tr,recog_te,labels,performance]=scg_pow_nfc(input(:,feature.selected),target_tr,test(:,feature.selected),target_te,100,3,2);


