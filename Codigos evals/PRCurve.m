%{
En el primer parámetro se mete las celdas de PR resultantes del metodo
Scores.m, estos deben ser concatenados en la primera dimension, en el
segundo parametro se mete un valor booleano que se determina si se
interpolan los valores o no
%}
function PRCurve(PR,Fit)

CantAnot=7;
% Ploteo curva PR
if exist('isoF.fig','file')
    openfig('isoF.fig');
    leg=['BSDS Human PR','F-measure'];
else
    figure;
    ax=axes;
    xlim(ax,[0,1]);
    ylim(ax,[0,1]);
    leg=[];
end
hold on

if ~Fit
    for i=1:CantAnot
        if isempty(PR{i})
            plot(NaN,NaN)
        else
            [Rsort,RsortPos]=sort(squeeze(PR{i}(:,2)));
            plot(Rsort,squeeze(PR{i}(RsortPos,1)),'LineWidth',2)
        end
    end
else
    for i=1:CantAnot
        if isempty(PR{i})
            plot(NaN,NaN)
        else
            PFit=polyfit(PR{i}(:,2),PR{i}(:,1),5);
            X=0:0.01:1;
            Y=polyval(PFit,X);
            plot(X,Y,'LineWidth',2)
        end
    end
end

hold off
title('Precision-Recall Curve')
legend(leg,'Caries','Enamel','Dentin','Pulp'...
    ,'Crown','Restoration','Root Canal Treatment','Location','southwest');
end