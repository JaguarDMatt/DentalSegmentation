clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );

%%
i=10;
I1=imread(imtrain{i});
szo=[512 735];
imshow(I1);
[I2,mask,ori]=preprorot(I1);
[Mat,lab] = TeethAnnot( anottrain(:,i),size(I2),ori);
%%
[featureVector,gaborResult] = gaborFeatures(I2,gaborArray,1,1);
[Gmag,Gdir]= imgradient(I2);

%%

h = fspecial('laplacian', 0.2);
Ilp=imfilter(I2,h);
%%

%Features fondo
fondo=lab==0;
I3=im2double(I2);
intensidad=I3(fondo);
intf=prctile(intensidad,1:100);
filtro1=abs(gaborResult{1,1}(fondo));
filf=prctile(filtro1,1:100);


%No fondo
nfondo=lab~=0;
intensidad=I3(nfondo);
intn=prctile(intensidad,1:100);
filtro1=abs(gaborResult{1,1}(nfondo));
filn=prctile(filtro1,1:100);

%%
Y=[zeros(1,100) ones(1,100)];

Mdl = fitcsvm(X,Y);