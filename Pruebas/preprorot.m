function [ imout,fullmask,ori ] = preprorot( imin )
% Preprocessing

S = sum(imin,3);

%Find brighter parts
[x,y]=find(S==max(S(:)));
inds=sub2ind(size(S),x,y);
bright=zeros(size(S));
bright(inds)=1;
bright=logical(bright);
bright=imdilate(bright,strel('sphere',2));

%Find darker parts
[u,v]=find(S==min(S(:)));
inds2=sub2ind(size(S),u,v);
dark=zeros(size(S));
dark(inds2)=1;
dark=logical(dark);
dark=imdilate(dark,strel('sphere',2));
mask=dark | bright;

%Find differences in RGB channels
dif1=imabsdiff(imin(:,:,1),imin(:,:,2));
dif1=dif1>0;
dif2=imabsdiff(imin(:,:,2),imin(:,:,3));
dif2=dif2>0;
dif3=imabsdiff(imin(:,:,1),imin(:,:,3));
dif3=dif3>0;
dif=dif1 | dif2| dif3;
fullmask=mask|dif;
newim=rgb2gray(imin).*uint8(not(fullmask));

%Rotation & Inward Interpolation
BW2 = imfill(not(fullmask),'holes');
num=xor(BW2,not(fullmask));
num2=imdilate(num,strel('sphere',2));
newim2=regionfill(newim,num2);
stats = regionprops(BW2,'Orientation');
ori=stats.Orientation;
newim=imrotate(newim2,-ori(1),'bicubic','crop');
fullmask=imrotate(fullmask,-ori(1),'bicubic','crop');

%Median Filter
imfil = medfilt2(newim);

%Contrast-limited adaptive histogram equalization
imout= adapthisteq(imfil,'Distribution','rayleigh');

end

