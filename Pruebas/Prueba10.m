% Prueba 10

%Clasificacion

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );

%%

szo=[512 735];
Mats=zeros([szo numel(imtrain)],'uint8');
for i=1:numel(imtrain)
I1=imread(imtrain{i});
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottrain(:,i),szo);
Mats(:,:,i)=Mat;
end

mean=uint8(mean(Mats,3)*255);
%%
