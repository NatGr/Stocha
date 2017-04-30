% function exporting the mel coefficients out of a given sound
function obs = getCoef(sound, numberCep)
fs = 44100;
band = [10, 5000]/(fs/2);
[B, A] = butter(2,band);
sound = sound(:,1); % in case of stereo sound
sound = filter(B, A, sound(sound ~= 0));
obs = melfcc(sound,fs,'numcep', numberCep);

obs = standardize(obs);
end
