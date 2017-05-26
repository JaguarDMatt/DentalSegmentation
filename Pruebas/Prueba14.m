
clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
%%

i=5;
I1=imread(imtrain{i});
szo=[512 735];
[ Mat,lab ] = TeethAnnot( anottrain(:,i));

%%
[I,mask]=prepro2(I1);
[I2,fullmask,ori]=preprorot(I1);

%%


%%

bw=imbinarize(I);
bw2=chenvese(I,not(bw)|mask,1000,0.2,'vector');
%%
Ix=sum(I2,1);
Ix=Ix/max(Ix);
Iy=sum(I2,2);
Iy=Iy/max(Iy);
%%
[pksx,loksx]=findpeaks(1-Iy,'MinPeakDistance',round(numel(Iy)/3));
[pksy,loksy]=findpeaks(1-Ix,'MinPeakDistance',round(numel(Ix)/3));


%%
Imx=I2;
Imx(loksx,:)=255;
imshow(Imx);

figure;
Imy=I2;
Imy(:,loksy)=255;
imshow(Imy);
%%
Mx=sum(not(mask),1);
My=sum(not(mask),2);
My=My/max(My);
Mx=Mx/max(Mx);