%{
Codigo de evaluacion de metodos
El codigo sirve es por imagen, en ella se mete el .mat o la imagen de
labels en el primer parametro y en el segundo se mete la imagen de
groundtruth labels
Luego de usarlos se concatenan todos en la primera dimension
%}
function [Jacc,PR,F1]=Scores(Lab,GT)

CantAnot=7;
if nargin<1
    load('joseclas.mat');
    Lab=lgray;
    GT=lab;
end

if ischar(Lab)
    load(Lab);
end

% Pasar a matriz binaria de 3D
Preds=false(size(Lab,1),size(Lab,2),CantAnot);
GroundT=false(size(GT,1),size(GT,2),CantAnot);
for i=1:CantAnot
    Preds(:,:,i)=Lab==i;
    GroundT(:,:,i)=GT==i;
end

% Calcular indice de Jaccard
Jacc=zeros(1,CantAnot);
for i=1:CantAnot
    if nnz(GroundT(:,:,i))==0
        Jacc(i)=NaN;
    else
        Jacc(i)=nnz(and(Preds(:,:,i),GroundT(:,:,i)))/...
            nnz(or(Preds(:,:,i),GroundT(:,:,i)));
    end
end

% Calcular PR a distintas escalas
SE=strel('diamond',1);
iter=150;
PR=cell(CantAnot,1);
GroundT1=GroundT;
Preds2=Preds;
for i=1:CantAnot
    if isnan(Jacc(i)), continue; end
    for j=1:iter
        MatPR=zeros(2);
        Intersec1=nnz(and(Preds(:,:,i),GroundT1(:,:,i)));
        Intersec2=nnz(and(Preds2(:,:,i),GroundT(:,:,i)));
        MatPR(1,1)=Intersec1/nnz(Preds(:,:,i));
        MatPR(1,2)=Intersec1/nnz(GroundT1(:,:,i));
        MatPR(2,1)=Intersec2/nnz(Preds2(:,:,i));
        MatPR(2,2)=Intersec2/nnz(GroundT(:,:,i));
        PR{i}=cat(1,PR{i},MatPR);
        GroundT1(:,:,i)=imdilate(GroundT1(:,:,i),SE);
        Preds2(:,:,i)=imdilate(Preds2(:,:,i),SE);
    end
end

% Calcular F-medida
F1=zeros(1,CantAnot);
for i=1:CantAnot
    if isempty(PR{i})
        F1(i)=NaN;
    else
        F=2*((PR{i}(:,1).*PR{i}(:,2))./(PR{i}(:,1)+PR{i}(:,2)));
        F1(i)=max(F);
    end
end

% Muestra en ventana de comando
disp('Los indices de Jaccard son:')
disp(Jacc')
disp('Las F-medidas son:')
disp(F1')
end