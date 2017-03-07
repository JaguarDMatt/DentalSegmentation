clear all;
cc='C:\Users\User\Downloads\Bench\Challenge2\PROYECTO';
cd(cc);

%Cargar imagenes de entrenamiento

dir1=dir(fullfile(cc,'TrainingData'));
dir2=dir(fullfile(cc,'Training'));
names = extractfield(dir1,'name');
names=names(3:end-1);
names2=extractfield(dir2,'name');
names2=names2(3:end);

%Celda que contendra imagenes
imagenes=cell(size(names));
%Celda que contendra anotaciones
anotaciones=cell(7,size(names2,2));

for i=1:numel(names)
    imagenes{i}=imread(fullfile(cc,'TrainingData',names{i}));
    for j=1:7
        anot1=strcat(names2{i},'_',int2str(j),'.bmp');
        anotaciones{j,i}=imread(fullfile(cc,'Training',names2{i},anot1));
    end
end

%Conversion y Combinacion de anotaciones

dientes=cell(size(names));
for i=1:numel(names)
    actual=anotaciones{1,i};
    if(numel(size(actual))==3)
        actual=rgb2gray(actual);
    end
    actual=im2bw(actual,graythresh(actual));
    anotaciones{1,i}=actual;
    for j=2:7
        a=anotaciones{j,i};
        if(numel(size(a))==3)
            a=rgb2gray(a);
        end
        a=im2bw(a,graythresh(a));
        anotaciones{j,i}=a;
        actual=or(actual,a);
    end
    dientes{i}=imfill(actual,'holes');
end

%Cargar imagenes de prueba

dir3=dir(fullfile(cc,'Test1Data'));
dir4=dir(fullfile(cc,'Test1'));

names3 = extractfield(dir3,'name');
names3=names3(3:end-1);

imagenes2=cell(size(names3));
anotaciones2=cell(7,size(names3,2));
for i=1:numel(names3)
    imagenes2{i}=imread(fullfile(cc,'Test1Data',names3{i}));
    nm=names3{i};
    for j=1:7
        anot1=strcat(nm(1:2),'_',int2str(j),'.bmp');
        anotaciones2{j,i}=imread(fullfile(cc,'Test1',anot1));
    end
end

%Conversion y Combinacion de anotaciones

dientes2=cell(size(names3));

for i=1:numel(names3)
    actual=anotaciones2{1,i};
    actual=rgb2gray(actual);
    actual=not(im2bw(actual,graythresh(actual)));
    anotaciones2{1,i}=actual;
    for j=2:7
        a=anotaciones2{j,i};
        a=rgb2gray(a);
        a=not(im2bw(a,graythresh(a)));
        anotaciones2{j,i}=a;
        actual=or(actual,a);
    end
    dientes2{i}=imfill(actual,'holes');
end

%%

%Entrenamiento

%Se almacena las divisiones de histogramas
histog=cell(size(imagenes));

%Se almacena la informacion de distancia
Data=cell(size(imagenes));

%Se almacena la informacion de intensidad
Data2=cell(size(imagenes));

%Grupos de Data y Data2
Group=cell(size(imagenes));

for i=1:numel(dientes)
    %Preprosesamiento
    Img=prepro(imagenes{i});
    %Anotacion Diente
    Diente=dientes{i};
    %Anotacion Dentina
    Dentina=anotaciones{3,i};
    %Anotacion Diente sin Dentina
    Resto=xor(Diente,Dentina);
    
    %Valores intensidad Diente
    dien=Img(Diente);
    %Valores de intensidad Fondo
    back=Img(not(Diente));
    %Histograma Diente
    hdien=imhist(dien);
    %Histograma Fondo
    hback=imhist(back);
    
    
    %Histograma de division
    hdiv=zeros(256,1);
    for j=1:numel(hdiv)
        if(hback(j)==0)
            hdiv(j)=hdien(j);
        else
            hdiv(j)=hdien(j)/hback(j);
        end
    end
    
    %Matriz distancias de los dientes
    disto=bwdist(not(Diente),'euclidean');
    
    %Distancias Dentina
    dent=disto(Dentina);
    
    %Distancias Resto
    rest=disto(Resto);
    
    %Percentiles del 40 a 60 de Distancias Dentina
    d=prctile(double(dent),40:60);
    %Percentiles del 40 a 60 de Distancias resto
    r=prctile(double(rest),40:60);
    
    %Valores intensidad Dentina
    data3=Img(Dentina);
    %Valores intensidad Resto
    data4=Img(Resto);
    %Percentiles del 40 a 60 de Intenciones Dentina
    ld=prctile(double(data3),40:60);
    %Percentiles del 40 a 60 de Intenciones Resto
    lr=prctile(double(rest),40:60);
    
    %Informacion clasificacion por distancia
    Data{i}=cat(2,d,r);
    %Informacion clasificacion por intensidad
    Data2{i}=cat(2,ld,lr);
    %Grupos de clasificacion
    Group{i}=cat(2,ones(size(d)),zeros(size(r)));
    %Se almacena histograma de division
    histog{i}=hdiv;
