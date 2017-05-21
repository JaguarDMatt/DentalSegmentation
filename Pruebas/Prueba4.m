%Prueba 4 con Active Contour

% Deteccion dientes (0.6271)
%Con filtro mediano  y 1000 iter (0.6264)
%Con filtro mediano  y 1mascara de Otsu(0.6518)

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
addpath(genpath('Chan-Vese'));

%%

szo=[512 735];
c=2;
jaccard=zeros(size(imtest));

for i=1:numel(imtest)
I1=imread(imtest{i});
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottest(:,i),szo);
gray=rgb2gray(I1);
mask=im2bw(I,graythresh(I));
mask=imdilate(mask,strel('disk',20));
Seg=chenvese(I,mask,1000,0.2,'vector');
Seg1=imresize(Seg,szo);
a=Mat;
b=Seg1;
inter_image = a & b;
union_image = a | b;
jaccard(i)= sum(inter_image(:))/sum(union_image(:));
close
end
