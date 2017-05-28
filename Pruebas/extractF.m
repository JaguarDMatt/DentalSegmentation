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
gaborArray = gaborFilterBank(3,8,39,39);
[featureVector,gaborResult] = gaborFeatures(I2,gaborArray,1,1);
[Gmag,Gdir]= imgradient(I2);

%%

h = fspecial('laplacian', 0.2);
Ilp=imfilter(I2,h);
%%

I3=im2double(I2);

%Features fondo
fondo=lab==0;
intensidad=I3(fondo);
intf=prctile(intensidad,1:100);
filtro1=abs(gaborResult{1,1}(fondo));
fil1f=prctile(filtro1,1:100);
filtro2=abs(gaborResult{1,2}(fondo));
fil2f=prctile(filtro2,1:100);
filtro3=abs(gaborResult{1,3}(fondo));
fil3f=prctile(filtro3,1:100);
filtro4=abs(gaborResult{1,4}(fondo));
fil4f=prctile(filtro4,1:100);
filtro5=abs(gaborResult{1,5}(fondo));
fil5f=prctile(filtro5,1:100);

%No fondo
nfondo=lab~=0;
intensidad=I3(nfondo);
intn=prctile(intensidad,1:100);
filtro1=abs(gaborResult{1,1}(nfondo));
fil1n=prctile(filtro1,1:100);
filtro2=abs(gaborResult{1,2}(nfondo));
fil2n=prctile(filtro2,1:100);
filtro3=abs(gaborResult{1,3}(nfondo));
fil3n=prctile(filtro3,1:100);
filtro4=abs(gaborResult{1,4}(nfondo));
fil4n=prctile(filtro4,1:100);
filtro5=abs(gaborResult{1,5}(nfondo));
fil5n=prctile(filtro5,1:100);

%%
Y=[zeros(1,100) ones(1,100)];
X=[intf intn; fil1f fil1n; fil2f fil2n; fil3f fil3n; fil4f fil4n; fil5f fil5n];
Mdl = fitcsvm(X',Y');