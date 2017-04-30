% scripts that compares the effect of a variation of the number of states
% and the number of gaussians per states

rng('shuffle'); %thx matlab


scores = zeros(4,5);
valuesStates = [4 6 8 10];
valuesGauss = [2 4 6 8 10];
for i = 1:4 % nbre States
    for j = 1:5 % nbre Gauss/States
        models = arrayfun( @(digit) createModel(soundsForDigit(digit),valuesStates(i),valuesGauss(j),17), 0:9);
        tmp = sum(computeScore('Data/celine/', models),1);
        scores(i,j) = tmp(3) / tmp(4);
    end
end

% numcep comparison
% scores = zeros(5,1);
% values = [10 13 15 17 19]; % tested values
% for i = 1:5 % nbre Gauss/States
%     models = arrayfun( @(digit) createModel(soundsForDigit(digit),8,6,values(i)), 0:9);
%     tmp = sum(computeScore('Data/celine/', models),1);
%     scores(i) = tmp(3) / tmp(4);
% end

% init comparison
% for i=1:1
%     models = arrayfun( @(digit) createModel(soundsForDigit(digit),6,4,17), 0:9);
%     tmp = sum(computeScore('Data/celine/', models),1);
%     scores(1,i) = tmp(3) / tmp(4);
%      
%     models = arrayfun( @(digit) createModel(soundsForDigit(digit),8,4,17), 0:9);
%     tmp = sum(computeScore('Data/celine/', models),1);
%     scores(2,i) = tmp(3) / tmp(4);
%         
%     models = arrayfun( @(digit) createModel(soundsForDigit(digit),8,6,17), 0:9);
%     tmp = sum(computeScore('Data/celine/', models),1);
%     scores(3,i) = tmp(3) / tmp(4);
%         
%     models = arrayfun( @(digit) createModel(soundsForDigit(digit),8,8,17), 0:9);
%     tmp = sum(computeScore('Data/celine/', models),1);
%     scores(4,i) = tmp(3) / tmp(4);     
% end