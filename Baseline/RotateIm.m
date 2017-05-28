%{
Metodo para rotacion de imagen
@INPUT:
1. im: Ruta de imagen o imagen a color o en grises
@OUTPUT:
1. rotatedIm: Imagen de entrada rotada

El algoritmo emplea la division de umbrales de Otsu, en la cual busca el
umbral que minimice la varianza de un histograma. En este caso el
histograma sera la suma horizontal de la imagen en grises, ya que en
esta posicion queremos la imagen. Para buscar el angulo que maximice el
umbral de Otsu se itera sobre un rango de angulos y se escoge aquel con
mayor metrica de efectividad.
%}
function [rotatedIm,levelMax] = RotateIm(im)
% Si la entrada es la ruta de la imagen, leerla
if ischar(im)
    nameIm = strsplit(im,'/');
    nameIm = nameIm{end};
    im = imread(im);
end
% Si la imagen es a color, pasarla a grises
if size(im,3) == 3
    gray = rgb2gray(im);
    % Algunas imagenes tienen blanco entre la radiografia y el fondo
    % entonces lo pasamos todo a cero pa que no moleste
    gray(gray == 255) = 0;
else
    gray = im;
end
% bw = im2bw(gray,graythresh(gray));
% Parametros de recorrido
error = 10; % Diferencia entre angulos
deg0 = -30; % Angulo inicial
deg1 = 30; % Angulo final
ndeg = 5; % Cantidad de angulos a probar
% Recorrido evaluando varios angulos hasta encontrar el ideal
while deg1 - deg0 > error
    degs = linspace(deg0, deg1, ndeg);
    ems = zeros(1, ndeg);
    levels = zeros(1, ndeg);
    for i = 1:ndeg
%         bw2 = imrotate(bw, degs(i), 'nearest', 'crop');
%         counts = sum(bw2,2);
%         ems(i) = calculateEM(counts);
        gray2 = imrotate(gray, degs(i), 'nearest', 'crop');
        counts = sum(gray2,2);
        nz = sum(gray2 ~= 0,2);
        counts2 = counts ./ nz;
        [ems(i),levels(i)] = calculateEM(counts2);
    end
    [~,posMax] = max(ems);
    deg0 = degs(max(1, posMax - 1));
    deg1 = degs(min(ndeg, posMax + 1));
end
rotatedIm = imrotate(im, degs(posMax), 'nearest', 'crop');
levelMax = levels(posMax);
fprintf('Angulo de rotacion = %f\n',degs(posMax));
fprintf('Umbral de corte encontrado = %f\n',levels(posMax));
fprintf('Metrica de efectividad = %f\n',ems(posMax));
% figure
% counts = sum(imrotate(bw, degs(posMax), 'nearest', 'crop'), 2);
% bar(counts);
% counts = sum(imrotate(gray, degs(posMax), 'nearest', 'crop'), 2);
% nz = sum(imrotate(gray, degs(posMax), 'nearest', 'crop') ~= 0, 2);
% counts2 = counts ./ nz;
% bar(counts2);
% title(degs(posMax));
% figure
% imshow(rotatedIm)
% if exist('nameIm','var'), title(gca,nameIm); end
end

% Algoritmo obtenido de: graythresh.m
function [em,level] = calculateEM(counts)
num_bins = length(counts);
p = counts / sum(counts);
omega = cumsum(p);
mu = cumsum(p .* (1:num_bins)');
mu_t = mu(end);
sigma_b_squared = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega));
maxval = max(sigma_b_squared);
% compute threshold
idx = mean(find(sigma_b_squared == maxval));
level = (idx - 1) / (num_bins - 1);
% compute the effectiveness metric
em = maxval/(sum(p.*((1:num_bins).^2)') - mu_t^2);
end