end

%Se guardan dos vectores de informacion de clasificacion
Da=cell2mat(Data);
Da2=double(cell2mat(Data2));
%Vector de grupos
Gr=cell2mat(Group);

%Combinacion de clasificadores
Dad=cat(1,Da,Da2);

%Entrenamiento SVM para clasificacion Dentina en Diente
SVM=svmtrain(Dad,Gr);

%Histograma de division promedio
histo=cell2mat(histog);
histo=histo.';
histof=mean(histo);

%%

%Vector de Indice de Jaccard
JD=zeros(size(names3));
%Almacenamiento anotaciones de dientes
anotp=cell(size(names3));

for i=1:numel(names3)
    %Se carga la imagen de prueba y se preprocesa
    Imagen2=prepro(imagenes2{i});
    %Se carga la anotacion de diente para comparar
    anot1=dientes2{i};
    
    %Se crea la imagen de anotacion propia 
    anoti=zeros(size(Imagen2));
    
    for k=1:size(Imagen2,1)
        for j=1:size(Imagen2,2)
            n=Imagen2(k,j)+1;
            anoti(k,j)=histof(n);
        end
    end
    
    %Umbralizacion de la imagen generada
    anoti=im2bw(anoti,graythresh(anoti));
    
    %Se almacena la anotacion propia
    anotp{i}=anoti;
    
    %Se calcula el indice de Jaccard
    JD(i) = sum(anot1 & anoti)/sum(anoti| anot1);
end

%%

%Tamaño para realizar el resize
siz=size(dientes2{4});

%Indice de Jaccard para Dentina con anotaciones dadas
JD2=double(size(dientes2));

for i=1:numel(dientes2)
    %Se carga la anotacion de dientes
    Dien=dientes2{i};
    %Se cambia el tamaño
    Dien=imresize(Dien,siz);
    
    %Se carga la imagen de prueba y preprocesa
    Ima=prepro(imagenes2{i});
     %Se cambia el tamaño
    Ima=imresize(Ima,siz);
    
   %Se carga la anotacion de dentina
    don=anotaciones2{3,i};
     %Se cambia el tamaño
    don=imresize(don,siz);
    
    %Se calcula la matriz de distancias con la anotacion
    dist2=bwdist(not(Dien),'euclidean');
    %Distancias en los dientes
    dente=dist2(Dien);
    %Intensidad en los dientes
    inti=Ima(Dien);
    %Se crea el vector a clasificar
    clas=cat(1,dente.',double(inti).');
    
    %Se clasifican los pixeles del diente
    group=svmclassify(SVM,double(clas.'));
    %Se crea la imagen de anotacion de dentina
    im=zeros(size(Dien));
    %se almacena la clasificacion
    im(Dien)=group;
    %Se convierte a logical para comparacion
    im=logical(im);
    %Se calcula el indice de Jaccard
    JD2(i)= sum(im & don)/sum(im|don);
end

%%

%Indice de Jaccard para Dentina con anotaciones propias
JD3=double(size(dientes2));

for i=1:numel(dientes2)
     
    %Se carga la anotacion de dientes
    Dien=anotp{i};
    %Se cambia el tamaño
    Dien=imresize(Dien,siz);
     
    %Se carga la imagen de prueba y preprocesa
    Ima=prepro(imagenes2{i});
    %Se cambia el tamaño
    Ima=imresize(Ima,siz);

       %Se carga la anotacion de dentina
    don=anotaciones2{3,i};
     %Se cambia el tamaño
    don=imresize(don,siz);
    
    %Se calcula la matriz de distancias con la anotacion
    dist2=bwdist(not(Dien),'euclidean');
    %Distancias en los dientes
    dente=dist2(Dien);
    %Intensidad en los dientes
    inti=Ima(Dien);
    %Se crea el vector a clasificar
    clas=cat(1,dente.',double(inti).');
    
    %Se clasifican los pixeles del diente
    group=svmclassify(SVM,double(clas.'));
    %Se crea la imagen de anotacion de dentina
    im=zeros(size(Dien));
    %se almacena la clasificacion
    im(Dien)=group;
    %Se convierte a logical para comparacion
    im=logical(im);
    %Se calcula el indice de Jaccard
    JD3(i)= sum(im & don)/sum(im|don);
end