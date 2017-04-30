% Predict the digits associated to each cell element of speech.
%
% Parameters
% ----------
% speechs : cell array of arrays of float/double
%       Each element of speechs contains the audio signal associated to a digit
%       as obtained by the audioread function.
%
% Returns
% -------
% output : array of int
%       The predicted digits associated to an element of speechs.
function [output] = predict(speechs)
models = arrayfun( @(digit) createModel(soundsForDigit(digit),8,6,17), 0:9);
output = arrayfun( @(e) findBestModel(e, models), speechs, 'UniformOutput', false) - 1;
% the -1 corrects the fact that indexes begin at 1 and the data begin at 0
end