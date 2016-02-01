function[WavApprox, WholeWav]=WaveletApproximation(DataVector, WaveletName)
    % Takes vectorized accelerometer data,
    % Performs continuous wavelet transformation based on WaveletName
    % Takes the mean of such transformed signal on the scales of interest (10-50)

    
    stepSIG = 1/100;
    stepWAV = 1/100;
    long=100;
    scales = (1:2*long)*stepSIG; % erm...not sure. check this please. 
    WAV={WaveletName stepWAV};
    WavApprox={};
    WholeWav={};
    NoFiles=length(DataVector);
    
    for i=1:NoFiles
        SIG = {DataVector{i},stepSIG};
        WholeWav{i}=cwt(SIG,scales,WAV); 
        WavApprox{i}=mean(WholeWav{i}(10:50,:));
    end
end
