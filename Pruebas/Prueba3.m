% Deteccion dientes con Proporcion de Histogramas

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );

%%

histo=cell(numel(imtrain),1);

for i=1:numel(imtrain)
I1=imread(imtrain{i});
I=prepro(I1);
[ Mat,lab ] = TeethAnnot( anottest(:,i),size(I));
h=imhist(I(Mat));
h(1)=0;
histo{i}=h'/sum(h);

end

%%
histof=cell2mat(histo);
histof=mean(histof);

%%

c=2;
jaccard=zeros(size(imtest));

for i=1:numel(imtest)
I1=imread(imtest{i});
I=prepro(I1,szo);
[ Mat,lab ] = TeethAnnot( anottest(:,i),szo);
[L,C,U,LUT,H]=FastFCMeans(I,c);
a=Mat;
b=L==2;
inter_image = a & b;
union_image = a | b;
jaccard(i)= sum(inter_image(:))/sum(union_image(:));
end
