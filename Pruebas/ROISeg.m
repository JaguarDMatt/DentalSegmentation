function [ SegF ] = ROISeg( I1,varargin )
%ROI Segmentation 
%   JI:66,7%
if(nargin>1)
    szo=varargin{1};
    I=prepro(I1,szo);
else
     I=prepro(I1);
     szo=size(I);
end
mask=im2bw(I,graythresh(I));
mask=imdilate(mask,strel('sphere',20));
Seg=chenvese(I,mask,1000,0.2,'vector');
SegF=imresize(Seg,szo,'bicubic');
end

