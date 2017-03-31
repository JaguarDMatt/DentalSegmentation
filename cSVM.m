%SVM

[ imtest,imtrain1,imtrain2,anottest, anottrain1,anottrain2,ttest,ttrain1,ttrain2] = ChargeImages( );

%%

%7 classes 

classes=cell(8,1);
for cl=1:size(anottest,1)
    class.int=[];
    class.mag=[];
    class.dir=[];
    for i=1:numel(imtest)
        anot=anottest{cl,i};
        if(sum(anot(:))==0)
            continue;
        else
            im=imtest{i};
            [Gmag,Gdir] = imgradient(im);
            class.int=cat(1,class.int,im(anot));
            class.mag=cat(1,class.mag,Gmag(anot));
            class.dir=cat(1,class.dir,Gdir(anot));
        end
    end
    classes{cl}=class;
end


%%

%Background
class.int=[];
class.mag=[];
class.dir=[];
for i=1:numel(imtest)
    anot=not(ttest{i});
    im=imtest{i};
    [Gmag,Gdir] = imgradient(im);
    class.int=cat(1,class.int,im(anot));
    class.mag=cat(1,class.mag,Gmag(anot));
    class.dir=cat(1,class.dir,Gdir(anot));
end
classes{8}=class;

save('info.mat','classes');

%%

prob=cell(8,1);
for cl=1:size(anottrain1,1)
prob{cl}=anottrain1{cl,1};
for i=2:numel(imtrain1)
    prob{cl}=imadd(prob{cl},anottrain1{cl,i});
end
prob{cl}=prob{cl}/(max(prob{cl}(:)));
end
