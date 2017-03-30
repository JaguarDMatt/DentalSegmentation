function [ imtest,imtrain1,imtrain2,anottest, anottrain1,anottrain2,ttest,ttrain1,ttrain2] = ChargeImages( )
%Charge the images
addpath(genpath('GroundTruthData'));
addpath(genpath('RawImage'));

dirimages=dir('RawImage');
dirimages=extractfield(dirimages,'name');
dirimages=dirimages(3:end);

diranot=dir('GroundTruthData');
diranot=extractfield(diranot,'name');
diranot=diranot(3:end);


%Celulas donde se guardan imagenes, anotaciones y combinacion de
%anotaciones
imtrain1=cell(1,40);
imtrain2=cell(1,40);
imtest=cell(1,40);

anottrain1=cell(7,40);
anottrain2=cell(7,40);
anottest=cell(7,40);

for i=1:numel(dirimages)
    diri=dir(fullfile('RawImage',dirimages{i}));
    names=extractfield(diri,'name');
    names=names(3:end);
    for j=1:numel(names)
        im=imread(fullfile('RawImage',dirimages{i},names{j}));
        im2=preproccesing(im);
        if(strcmp(dirimages{i},'Test1Data')==1)
            imtrain1{j}=im2;
        elseif(strcmp(dirimages{i},'Test2Data')==1)
            imtrain2{j}=im2;
        else
            imtest{j}=im2;
        end
        name=names{j};
        name=name(1:end-4);
        
        for k=1:7
            namea=strcat(name,'_',num2str(k),'.bmp');
            if(strcmp(diranot{i},'Training')==1)
                anot=imread(fullfile('GroundTruthData',diranot{i},name,namea));
            else
                anot=imread(fullfile('GroundTruthData',diranot{i},namea));
            end
            sz=size(anot);
            if(numel(sz)>2)
                anot=rgb2gray(anot);
            end
            anot=im2bw(anot,graythresh(anot));
            nanot=not(anot);
            if(sum(anot(:))>sum(nanot(:)))
               anot=nanot; 
            end
            anot=imresize(anot,[512 735]);
            if(strcmp(dirimages{i},'Test1Data')==1)
                anottrain1{k,j}=anot;
            elseif(strcmp(dirimages{i},'Test2Data')==1)
                anottrain2{k,j}=anot;
            else
                anottest{k,j}=anot;
            end
        end
    end
end

%%
ttrain1=cell(1,40);
ttrain2=cell(1,40);
ttest=cell(1,40);

for i=1:40
    bw1=anottrain1{1,i};
    bw2=anottrain2{1,i};
    bw3=anottest{1,i};
    for j=2:7
        bw1=or(bw1,anottrain1{j,i});
        bw2=or(bw2,anottrain2{j,i});
        bw3=or(bw3,anottest{j,i});
    end
    ttrain1{i}=imresize(imfill(bw1,'holes'),[512 735]);
    ttrain2{i}=imresize(imfill(bw2,'holes'),[512 735]);
    ttest{i}=imresize(imfill(bw3,'holes'),[512 735]);
end

end

function [ imout ] = preproccesing( imin )
%Preproccesing

%Take away color numbers
dif1=imabsdiff(imin(:,:,1),imin(:,:,2));
dif1=im2bw(dif1,graythresh(dif1));
dif2=imabsdiff(imin(:,:,2),imin(:,:,3));
dif2=im2bw(dif2,graythresh(dif2));
dif3=imabsdiff(imin(:,:,1),imin(:,:,3));
dif3=im2bw(dif3,graythresh(dif3));
dif=or(or(dif1,dif2),dif3);
imo=times(rgb2gray(imin),uint8(not(dif)));

%Resize the image
imout=imresize(imo,[512 735]);
end

