% Deteccion dientes con Proporcion de Histogramas

%Con Filtro

%Con Otsu y pre^2(0.6281)
%Con Otsu y pre de test(0.5351)
%Con Otsu y pre inicial(0.6125)
%Con Otsu y sin pre(0.5197)
%Con Fuzzy y pre^2 c=2(0.6269)
%Con Fuzzy y pre^2 c=3(0.6451)
%Con Fuzzy c=3(0.6537)
%Con Active Contour (0.6274)
clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );

%% Entrenamiento

histopre=cell(numel(imtrain),1);
histo=cell(numel(imtrain),1);

for i=1:numel(imtrain)
I1=imread(imtrain{i});
I=prepro(I1);
I2=preprobasic(I1);
[ Mat,lab ] = TeethAnnot(anottrain(:,i));
h=imhist(I(Mat));
h(1)=0;
histopre{i}=h'/sum(h);

h2=imhist(I2(Mat));
h2(1)=0;
histo{i}=h2'/sum(h2);

end

%% Modelos
histof=cell2mat(histopre);
histof=mean(histof);

histof2=cell2mat(histo);
histof2=mean(histof2);

%% Evaluacion
jaccard=zeros(size(imtest));
jaccard2=zeros(size(imtest));
jaccard3=zeros(size(imtest));
jaccard4=zeros(size(imtest));

for i=1:numel(imtest)
    
I1=imread(imtest{i});
I=prepro(I1);
I2=preprobasic(I1);
[ Mat,lab ] = TeethAnnot( anottest(:,i));

J = histeq(I,histof);
J2 = histeq(I,histof2);
J3 = histeq(I2,histof);
J4 = histeq(I2,histof2);

a=Mat;
b=im2bw(J,graythresh(J));
inter_image = a & b;
union_image = a | b;
jaccard(i)= sum(inter_image(:))/sum(union_image(:));

b=im2bw(J2,graythresh(J2));
inter_image = a & b;
union_image = a | b;
jaccard2(i)= sum(inter_image(:))/sum(union_image(:));

b=im2bw(J3,graythresh(J3));
inter_image = a & b;
union_image = a | b;
jaccard3(i)= sum(inter_image(:))/sum(union_image(:));

b=im2bw(J4,graythresh(J4));
inter_image = a & b;
union_image = a | b;
jaccard4(i)= sum(inter_image(:))/sum(union_image(:));
end

%%

jaccardFC=zeros(size(imtest));
jaccardFC2=zeros(size(imtest));
c=3;
for i=1:numel(imtest)
    
I1=imread(imtest{i});
I=prepro(I1);
[ Mat,lab ] = TeethAnnot( anottest(:,i));

J = histeq(I,histof);
[L,C,U,LUT,H]=FastFCMeans(J,c);
[L2,C2,U2,LUT2,H2]=FastFCMeans(I,c);

a=Mat;
b=L>1;
inter_image = a & b;
union_image = a | b;
jaccardFC(i)= sum(inter_image(:))/sum(union_image(:));

b=L2>1;
inter_image = a & b;
union_image = a | b;
jaccardFC2(i)= sum(inter_image(:))/sum(union_image(:));
end


%% Active


jaccardC=zeros(size(imtest));
for i=1:numel(imtest)
    
I1=imread(imtest{i});
I=prepro(I1);
[ Mat,lab ] = TeethAnnot( anottest(:,i));
szo=size(Mat);
J = histeq(I,histof);
mask=im2bw(J,graythresh(J));
Seg=chenvese(J,mask,1000,0.2,'chan');
Seg1=imresize(Seg,szo);

a=Mat;
b=Seg1;
inter_image = a & b;
union_image = a | b;
jaccardC(i)= sum(inter_image(:))/sum(union_image(:));
end