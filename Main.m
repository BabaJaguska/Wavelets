% Read all the signals
DataVector=ReadSignals;

% Wavelet transform them
[WavApprox, WholeWav]=WaveletApproximation(DataVector,'mexh');

% Find extreme values on each 100 point segment of the wavelet transform approximation
[MinX,MinY,MaxX,MaxY,P2P]=ExtremaPerSegment(WavApprox);

% Plot it all
PlotWaveletStuff(MinX,MinY,MaxX,MaxY,P2P,WavApprox,WholeWav,DataVector);

% Find markers, by observation, which are thresholds for each signal
% that tell where a visible contraction starts
Markeri=[600 1000 1200 900 1600 1300 1100 800 1600 1400 500 1200 1300 1600 1000 2900 300 300 200 600 1000 1400 2300 1300];
% then separate the minima and maxima according to that threshold
% the following function returns the X axis positions of the extreme values
[MinNema,MinIma,MaxNema,MaxIma]=YesOrNoContraction(MinX,MaxX,Markeri); 
% You should probably see what happens with P2P values too

% then plot histograms to see where extreme values most occur
% and whether that differs for when there is and when there is no contraction
HistExtremePositions
