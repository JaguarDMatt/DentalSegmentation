%Preprocesamiento

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );

%%

I1=imread(imtrain{1});
szo=[512 735];
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottrain(:,1),szo);

%%

%Contrast-limited adaptive histogram equalization

J = adapthisteq(I);
%%

%Gamma correction
J2 = imadjust(J,[14/255 254/255],[],0.5);


%% Active Contour

Seg=chenvese(J2,'whole',800,0.2,'vector');

%%
Seg1=imresize(Seg,szo);

%%
a=Mat;
b=Seg1;

inter_image = a & b;

% Find the union of the two images
union_image = a | b;

jaccardIdx = sum(inter_image(:))/sum(union_image(:));