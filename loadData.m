% fonction important un �chantillon de voix et extrayant des caract�ristiques
function obs = loadData(path, numberCep)
[sound,fs]= audioread(path);
band = [700, 1400]/(fs/2);
[B, A] = butter(2,band);
sound = filter(B, A, sound);
obs = melfcc(sound(:,1),fs,'numcep', numberCep);
end