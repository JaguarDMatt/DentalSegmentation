%SVM

[ imtest,imtrain1,imtrain2,anottest, anottrain1,anottrain2,ttest,ttrain1,ttrain2] = ChargeImagesWR( );

%%

%7 classes

if(exist('info.mat','file')==0)
    classes=cell(8,1);
    for cl=1:size(anottrain1,1)
        class.int=[];
        class.mag=[];
        class.dir=[];
        for i=1:numel(imtrain1)
            anot=anottrain1{cl,i};
            if(sum(anot(:))==0)
                continue;
            else
                im=imtrain1{i};
                [Gmag,Gdir] = imgradient(im);
                inti=prctile(double(im(anot)),0:100);
                magi=prctile(double(Gmag(anot)),0:100);
                diri=prctile(double(Gdir(anot)),0:100);
                class.int=cat(1,class.int,inti');
                class.mag=cat(1,class.mag,magi');
                class.dir=cat(1,class.dir,diri');
            end
        end
        classes{cl}=class;
    end
    
    
    %Background
    class.int=[];
    class.mag=[];
    class.dir=[];
    for i=1:numel(imtrain1)
        anot=not(ttrain1{i});
        im=imtrain1{i};
        [Gmag,Gdir] = imgradient(im);
        inti=prctile(double(im(anot)),0:100);
        magi=prctile(double(Gmag(anot)),0:100);
        diri=prctile(double(Gdir(anot)),0:100);
        class.int=cat(1,class.int,inti');
        class.mag=cat(1,class.mag,magi');
        class.dir=cat(1,class.dir,diri');
    end
    
    classes{8}=class;
    
    %Dientes
    classd.int=[];
    classd.mag=[];
    classd.dir=[];
    for i=1:numel(imtrain1)
        anot=ttrain1{i};
        im=imtrain1{i};
        [Gmag,Gdir] = imgradient(im);
        inti=prctile(double(im(anot)),0:100);
        magi=prctile(double(Gmag(anot)),0:100);
        diri=prctile(double(Gdir(anot)),0:100);
        classd.int=cat(1,classd.int,inti');
        classd.mag=cat(1,classd.mag,magi');
        classd.dir=cat(1,classd.dir,diri');
    end
    save('info.mat','classes','classd');
    display('Data saved');
else
    load('info.mat');
end
%% ubicaion espacial

% prob=cell(8,1);
% for cl=1:size(anottrain1,1)
% probc=anottrain1{cl,1};
% for i=2:size(anottrain1,2)
%     probc=imadd(probc,anottrain1{cl,i});
% end
% probc=probc/(max(probc(:)));
% end

%%

if(exist('dataanto.mat','file')==0)
    data=[];
    anot=[];
    for i=1:numel(classes)
        classi=classes{i};
        inti=classi.int;
        magi=classi.mag;
        diri=classi.dir;
        anoti=ones(size(inti))*i;
        datai=horzcat(inti,magi,diri);
        data=cat(1,data,datai);
        anot=cat(1,anot,anoti);
    end
    save('dataanto.mat','data','anot');
    display('data to tree');
else
    load('dataanto.mat');
end

%%

if(exist('dataanto2.mat','file')==0)
    data=[];
    anot=[];
    for i=1:numel(classes)
        classi=classes{i};
        inti=classi.int;
        magi=classi.mag;
        diri=classi.dir;
        if(i<8)
            anoti=ones(size(inti))*1;
        else
            anoti=ones(size(inti))*2;
        end
        datai=horzcat(inti,magi,diri);
        data=cat(1,data,datai);
        anot=cat(1,anot,anoti);
    end
    save('dataanto2.mat','data','anot');
    display('data2 to tree');
else
    load('dataanto2.mat');
end

%%

load('dataanto.mat')
B=TreeBagger(25,double(data),anot);
save('model.mat','B');
display('finish');

%%
load('dataanto2.mat')
B=TreeBagger(50,double(data),anot);
save('model2.mat','B');
display('finish');

%%
datadientes=horzcat(classd.int,classd.mag,classd.dir);
datafondo=horzcat(class.int,class.mag,class.dir);
data2=cat(1,datadientes,datafondo);
anot2=cat(1,ones(size(classd.int)),zeros(size(class.int)));

%%

% Mdl = svmtrain(double(data2),anot2);
% save('model2.mat','Mdl');
% display('Finish 2');

%%

%Clasificacion

classy=cell(size(imtest));
scory=cell(size(imtest));
for i=1:numel(imtest)
    im=double(imtest{i});
    [x,y]=size(im);
    [Gmag,Gdir] = imgradient(im);
    inti=reshape(im,x*y,1);
    magi=reshape(Gmag,x*y, 1);
    diri=reshape(Gdir,x*y,1);
    Xi=horzcat(inti,magi,diri);
    [Yfit,scores] = predict(B,Xi);
    classy{i}=reshape(str2num(cell2mat(Yfit)),x,y);
    scory{i}=scores;
    display(num2str(100*i/numel(imtest)));
end

save('classy.mat','classy','scory','-v7.3');

%%

classy=cell(size(imtest));
scory=cell(size(imtest));
parfor i=1:numel(imtest)
    im=double(imtest{i});
    [x,y]=size(im);
    [Gmag,Gdir] = imgradient(im);
    inti=reshape(im,x*y,1);
    magi=reshape(Gmag,x*y, 1);
    diri=reshape(Gdir,x*y,1);
    Xi=horzcat(inti,magi,diri);
    [Yfit,scores] = predict(B,Xi);
    classy{i}=reshape(str2num(cell2mat(Yfit)),x,y);
    scory{i}=scores;
    display(num2str(100*i/numel(imtest)));
end

save('classy2.mat','classy','scory','-v7.3');
%%
load('classy.mat');

%%
jaccard=zeros(size(anottest,2),8);
for i=1:size(anottest,2)
    for j=1:size(anottest,1)
        pred=classy{i}==j;
        true=anottest{j,i};
        inter_image = pred & true;
        union_image = pred | true;
        jaccard(i,j) = sum(inter_image(:))/sum(union_image(:));
    end
    pred=classy{i}==8;
    true=not(ttest{i});
    inter_image = pred & true;
    union_image = pred | true;
    jaccard(i,8) = sum(inter_image(:))/sum(union_image(:));
end

%%
save('treeresults.mat','jaccard');