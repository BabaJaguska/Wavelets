function [channelsOut,channelsOutEntropy]=cwtDecompose(channelsIn,freqBands,fs,wav)
% cwtDecompose performs continuous wavelet transformation on a set of
% signals and splits it into frequency bands of interest
% IN:
% @param channelsIn: ERP signal, possibly prior to epoching
% @class channelsIn: numeric matrix, No of channels (Nchan (expected 128)) x No of samples (N) 
% @param freqBands: matrix of frequency ranges
% @class freqBands: numeric matrix, variable n of rows (m) x 2 (lower and upper limit)

% OPTIONALLY include fs and wav, otherwise they default to 500Hz and 'coif2'
% @param fs: sampling frequency
% @class fs: numeric
% @param wav: mother wavelet appropriate for continuous decomposition
% @class wav: string

% OUT: 
% @param channelsOut: cwt transformed signals 
% @class channelsOut: numeric array Nchan x Nbands x N
% @param channelsOutEntropy: wavelet entropy of the input signals
% independent of given frequency bands (possibly change this in the code; look for entropyBands)
% @class channelsOutEntropy: numeric array Nchan x N


if (nargin==2) %fali dodatnih uslova, sta ako si samo fs passovao etc...
    fs=500;
    wav='coif2';
end

Nbands=size(freqBands);
Nbands=Nbands(1);
disp(['Broj freq bendova tebra ti je ',num2str(Nbands)])

entropyBands=[1 4;5 7; 7 9; 9 12; 13 25; 25 49]; %menjaj mozda
nEntBands=size(entropyBands);
nEntBands=nEntBands(1);

N=size(channelsIn);
Nchan=N(1);
N=N(2);
disp(['Broj kanala tebra ti je ',num2str(Nchan)])

% neki Erini pomocni parametri
smallestScaleFactor=0.01;
deltaScale=0.05;
dt=1/fs;
s0=smallestScaleFactor*dt; % smallest scale 
NbSc = fix(log2(N*dt/s0)/deltaScale); % number of scales
scales_provera=s0*2.^((0:NbSc-1)*deltaScale);
FreqScale = 1./(scales_provera);
freqBandsIndices=arrayfun(@(x)findIndex(FreqScale,x),freqBands);
entropyBandsIndices=arrayfun(@(x)findIndex(FreqScale,x),entropyBands);

channelsOut=cell(Nchan,Nbands);
channelsOutEntropy=cell(Nchan);
channelsOutEntropy=zeros(Nchan,N);

for i=1:Nchan
   
    %Jos Erinih pomocnih parametara
    sig ={channelsIn(i,:),1/fs}; % preparation of signal structure for cwt or cwtft functions
        
    % CWT
    cwtS1 = cwt(sig,scales_provera,wav); % Obtain CWT of input time series for ith channel
    cwtS1=cwtS1.^2;
    
    % find indices of approximate border frequences
    
   
    
    for j=1:Nbands
       channelsOut{i,j}=sum(cwtS1(freqBandsIndices(j,2):freqBandsIndices(j,1),:));   
    end   
    
    totalEnergy=sum(cwtS1);
    
    for j=1:nEntBands
        currentBand=sum(cwtS1(entropyBandsIndices(j,2):entropyBandsIndices(j,1),:))./totalEnergy;
        channelsOutEntropy(i,:)=channelsOutEntropy(i,:)+currentBand.*log(currentBand);     
    end 
    
end

channelsOut=cell2mat(channelsOut);
channelsOut=reshape(channelsOut,Nchan,Nbands,N);

end