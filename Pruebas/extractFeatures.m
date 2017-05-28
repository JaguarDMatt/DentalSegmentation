clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );

%%
u=3;
v=8;

gaborArray = gaborFilterBank(u,v,39,39);
%%
info=cell(numel(anottrain),1);
labels=cell(numel(anottrain),1);

%%
sample=2000;

numl=size(anottrain,1);
for i=1:numel(imtrain)
    I1=imread(imtrain{i});
    [I2,mask,ori]=preprorot(I1);
    [Mat,lab] = TeethAnnot( anottrain(:,i),size(I2),ori);
    [featureVector,gaborResult] = gaborFeatures(I2,gaborArray,1,1);
    [Gmag,Gdir]= imgradient(I2);
    I3=im2double(I2);
    for l=1:numl
        matl=lab==l;
        if(any(matl(:))==0)
            continue;
        else
            int=I3(matl);
            mag=Gmag(matl);
            dir=Gdir(matl);
            infoil=horzcat(int,mag,dir);
            infoilf=zeros(numel(int),u*v);
            for j=1:u
                for k=1:v
                    infoilf(:,(j-1)*v+k)=abs(gaborResult{u,v}(matl));
                end
            end
            infos=horzcat(infoil,infoilf);
            infos=datasample(infos,sample,1);
            labels{(i-1)*numl+l}=ones(sample,1)*l;
            info{(i-1)*numl+l}=infos;
        end
        display(100*((i-1)*numl+l)/(numl*numel(imtrain)));
    end
end


%% Final

data=cell2mat(info);
lbls=cell2mat(labels);
save('info.mat','data','lbls');