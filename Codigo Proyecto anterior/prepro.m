function [ im ] = prepro( Imagen )
% Preprocesamiento de la Imagen
%Estos son los pasos:
%1)Remover los numeros a color en las imagenes
%2)Convertir la imagen a escala de girs
%2)Filtrar con un filtro mediano para reducir el ruido

%Diferencias entre los canales de la imagen
numb1=imabsdiff(Imagen(:,:,2),Imagen(:,:,3));
numb2=imabsdiff(Imagen(:,:,2),Imagen(:,:,1));
numb3=imabsdiff(Imagen(:,:,3),Imagen(:,:,1));

%Se suman las diferencias
numb=numb1+numb2+numb3;
%Se umbraliza
n=im2bw(numb,graythresh(numb));

%Se convierte la imagen a escala de gris
Imagen=rgb2gray(Imagen);
%Se remueve las diferencias de los canales
Imagen=immultiply(Imagen,uint8(not(n)));
%Se filtra la imagen
im=medfilt2(Imagen,[5 5]);
end

