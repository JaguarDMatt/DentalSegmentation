% Deteccion dientes

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );

%%

I1=imread(imtrain{1});
szo=[512 735];
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottrain(:,1),szo);
I2=uint8(Mat).*I;

%%

addpath(genpath('Chan-Vese'));

%%
mask=ones(szo);
Seg=chenvese(I,'whole',800,1,'chan');
%%
Segi=imresize(Seg,szo);
I3=uint8(Segi).*I;

%%

Seg2=chenvese(I3,'whole',800,0.2,'chan');
