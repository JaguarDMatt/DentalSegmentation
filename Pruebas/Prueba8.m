%Prueba 8

%Filtros

clc;
clear all;
[imtrain,anottrain,imtest,anottest] = ImagesDir( );
%% Canny

I1=imread(imtrain{1});
I=prepro(I1);
Ig=preprobasic(I1);
[ Mat,lab ] = TeethAnnot( anottrain(:,1));
BW = edge(I,'Canny');


%%

[m,n]=size(I);

if(mod(m,2)==0)
    m=m-1;
    I=I(1:m,:);
    Ig=Ig(1:m,:);
elseif(mod(n,2)==0)
    n=n-1;
    Ig=Ig(:,1:n);
    I=I(:,1:n);
end

%% Filtrado pasa bajas

If=fft2(I);
Y = fftshift(If);
Ifg=fft2(Ig);
Yg = fftshift(Ifg);

%Circulo para filtrado
circulo=ones(m,n);
cx=(m-1)/2;
cy=(n-1)/2;
r=10;
for i=1:m
   for j=1:n
       if((i-cx)^2+(j-cy)^2<=r^2)
          circulo(i,j)=10^-10; 
       end
   end
end
circulo=fftshift(circulo);

%Filtrado
Yfilt=Y.*circulo;
Yfilt=ifftshift(Yfilt);
Yfilt=uint8(real(ifft2(Yfilt)));

%Filtrado
Yfiltg=Yg.*circulo;
Yfiltg=ifftshift(Yfiltg);
Yfiltg=uint8(real(ifft2(Yfiltg)));