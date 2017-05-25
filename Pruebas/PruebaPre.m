%Prueba Pre

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
%addpath(genpath('Homomorphic filter'));

%%
i=1;
I1=imread(imtrain{i});
szo=[512 735];
[ Mat,lab ] = TeethAnnot( anottrain(:,i));

%%

imin=I1;
%Preproccesing
S = sum(imin,3);
[x,y]=find(S==max(S(:)));
inds=sub2ind(size(S),x,y);
bright=zeros(size(S));
bright(inds)=1;
bright=logical(bright);
bright=imdilate(bright,strel('sphere',2));

[u,v]=find(S==min(S(:)));
inds2=sub2ind(size(S),u,v);
dark=zeros(size(S));
dark(inds2)=1;
dark=logical(dark);
dark=imdilate(dark,strel('sphere',2));
mask=dark | bright;

sz=size(imin);
if(numel(sz)==3)
 dif1=imabsdiff(imin(:,:,1),imin(:,:,2));
    dif1=dif1>0;
    dif2=imabsdiff(imin(:,:,2),imin(:,:,3));
    dif2=dif2>0;
    dif3=imabsdiff(imin(:,:,1),imin(:,:,3));
    dif3=dif3>0;
    dif=dif1 | dif2| dif3;
    fullmask=mask|dif;
else
    fullmask=mask;
end
imshow(fullmask);
figure;
newim=rgb2gray(I1).*uint8(not(fullmask));
imshow(newim);
%%
gray=rgb2gray(I1);
roi=not(fullmask);
[Gmag,Gdir] = imgradient(gray);
intensity=gray(roi);
labels=lab(roi);
grad=Gmag(roi);
dir=Gdir(roi);

data=horzcat(intensity,grad,dir);

%%

B = TreeBagger(25,double(data),labels);

%%

labelpre = predict(B,double(data));
cell=cell2mat(labelpre);
labelpre=str2num(cell);

%%
lgray=zeros(size(fullmask),'uint8');
lgray(roi)=uint8(labelpre);
%%
%Median Filter
imin=newim;
w=[6 6];
imfil = medfilt2(imin,w);

%%
imin=imfil;
%Contrast-limited adaptive histogram equalization
imad = adapthisteq(imin,'Distribution','rayleigh');

%%
imin=imad;
%Gamma correction
imgamma = imadjust(imin,[],[],1.5);

%%
%Resize the image
