clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
load('infoTest');
ModeloEntrenadoF=load('ModeloEntrenado.mat');

%% 

pred=cell(size(imtest));
s=cell(size(imtest));
for i=1:numel(imtest)
   features=info{i};
   label=labels{i};
   
   image=imread(imtest{i});
   [m,n]=size(image);
   [predic,scores] = predict(ModeloEntrenadoF,features);
   numimage=str2num(cell2mat(predic));
   pred{i}=reshape(numimage,m,n);
   s{i}=scores;
end

save('Predict.mat','pred','labels','s','-v7.3');