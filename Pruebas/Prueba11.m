%Prueba 11 con Active Contour

% Deteccion dientes (0.6271)
%Con filtro mediano  y 1000 iter (0.6264)
%Con filtro mediano  y 1 mascara de Otsu(0.6518)
%Con filtro mediano  y 1 mascara de Otsu dilatada(0.6671)

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
addpath(genpath('Chan-Vese'));

%%

szo=[512 735];
jaccard=zeros(size(imtrain));
jaccardD=zeros(size(imtrain));

for i=1:numel(imtrain)
I1=imread(imtrain{i});
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottrain(:,i),szo);

gray=rgb2gray(I1);
gray=imresize(gray,szo);
mask=im2bw(gray,graythresh(gray));
mask=imdilate(mask,strel('sphere',20));

Seg=chenvese(I,mask,1000,0.2,'vector');
Seg1=imresize(Seg,szo,'nearest');

a=Mat;
b=Seg1;
inter_image = a & b;
union_image = a | b;
jaccard(i)= sum(inter_image(:))/sum(union_image(:));

a=lab==3;
inter_image = a & b;
union_image = a | b;
jaccardD(i)= sum(inter_image(:))/sum(union_image(:));
close
end
