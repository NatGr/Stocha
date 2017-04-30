% set a value at fatModel.A(1,1) (and use mk_stochastic) to allow longer 'silent' state
function [fatModel] = createFatModel(models)
% model.pi 		initial state 		(numberStates)
% model.A 		transition matrix 	(numberStates x numberStates)
% model.mu 		means of gaussian 	(numberCep x numberStates x numberGaussPerState)
% model.sigma 	covariance matrix 	(numberCep x numberCep x numberStates x numberGaussPerState)
% model.B 		emission matrix 	(numberStates x numberGaussPerState)
%
% idem for fat model with one more
% model.index 	index of little model for state		(numberStates)
% model.stateOfLittle 	first state for little model (length(models))
%
% all models must have the same numberCep

numberStates = 1 + sum(arrayfun(@(m) size(m.pi, 1) - 2, models)); 	% initial state = final state, which is shared
numberCep = size(models(1).mu, 1);
numberGaussPerState = 2 * sum(arrayfun(@(m) size(m.mu, 3), models)); 	% initial state can produce any of the gaussian of the initial or final states of each little models // may be it could be better

fatModel.pi = zeros(numberStates,1);
fatModel.pi(1) = 1; 	% start at initial state

fatModel.A 		= zeros(numberStates, numberStates);
fatModel.mu 	= zeros(numberCep, numberStates, numberGaussPerState);
fatModel.sigma 	= zeros(numberCep, numberCep, numberStates, numberGaussPerState);
fatModel.B 		= zeros(numberStates, numberGaussPerState);
fatModel.index 	= zeros(numberStates,1);
fatModel.stateOfLittle = zeros(length(models),1);

% variables to localise in the matrices
s = 2; 						% state in the fat model of the first state of the current little model
g = 1 + numberGaussPerState / 2; % index of the gaussian

for m = 1:length(models) 	% index of current model
	model = models(m);
	
	currentNumberStates = size(model.pi,1);
	currentNumberGaussPerState = size(model.mu,3);
	
	% internal transition and emission
	stateRange = (2:(currentNumberStates-1));
	
	nextS = s + currentNumberStates - 2;
	nextG = g + currentNumberGaussPerState;
	
	fatStateRange = s:(nextS - 1);
	fatGaussRange_0 = g:(nextG - 1);
	fatGaussRange_1 = (g:(nextG - 1)) + numberGaussPerState / 2;
	
	fatModel.A(fatStateRange,fatStateRange) 			= model.A(stateRange,stateRange);
	fatModel.mu(:,fatStateRange,fatGaussRange_1) 		= model.mu(:,stateRange,:);
	fatModel.sigma(:,:,fatStateRange,fatGaussRange_1) 	= model.sigma(:,:,stateRange,:);
	fatModel.B(fatStateRange,fatGaussRange_1) 			= model.B(stateRange,:);
	
	fatModel.index(fatStateRange) 					= m;
	fatModel.stateOfLittle(m) 						= s;
	
	% initial transition (from/to) and emission
%	fatModel.A(1,fatStateRange) 	= model.A(1,stateRange) / 10;
	fatModel.A(1,s) 				= 1/10;
	fatModel.A(fatStateRange,1) 	= model.A(stateRange,end);
	
	fatModel.B(1,fatGaussRange_0) 	= model.B(1,:);
	
	fatModel.mu(:,1,fatGaussRange_0) 	= model.mu(:,1,:);

	fatModel.sigma(:,:,1,fatGaussRange_0) 	= model.sigma(:,:,1,:);
	
	% update s and g
	s = nextS;
	g = nextG;
end

end