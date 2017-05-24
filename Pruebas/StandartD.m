%Standard

sz=size(imin);
if(numel(sz)==3)
    %Take away color numbers
    igray=zeros(sz,'uint8');
    estandar=std(im2double(imin),0,3);
    bw=im2bw(estandar,graythresh(estandar));
%     bw=imdilate(bw,strel('sphere',1));
    igray(:,:,1)=regionfill(imin(:,:,1),bw);
    igray(:,:,2)=regionfill(imin(:,:,2),bw);
    igray(:,:,3)=regionfill(imin(:,:,3),bw);
    igray=rgb2gray(igray);
else
    igray=I1;
end