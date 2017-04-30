% script for question 1.2.6
clear all;

precisionEst = zeros(6,4,4);
precisionModels = zeros(6,4,4);
NbreSeq = [30 100 200 500];
for nbreLoops=1:4
    for i=1:6
        for j=1:4
             tmp = Q1_2_6_fct(NbreSeq(j), i);
             precisionEst(i,j,nbreLoops) = tmp(1);
             precisionModels(i,j,nbreLoops) = tmp(2);
        end
    end
end
precisionEst = mean(precisionEst,3);
precisionModels = mean(precisionModels,3);
plot(1:6, precisionEst)
title('Précision des modèles estimés')
xlabel('état')
ylabel('probabilité')
legend('30 séq.','100 séq.','200 séq.','500 séq.','Location','northwest')
figure();
plot(1:6, precisionModels) % devrait être indépendant du nombre d'états
title('Précision des modèles de base')
xlabel('état')
ylabel('probabilité')
legend('30 séq.','100 séq.','200 séq.','500 séq.','Location','northwest')