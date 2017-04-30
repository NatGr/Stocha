% function finding the most likely sequence
function sequence = findSequence(sound, fatModel)

coef = getCoef(sound, size(fatModel.mu, 1));
path = mhmm_viterbi(coef, fatModel);

digit_long = fatModel.index(path) - 1;
tmp = digit_long==-1;
digit = digit_long([false;tmp(1:end-1)]);
sequence = digit(digit~=-1);

end
