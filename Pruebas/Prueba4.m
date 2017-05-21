%Prueba 4 con Active Contour

% Deteccion dientes

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
addpath(genpath('Chan-Vese'));

%%

szo=[512 735];
c=2;
jaccard=zeros(size(imtrain));

for i=1:numel(imtrain)
I1=imread(imtrain{i});
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottrain(:,i),szo);
Seg=chenvese(I,'whole',800,0.2,'vector');
Seg1=imresize(Seg,szo);
a=Mat;
b=Seg1;
inter_image = a & b;
union_image = a | b;
jaccard(i)= sum(inter_image(:))/sum(union_image(:));
end
