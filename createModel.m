% function building a model for a given digit
function [model, LL] = createModel(sounds, numberStates, numberGaussPerState, numberCep)

trainingData = cell(1,numel(sounds));
for i = 1:numel(sounds)
    trainingData{i} = getCoef(sounds{i}, numberCep);
end

transmat0 = mk_stochastic(initMat(numberStates, numberStates,@(i,j) (i==j) + (i==j-1) * 0.05) .* rand(numberStates,numberStates));

prior0 = zeros(numberStates,1);
prior0(1) = 1;

[mu0, Sigma0] = mixgauss_init((numberStates-1)*numberGaussPerState, cell2mat(trainingData), 'diag');
mu0 = reshape(mu0, [numberCep (numberStates-1) numberGaussPerState]);
Sigma0 = reshape(Sigma0, [numberCep numberCep (numberStates-1) numberGaussPerState]);

mixmat0 = mk_stochastic(rand(numberStates,numberGaussPerState));

% impose that first and last state have same mixture of gaussians
mu0(:,numberStates,:) = mu0(:,1,:);
Sigma0(:,:,numberStates,:) = Sigma0(:,:,1,:);
mixmat0(numberStates,:) = mixmat0(1,:);

posterior0 = normalise(initMat(numberStates, 1,@(i,j) i==numberStates));

[LL, model.pi, model.posterior, model.A, model.mu, model.sigma, model.B] = mhmm_em2(trainingData, prior0, posterior0, transmat0, mu0, Sigma0, mixmat0, 'verbose', 0, 'max_iter', 25, 'final_initial_shared', 1, 'adj_posterior', 0);

end
