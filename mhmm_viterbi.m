% function exporting the mel coefficients out of a given sound
function path = mhmm_viterbi(data, model)
% data 		observation				(numberCep x T)
% model.pi 	initial state 			(numberStates)
% model.A 	transition matrix 		(numberStates x numberStates)
% model.mu 	means of gaussian 		(numberCep x numberStates x numberGaussPerState)
% model.sigma 	covariance matrix 	(numberCep x numberCep x numberStates x numberGaussPerState)
% model.B 	emission matrix 		(numberStates x numberGaussPerState)

% algorithm inspired by http://www.montefiore.ulg.ac.be/~lwh/ProcStoch/tutorial-on-hmm.pdf

numberStates = length(model.pi);
numberCep = size(model.mu, 1);
numberGaussPerState = size(model.B, 2);

T = size(data, 2);

delta = -inf * ones(numberStates, T); 	% delta(i,t): log of the likelihood of the best path ending at state i at time t
psi = zeros(numberStates, T); 		% psi(i,t): state at time t-1 of the best path ending at state i at time t

% delta(:,1) = model.pi .* proba(data(:,1));
for i = 1:numberStates
	if model.pi(i) ~= 0 	% shortcut for 0
		acc = 0; 		% probability of the obs to occurs in the state i
		for k = 1:numberGaussPerState
			if model.B(i,k) ~= 0 	% shortcut for 0
				acc = acc + model.B(i,k) * gaussian_prob(data(:,1), model.mu(:,i,k), model.sigma(:,:,i,k));
			end
		end
		delta(i,1) = log(model.pi(i)) + log(acc);
	end
end

psi(:,1) = 0;

for t = 2:T
	for j = 1:numberStates
		currentMaxIndex = 0;
		currentMaxValue = -inf;
		
		for i = 1:numberStates
			value = delta(i, t-1) + log(model.A(i,j));
			if value > currentMaxValue;
				currentMaxValue = value;
				currentMaxIndex = i;
			end
		end
		
		if currentMaxValue ~= 0 	% shortcut for 0
			acc = 0; 		% probability of the obs to occurs in the state j
			for k = 1:numberGaussPerState
				if model.B(j,k) ~= 0 	% shortcut for 0
					acc = acc + model.B(j,k) * gaussian_prob(data(:,t), model.mu(:,j,k), model.sigma(:,:,j,k));
				end
			end
			delta(j,t) = currentMaxValue + log(acc);
		end
		
		psi(j,t) = currentMaxIndex;
	end
end

path = zeros(1,T);
[~, path(T)] = max(delta(:,T));

for x = 1:(T-1)
	path(T-x) = psi(path(T-x+1), T-x+1);
end

end
