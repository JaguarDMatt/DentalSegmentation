
clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
%%

i=2;
I1=imread(imtrain{i});
szo=[512 735];
[ Mat,lab ] = TeethAnnot( anottrain(:,i));

%%
[I,mask]=prepro2(I1);
BW2 = imfill(not(mask),'holes');
stats = regionprops(BW2,'Orientation');
ori=stats.Orientation;
im3=imrotate(I,-ori,'bicubic','crop');
%%
Mat2=imrotate(Mat,-ori,'bicubic','crop');
%%
lab2=imrotate(lab,-ori,'nearest','crop');
%%

bw=imbinarize(I);
bw2=chenvese(I,not(bw)|mask,1000,0.2,'vector');
%%
Ix=sum(I,1);
Ix=Ix/max(Ix);
Iy=sum(I,2);
Iy=Iy/max(Iy);
%%
[pksx,loksx]=findpeaks(1-Iy,'MinPeakDistance',round(numel(Iy)/3));
[pksy,loksy]=findpeaks(1-Ix,'MinPeakDistance',round(numel(Ix)/3));


%%
Imx=I;
Imx(loksx,:)=255;
imshow(Imx);

figure;
Imy=I;
Imy(:,loksy)=255;
imshow(Imy);
%%
Mx=sum(not(mask),1);
My=sum(not(mask),2);
My=My/max(My);
Mx=Mx/max(Mx);