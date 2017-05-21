% Prueba 10

%Clasificacion

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );

%%
I1=imread(imtrain{1});
I=prepro(I1);
[ Mat,lab ] = TeethAnnot( anottrain(:,1));
[L,NumLabels] = superpixels(I,100);
%%

BW = boundarymask(L);
imshow(imoverlay(I,BW,'cyan'),'InitialMagnification',67)