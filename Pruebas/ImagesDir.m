function [imtrain,anottrain,imtest,anottest,imval,anotval] = ImagesDir( )

%Charge the images dirnames
addpath(genpath('GroundTruthData'));
addpath(genpath('RawImage'));

dirimages=dir('RawImage');
dirimages=extractfield(dirimages,'name');
dirimages=dirimages(3:end);

diranot=dir('GroundTruthData');
diranot=extractfield(diranot,'name');
diranot=diranot(3:end);

%Celulas donde se guardan imagenes y anotaciones

imtest=cell(1,40);
imval=cell(1,40);
imtrain=cell(1,40);

anottest=cell(7,40);
anotval=cell(7,40);
anottrain=cell(7,40);

for i=1:numel(dirimages)
    diri=dir(fullfile('RawImage',dirimages{i}));
    names=extractfield(diri,'name');
    names=names(3:end);
    for j=1:numel(names)
        im=fullfile('RawImage',dirimages{i},names{j});
        if(strcmp(dirimages{i},'Test1Data')==1)
            imtest{j}=im;
        elseif(strcmp(dirimages{i},'Test2Data')==1)
            imval{j}=im;
        else
            imtrain{j}=im;
        end
        name=names{j};
        name=name(1:end-4);
        
        for k=1:7
            namea=strcat(name,'_',num2str(k),'.bmp');
            if(strcmp(diranot{i},'Training')==1)
                anot=fullfile('GroundTruthData',diranot{i},name,namea);
            else
                anot=fullfile('GroundTruthData',diranot{i},namea);
            end
            
            if(strcmp(dirimages{i},'Test1Data')==1)
                anottest{k,j}=anot;
            elseif(strcmp(dirimages{i},'Test2Data')==1)
                anotval{k,j}=anot;
            else
                anottrain{k,j}=anot;
            end
        end
    end
end

end