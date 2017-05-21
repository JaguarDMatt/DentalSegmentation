%Prueba 2 con Fuzzy C Means

% Deteccion dientes (0.648)
% con filtro mediano(0.6516)

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
addpath(genpath('Fast_C__and_Fuzzy_C_Means'));

%%

szo=[512 735];
c=2;
jaccard=zeros(size(imtest));

for i=1:numel(imtest)
I1=imread(imtest{i});
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottest(:,i),szo);
[L,C,U,LUT,H]=FastFCMeans(I,c);
a=Mat;
b=L==2;
inter_image = a & b;
union_image = a | b;
jaccard(i)= sum(inter_image(:))/sum(union_image(:));
end
