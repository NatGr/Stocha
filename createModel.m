% function building a model for a given digit
function [model, LL] = createModel(sounds, numberStates, numberGaussPerState, numberCep, final_ensured, final_initial_shared)

trainingData = cell(1,numel(sounds));
for i = 1:numel(sounds)
    trainingData{i} = getCoef(sounds{i}, numberCep);
end

%prior0 = normalise(rand(numberStates,1));
prior0 = normalise(initMat(numberStates, 1,@(i,j) i==1));
% transmat0 = mk_stochastic(triu(rand(numberStates,numberStates)));
% transmat0 = mk_stochastic(initMat(numberStates, numberStates,@(i,j) (i~=1 || j <= 2) * (i<=j) * (0.05 ^ abs(i-j))) .* rand(numberStates,numberStates));

transmat0 = mk_stochastic(initMat(numberStates, numberStates,@(i,j) (i==j) + (i==j-1) * 0.05) .* rand(numberStates,numberStates));

[mu0, Sigma0] = mixgauss_init(numberStates*numberGaussPerState, cell2mat(trainingData), 'diag', 'kmeans');
mu0 = reshape(mu0, [numberCep numberStates numberGaussPerState]);
Sigma0 = reshape(Sigma0, [numberCep numberCep numberStates numberGaussPerState]);
mixmat0 = mk_stochastic(rand(numberStates,numberGaussPerState));
%mixmat0 = mk_stochastic(ones(numberStates,numberGaussPerState)); % RANDOM AGAIN

if final_ensured
	posterior0 = normalise(initMat(numberStates, 1,@(i,j) i==numberStates));
else
	posterior0 = ones(numberStates, 1);
end

[LL, model.pi, model.A, model.mu, model.sigma, model.B] = mhmm_em2(trainingData, prior0, posterior0, transmat0, mu0, Sigma0, mixmat0, 'verbose', 0, 'max_iter', 25, 'final_initial_shared', final_initial_shared);


end
