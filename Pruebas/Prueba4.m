%Prueba 4 con Active Contour

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
jaccardTrain=zeros(size(imtest));

for i=1:numel(imtrain)
I1=imread(imtrain{i});
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottrain(:,i),szo);
gray=rgb2gray(I1);
mask=im2bw(I,graythresh(I));
mask=imdilate(mask,strel('sphere',20));
Seg=chenvese(I,mask,1000,0.2,'vector');
Seg1=imresize(Seg,szo,'bicubic');
a=Mat;
b=Seg1;
inter_image = a & b;
union_image = a | b;
jaccardTrain(i)= sum(inter_image(:))/sum(union_image(:));
close
end


%%

szo=[512 735];
pred=cell(size(imtest));
jaccardTest=zeros(size(imtest));

for i=1:numel(imtest)
I1=imread(imtest{i});
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottest(:,i),szo);
gray=rgb2gray(I1);
mask=im2bw(I,graythresh(I));
mask=imdilate(mask,strel('sphere',20));
Seg=chenvese(I,mask,1000,0.2,'vector');
Seg1=imresize(Seg,szo,'bicubic');
a=Mat;
b=Seg1;
inter_image = a & b;
union_image = a | b;
jaccard(i)= sum(inter_image(:))/sum(union_image(:));
pred{i}=b;
close
end