%Prueba 12

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
addpath(genpath('Homomorphic filter'));

%%

I1=imread(imtrain{1});
szo=[512 735];
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottrain(:,1),szo);
I2=uint8(Mat).*I;

%%

d=1;
order=6;
im=double(I);
[r c]=size(im);
%%
[im2,imn]=homofil(im,d,r,c,order);