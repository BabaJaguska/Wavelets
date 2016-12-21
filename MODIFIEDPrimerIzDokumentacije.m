% Load the signal and select a portion for wavelet analysis.
nazivFajla=uigetfile('Biraj fajl da crtas i tako to');
f=load(nazivFajla); % ovo ti je neka struktura
% f sadrzi
%    zfile: 'TAPPING snimci\CTRL Fajlovi\Nada Rapajic CTRL\02.10.2013_10.19.54.zgz'
    %ttapstart: 5.2750
     %ttapstop: 21.1800
      %     w2: [1x4352 double]
       %istart: 1055
        %istop: 4236
% znaci podaci su ti u f.w2, ali vidi odakle dokle
s=f.w2(f.istart:f.istop);
l_s = length(s);

fs=200;
time=(0:l_s-1)/fs;

% load leleccum;
% s = leleccum(1:3920);
% l_s = length(s);

% MULTILEVEL DWT
% Perform a multilevel wavelet decomposition of a signal.
% To perform a level 7 decomposition of the signal (again using the db1 wavelet), type
[C,L] = wavedec(s,10,'db4');

% The coefficients of all the components of a third-level decomposition (that is,
%the third-level approximation and the first three levels of detail) are returned
% concatenated into one vector, C. Vector L gives the lengths of each component

% APPCOEF and DETCOEF
%Extract approximation and detail coefficients.
%To extract the level 5 approximation coefficients from C, type
cA5 = appcoef(C,L,'db4',5);

%To extract the levels 3, 2, and 1 detail coefficients from C, type

[cD1,cD2,cD3,cD4,cD5,cD6,cD7,cD8,cD9,cD10] = detcoef(C,L,[1,2,3,4,5,6,7,8,9,10]);

%Reconstruct the Level 7 approximation and the Level 1, 2, and 3,4,5,6,7 details.
A4 = wrcoef('a',C,L,'db4',4);

%To reconstruct the details at levels 1, 2, through 7, from C, type
D1 = wrcoef('d',C,L,'db4',1);
D2 = wrcoef('d',C,L,'db4',2);
D3 = wrcoef('d',C,L,'db4',3);
D4 = wrcoef('d',C,L,'db4',4);
D5 = wrcoef('d',C,L,'db4',5);
D6 = wrcoef('d',C,L,'db4',6);
D7 = wrcoef('d',C,L,'db4',7);
D8 = wrcoef('d',C,L,'db4',8);
D9 = wrcoef('d',C,L,'db4',9);
D10 = wrcoef('d',C,L,'db4',10);


% Display the results of a multilevel decomposition.
% To display the results of the level 7 decomposition, type
figure(2)
% subplot(8,1,1); plot(time,A4);
% title('Approximation A5')
% subplot(8,1,1); plot(time,D1);  %% prva dva su ti frekvencije 
% 50-100 i 
% 25-50 Hz, a tu nemas relevantne informacije

% title('Detail D1')
% subplot(8,1,2); plot(time,D2);
% title('Detail D2')
subplot(5,1,1); plot(time,D3);
title('Decomposed signal')
ylabel('D3');
subplot(5,1,2); plot(time,D4);
ylabel('D4');
subplot(5,1,3); plot(time,D5);
ylabel('D5');
subplot(5,1,4); plot(time,D6);
ylabel('D6');
subplot(5,1,5); plot(time,D7);
ylabel('D7');
xlabel('time [s]')
% subplot(11,1,9); plot(D8);
% title('Detail D8')
% subplot(11,1,10); plot(D9);
% title('Detail D9')
% subplot(11,1,11); plot(D10);
% title('Detail D10')

%Reconstruct the original signal from the Level 7 decomposition.
%To reconstruct the original signal from the wavelet decomposition structure, type

% C(L(1):2*L(1))=0;
% A0drift = waverec(C,L,'db4');
% err = max(abs(s-A0));
% figure(4)
% subplot(2,1,1); plot(A0);
% title('reconstructed')
% subplot(2,1,2);plot(A0drift);
% title('unbaselined reconstruct');

% DENOISING!!
% Crude denoising of a signal
% Using wavelets to remove noise from a signal requires identifying which component
%or components contain the noise, and then reconstructing the signal without those
%components

% In this example, we note that successive approximations become less and less noisy
%as more and more high-frequency information is filtered out of the signal.
%The level 3 approximation, A3, is quite clean as a comparison between it and the
%original signal.

%To compare the approximation to the original signal, type
figure(3)
subplot(2,1,1);plot(s);title('Original'); axis off
subplot(2,1,2);plot(time,A4);title('Level 4 Approximation');
axis off

% Of course, in discarding all the high-frequency information, we've also lost many of
%the original signal's sharpest features.
%Optimal denoising requires a more subtle approach called thresholding. This
%involves discarding only the portion of the details that exceeds a certain limit

% THRESHOLDING
% Remove noise by thresholding.
% What if we limited the strength of the details by restricting their
%maximum values? This would have the effect of cutting back the noise while leaving
%the details unaffected through most of their durations. But there's a better way

%Note that cD1, cD2, and cD3 are just MATLAB vectors, so we could directly
%manipulate each vector, setting each element to some fraction of the vectors' peak or
%average value. Then we could reconstruct new detail signals D1, D2, and D3 from the
%thresholded coefficients.

% DDENCMP i WDENCMP
%To denoise the signal, use the ddencmp command to calculate the default parameters
%and the wdencmp command to perform the actual denoising, type
[thr,sorh,keepapp] = ddencmp('den','wv',s);
clean = wdencmp('gbl',C,L,'db1',3,thr,sorh,keepapp);

%Note that wdencmp uses the results of the decomposition (C and L) that we calculated
%in step 6. We also specify that we used the db1 wavelet to perform the original
%analysis, and we specify the global thresholding option 'gbl'. See ddencmp
%and wdencmp in the reference pages for more information about the use of these
%commands.

%To display both the original and denoised signals, type
% figure(5)
% subplot(2,1,1); plot(s(2000:3920)); title('Original')
% subplot(2,1,2); plot(clean(2000:3920)); title('denoised')

% We've plotted here only the noisy latter part of the signal. Notice how we've removed
%the noise without compromising the sharp detail of the original signal. This is a
%strength of wavelet analysis.

% While using command line functions to remove the noise from a signal can be
%cumbersome, the software's graphical interface tools include an easy-to-use
% denoising feature that includes automatic thresholding
%More information on the denoising process can be found in the following sections:
% • Remove noise from a signal
% • “Denoising and Nonparametric Function Estimation” on page 5-2 in the
% Wavelet Toolbox User's Guide
% “One-Dimensional Adaptive Thresholding of Wavelet Coefficients” on page
%5-30
% • “One-Dimensional Wavelet Variance Adaptive Thresholding” on page 5-12 in
% the Wavelet Toolbox User's Guide

% 
% l_L=length(L)
% 
% C((L(l_L)-L(l_L-1)-L(l_L-2)):L(l_L))=0;
% A0 = waverec(C,L,'db4');
% figure(4)
% subplot(2,1,1);plot(time,s)
% title('Original signal');
% subplot(2,1,2);plot(time,A0)
% title('Filtered signal');