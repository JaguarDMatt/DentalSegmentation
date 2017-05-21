function [ Mat,lab ] = TeethAnnot( anots,sz)
%Combine annotations to a global annotation binary matrix and a label
%matrix

%First image annotation
I1=imread(anots{1});
if(numel(size(I1))==3)
    I1=rgb2gray(I1);
end
I1=imresize(I1,sz);

%Binary image
bw=im2bw(I1,graythresh(I1));
nbw=not(bw);
if(sum(bw(:))>sum(nbw(:)))
    bw=nbw;
end

%Label matrix
lbl=uint8(bw);

for i=2:numel(anots)
    Ii=imread(anots{i});
    if(numel(size(Ii))==3)
        Ii=rgb2gray(Ii);
    end
    Ii=imresize(Ii,sz);
    bwi=im2bw(Ii,graythresh(Ii));
    nbwi=not(bwi);
    if(sum(bwi(:))>sum(nbwi(:)))
        bwi=nbwi;
    end
    lbl=lbl+(uint8(bwi)*i);
    bw=or(bw,bwi);
end

%output: binary annotation and labels
Mat=imfill(bw,'holes');
lab=uint8(lbl);
end

