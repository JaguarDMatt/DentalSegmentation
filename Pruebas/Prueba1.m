% Prueba 1

%HOG

% Deteccion dientes

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );

I1=imread(imtrain{1});
[I,mask,ori]=preprorot(I1);
[ Mat,lab ] = TeethAnnot( anottrain(:,1),size(I),ori);
I2=uint8(Mat).*I;

%%
run('vlfeat/toolbox/vl_setup')

%%
cellSize = 2;
hog = vl_hog(im2single(I), cellSize,'numOrientations', 9) ;
imhog = vl_hog('render', hog,'numOrientations', 9) ;

%%

imhog1=imresize(imhog,szo);

%%

imhog2=uint8(imhog1*255/max(imhog1(:)));