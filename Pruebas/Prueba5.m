%Prueba 5 con Active Contour y tamaños desiguales

% Deteccion dientes (0.6271)

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
addpath(genpath('Chan-Vese'));

%%
c=2;
jaccard=zeros(size(imtest));

for i=1:numel(imtest)
I1=imread(imtest{i});
gray=rgb2gray(I1);
szo=size(gray);
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottest(:,i),szo);
mask=gray~=0;
Seg=chenvese(I,mask,800,0.2,'vector');
Seg1=imresize(Seg,szo);
a=Mat;
b=Seg1;
inter_image = a & b;
union_image = a | b;
jaccard(i)= sum(inter_image(:))/sum(union_image(:));
close
end
