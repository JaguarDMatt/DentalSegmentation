[ imtest,imtrain1,imtrain2,anottest, anottrain1,anottrain2,ttest,ttrain1,ttrain2] = ChargeImagesWR( );

%% New annotations

if(exist('newanot.mat','file')==0)
    inside=cell(size(ttrain1));
    border=cell(size(ttrain1));
    
    display('Create new annotations');
    
    for i=1:numel(ttrain1)
        inside{i}=imerode(ttrain1{i}, strel('sphere',30));
        border{i}=xor(ttrain1{i},inside{i});
        display(100*i/numel(ttrain1));
    end
    
    display('New annotations: Done');
else
    load('newanot.mat');
end
%%

if(exist('infoS.mat','file')==0)
    display('Extract Info')
    
    bg.int=[];
    bg.mag=[];
    bg.dir=[];
    bg.posx=[];
    bg.posy=[];
    
    in.int=[];
    in.mag=[];
    in.dir=[];
    in.posx=[];
    in.posy=[];
    
    bd.int=[];
    bd.mag=[];
    bd.dir=[];
    bd.posx=[];
    bd.posy=[];
    
    for i=1:numel(ttrain1)
        insi=inside{i};
        bordi=border{i};
        backi=not(ttrain1{i});
        
        im=imtrain1{i};
        [Gmag,Gdir] = imgradient(im);
        [m,n]=size(im);
        [XX,YY] = meshgrid(1:n,1:m);
        
        %Background
        inti=prctile(double(im(backi)),0:100);
        magi=prctile(double(Gmag(backi)),0:100);
        diri=prctile(double(Gdir(backi)),0:100);
        posxi=prctile(double(XX(backi)),0:100);
        posyi=prctile(double(YY(backi)),0:100);
        bg.int=cat(1,bg.int,inti');
        bg.mag=cat(1,bg.mag,magi');
        bg.dir=cat(1,bg.dir,diri');
        bg.posx=cat(1,bg.posx,posxi');
        bg.posy=cat(1,bg.posy,posyi');
        %Border
        inti=prctile(double(im(bordi)),0:100);
        magi=prctile(double(Gmag(bordi)),0:100);
        diri=prctile(double(Gdir(bordi)),0:100);
        posxi=prctile(double(XX(bordi)),0:100);
        posyi=prctile(double(YY(bordi)),0:100);
        bd.int=cat(1,bd.int,inti');
        bd.mag=cat(1,bd.mag,magi');
        bd.dir=cat(1,bd.dir,diri');
        bd.posx=cat(1,bd.posx,posxi');
        bd.posy=cat(1,bd.posy,posyi');
        %Inside
        inti=prctile(double(im(insi)),0:100);
        magi=prctile(double(Gmag(insi)),0:100);
        diri=prctile(double(Gdir(insi)),0:100);
        posxi=prctile(double(XX(insi)),0:100);
        posyi=prctile(double(YY(insi)),0:100);
        in.int=cat(1,in.int,inti');
        in.mag=cat(1,in.mag,magi');
        in.dir=cat(1,in.dir,diri');
        in.posx=cat(1,in.posx,posxi');
        in.posy=cat(1,in.posy,posyi');
    end
    
    clear inti magi diri posxi posyi im Gmag Gdir XX YY m n;
    clear backi bordi insi;
    save('infoS.mat','bg','bd','in');
    display('Done');
    
else
    load('infoS.mat');
    display('Done Loading Info');
end

%% Informacion de Entrenamiento

borders=cat(2,bd.int,bd.mag,bd.dir);%,bd.posx,bd.posy);
ab=ones(size(bd.int));
centers=cat(2,in.int,in.mag,in.dir);%,in.posx,in.posy);
ai=ones(size(in.int))*2;
backs=cat(2,bg.int,bg.mag,bg.dir);%,bg.posx,bg.posy);
abk=ones(size(bg.int))*3;

data=cat(1,borders,centers,backs);
anot=cat(1,ab,ai,abk);

clear ab ai abk borders centers backs;

%% Modelo

B = TreeBagger(50,data,anot);
save('modelS.mat','B');

%%

%Clasificacion Pixel a Pixel

classy=cell(size(imtest));
scory=cell(size(imtest));
for i=1:numel(imtest)
    im=double(imtest{i});
    [x,y]=size(im);
    [Gmag,Gdir] = imgradient(im);
    %[XX,YY] = meshgrid(1:y,1:x);
    inti=reshape(im,x*y,1);
    magi=reshape(Gmag,x*y, 1);
    diri=reshape(Gdir,x*y,1);
    %posxi=reshape(XX,x*y,1);
    %posyi=reshape(YY,x*y,1);
    Xi=horzcat(inti,magi,diri);%,posxi,posyi);
    [Yfit,scores] = predict(B,Xi);
    classy{i}=reshape(str2num(cell2mat(Yfit)),x,y);
    scory{i}=scores;
    display(num2str(100*i/numel(imtest)));
end

save('classyS.mat','classy','scory','-v7.3');

%% Cargo Prediciones

load('classyS.mat');

%% Evaluacion

Jaccards=zeros(size(ttest));

for i=1:numel(ttest)
    pred=classy{i}~=3;
    true=ttest{i};
    inter_image = pred & true;
union_image = pred | true;
Jaccards(i) = sum(inter_image(:))/sum(union_image(:));
end

%% Numero Segmentacion de Dientes

meanJ=mean(Jaccards);

save('tsegresults','Jaccards');