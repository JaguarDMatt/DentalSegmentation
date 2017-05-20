% Prueba 1

%HOG

% Deteccion dientes

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );

%%

I1=imread(imtrain{1});
szo=[512 735];
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottrain(:,1),szo);

%% HOG
[hog1,visualization] = extractHOGFeatures(I1,'CellSize',[1 1]);

%%
NumBins=9;
CellSize=[1 1];
BlockSize=[3 3];
BlockOverlap=ceil(BlockSize/2);
BlocksPerImage = floor((size(I1)./CellSize - BlockSize)./(BlockSize - BlockOverlap) + 1);
%%
plot(visualization);

F = getframe;