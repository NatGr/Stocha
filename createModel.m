% function building a model for a given digit
function model = createModel(sounds, numberStates, numberGaussPerState, numberCep)

trainingData = cell(1,numel(sounds));
for i = 1:numel(sounds)
    trainingData{i} = getCoef(sounds{i}, numberCep);
end

prior0 = normalise(rand(numberStates,1));
transmat0 = mk_stochastic(triu(rand(numberStates,numberStates)));

[mu0, Sigma0] = mixgauss_init(numberStates*numberGaussPerState, cell2mat(trainingData), 'diag');
mu0 = reshape(mu0, [numberCep numberStates numberGaussPerState]);
Sigma0 = reshape(Sigma0, [numberCep numberCep numberStates numberGaussPerState]);
mixmat0 = mk_stochastic(rand(numberStates,numberGaussPerState));

[LL, model.pi, model.A, model.mu, model.sigma, model.B] = mhmm_em(trainingData, prior0, transmat0, mu0, Sigma0, mixmat0, 'verbose', 0);


end
