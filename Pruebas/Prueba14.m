
clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
%%

i=10;
I1=imread(imtrain{i});
szo=[512 735];
[ Mat,lab ] = TeethAnnot( anottrain(:,i));
imshow(I1)

%%
[I,mask]=prepro2(I1);
[I2,fullmask,ori]=preprorot(I1);
[ Mat,lab ] = TeethAnnot( anottrain(:,i),size(I2),ori);

imshowpair(I1,I2,'montage');
%%
bw=imbinarize(I2);
%%
bw2=chenvese(I2,Imy,1000,0.2,'chan');

%%
Ix=sum(I2,1);
Ix=Ix/max(Ix);
Iy=sum(I2,2);
Iy=Iy/max(Iy);
%%
[pksx,loksx]=findpeaks(1-Iy,'MinPeakDistance',round(numel(Iy)/3));
[pksy,loksy]=findpeaks(1-Ix,'MinPeakDistance',round(numel(Ix)/3));

%%
Imx=fullmask;
Imx(1:loksx(1))=false;
Imx(loksx(end):end,:)=false;
imshow(Imx);

%%
figure;
Imy=fullmask;
Imy(:,1:loksy(1))=false;
Imy(:,loksy(end):end)=false;
imshow(Imy);
%%
Mx=sum(not(mask),1);
My=sum(not(mask),2);
My=My/max(My);
Mx=Mx/max(Mx);