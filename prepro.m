function [ imout] = prepro( imin,varargin )
%Preproccesing
sz=size(imin);

if(numel(sz)==3)
    %Take away color numbers
    dif1=imabsdiff(imin(:,:,1),imin(:,:,2));
    dif1=im2bw(dif1,graythresh(dif1));
    dif2=imabsdiff(imin(:,:,2),imin(:,:,3));
    dif2=im2bw(dif2,graythresh(dif2));
    dif3=imabsdiff(imin(:,:,1),imin(:,:,3));
    dif3=im2bw(dif3,graythresh(dif3));
    dif=or(or(dif1,dif2),dif3);
    imin=times(rgb2gray(imin),uint8(not(dif)));
end

%Median Filter
if(nargin>2)
    w=varargin{2};
else
    w=[9 9];
end
imin = medfilt2(imin,w);

%Contrast-limited adaptive histogram equalization
imin = adapthisteq(imin);

%Gamma correction
imin = imadjust(imin,[],[],0.5);

%Resize the image
if(nargin>1)
    szout=varargin{1};
    imout=imresize(imin,szout);
else
    imout=imin;
end

