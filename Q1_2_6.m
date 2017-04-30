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
title('Pr�cision des mod�les estim�s')
xlabel('�tat')
ylabel('probabilit�')
legend('30 s�q.','100 s�q.','200 s�q.','500 s�q.','Location','northwest')
figure();
plot(1:6, precisionModels) % devrait �tre ind�pendant du nombre d'�tats
title('Pr�cision des mod�les de base')
xlabel('�tat')
ylabel('probabilit�')
legend('30 s�q.','100 s�q.','200 s�q.','500 s�q.','Location','northwest')