clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );

%%
i=10;
I1=imread(imtrain{i});
[I2,mask,ori]=preprorot(I1);
[Mat,lab] = TeethAnnot( anottrain(:,i),size(I2),ori);

%%
gaborArray = gaborFilterBank(3,8,39,39);

%%
[featureVector,gaborResult] = gaborFeatures(I2,gaborArray,1,1);
[Gmag,Gdir]= imgradient(I2);

%%
[rotatedIm,levelMax] = RotateIm(I2);
%%

h = fspecial('laplacian', 0.2);
Ilp=imfilter(I2,h);
%%

I3=im2double(I2);

%Features fondo
fondo=lab==0;
intensidad=I3(fondo);
filtro1=abs(gaborResult{1,1}(fondo));
filtro2=abs(gaborResult{1,2}(fondo));
filtro3=abs(gaborResult{1,3}(fondo));
filtro4=abs(gaborResult{1,4}(fondo));
filtro5=abs(gaborResult{1,5}(fondo));

intf=intensidad;
fil1f=filtro1;
fil2f=filtro2;
fil3f=filtro3;
fil4f=filtro4;
fil5f=filtro5;

%No fondo
nfondo=lab~=3;
intensidad=I3(nfondo);
filtro1=abs(gaborResult{1,1}(nfondo));
filtro2=abs(gaborResult{1,2}(nfondo));
filtro3=abs(gaborResult{1,3}(nfondo));
filtro4=abs(gaborResult{1,4}(nfondo));
filtro5=abs(gaborResult{1,5}(nfondo));


intn=intensidad;
fil1n=filtro1;
fil2n=filtro2;
fil3n=filtro3;
fil4n=filtro4;
fil5n=filtro5;

%%
Y=vertcat(zeros(size(intf)),ones(size(intn)));
X=vertcat(horzcat(intf,fil1f,fil3f,fil4f,fil5f),horzcat(intn,fil1n,fil3n,fil4n,fil5n));
Mdl = fitcsvm(X,Y);