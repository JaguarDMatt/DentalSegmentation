% Random forest 
y=load('info.mat');
Caracteristicas=y.data;
Labels=y.lbls;
 ModeloEntrenado = TreeBagger(50,Caracteristicas,Labels,'OOBPrediction','On',...
   'Method','classification'); 
save('ModeloEntrenado.mat', 'ModeloEntrenado','-v7.3');
%view(ModeloEntrenado.Trees{1},'Mode','graph') % Ver si se necesita mas arboles