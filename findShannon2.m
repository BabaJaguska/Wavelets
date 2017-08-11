function [Shannon]=findShannon2(signal)
% Finds Shannon Wavelet Entropy of a given @signal sampled at @fs, using
% the mother wavelet specified in @wavelet string. 
% Set the @smallestScaleFactor to calculate the smallest scale
% and @deltaScale as the spacing between scales
% These should have been arguments, but I needed a single input function

fs=500;
wavelet='coif2';

smallestScaleFactor=0.01;
deltaScale=0.05;

sig ={signal,1/fs}; % preparation of signal structure for cwt or cwtft functions
dt=1/fs;
s0=smallestScaleFactor*dt; % smallest scale
       
NbSc = fix(log2(length(signal)*dt/s0)/deltaScale); % number of scales
scales_provera=s0*2.^((0:NbSc-1)*deltaScale);

cwtS1 = cwt(sig,scales_provera,wavelet); % Obtain CWT of input time series
%%%%%% matlab kaze da je ovo outdated i korisit cwt. pogledaj!!! %%%%% 
Re=real(cwtS1);

Freq = 1./(scales_provera);
% tf_wavelet_pow=abs(cwtS1.cfs).^2;
% tf_wavelet_pow_flip=flipud(abs(cwtS1.cfs).^2);

bandBounds=[0 4 7 13 30 49]; %choose where to cut into eeg bands
freqIndices=zeros(1,length(bandBounds));
for (i =1:length(bandBounds))
    freqIndices(i)=findIndex(Freq,bandBounds(i));    
end


delta=sum(Re(freqIndices(2)+1:freqIndices(1),:).^2);
theta=sum(Re(freqIndices(3)+1:freqIndices(2),:).^2);
alpha=sum(Re(freqIndices(4)+1:freqIndices(3),:).^2);
beta=sum(Re(freqIndices(5)+1:freqIndices(4),:).^2);
gamma=sum(Re(freqIndices(6):freqIndices(5),:).^2);

tot=delta+theta+alpha+beta+gamma;

relDelta=delta./tot;
relTheta=theta./tot;
relAlpha=alpha./tot;
relBeta=beta./tot;
relGamma=gamma./tot;

Shannon=-relDelta.*log(relDelta)-relTheta.*log(relTheta)-relAlpha.*log(relAlpha)-relBeta.*log(relBeta)-relGamma.*log(relGamma);


end