% function building a model for a given digit
function [model, LL] = createModel(sounds, numberStates, numberGaussPerState, numberCep)

trainingData = cell(1,numel(sounds));
for i = 1:numel(sounds)
    trainingData{i} = getCoef(sounds{i}, numberCep);
end

onlyNextState = false;
startByFirst = false;
final_ensured = false;
final_initial_shared = false;

if onlyNextState
	transmat0 = mk_stochastic(initMat(numberStates, numberStates,@(i,j) (i==j) + (i==j-1) * 0.05) .* rand(numberStates,numberStates));
else
	transmat0 = mk_stochastic(triu(rand(numberStates,numberStates)));
end

if startByFirst
	prior0 = zeros(numberStates,1);
	prior0(1) = 1;
else
	prior0 = normalise(rand(numberStates,1));
end

[mu0, Sigma0] = mixgauss_init(numberStates*numberGaussPerState, cell2mat(trainingData), 'diag');
mu0 = reshape(mu0, [numberCep numberStates numberGaussPerState]);
Sigma0 = reshape(Sigma0, [numberCep numberCep numberStates numberGaussPerState]);
mixmat0 = mk_stochastic(rand(numberStates,numberGaussPerState));

if final_ensured
	posterior0 = normalise(initMat(numberStates, 1,@(i,j) i==numberStates));
else
	posterior0 = ones(numberStates, 1);
end

[LL, model.pi, model.A, model.mu, model.sigma, model.B] = mhmm_em2(trainingData, prior0, posterior0, transmat0, mu0, Sigma0, mixmat0, 'verbose', 0, 'max_iter', 25, 'final_initial_shared', final_initial_shared);

end
