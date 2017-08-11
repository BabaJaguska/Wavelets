function filtered=filterIt(signal)
% filter signal
% low pass
n= 4; % order
fc=49/250; % cutoff frequency; desired cutoff divided by a half of sampling rate
[b,a] = butter(n,fc,'low');

filtered=filtfilt(b,a,signal);

end