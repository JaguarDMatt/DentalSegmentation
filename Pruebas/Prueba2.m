%Prueba 2 con Fuzzy C Means

% Deteccion dientes

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
addpath(genpath('Fast_C__and_Fuzzy_C_Means'));

%%

szo=[512 735];
c=2;
jaccard=zeros(size(imtrain));

for i=1:numel(imtrain)
I1=imread(imtrain{i});
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottrain(:,i),szo);
[L,C,U,LUT,H]=FastFCMeans(I,c);
a=Mat;
b=L==2;
inter_image = a & b;
union_image = a | b;
jaccard(i)= sum(inter_image(:))/sum(union_image(:));
end
