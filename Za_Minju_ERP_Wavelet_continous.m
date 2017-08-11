%% Read file(s)
fileName=uigetfile('*.mat','MultiSelect','on');

if ischar(fileName) 
    N=1;
else
    N=length(fileName);
end

% totalTarget=zeros(300,1);
% totalNonTarget=zeros(300,1);
 totalTarget=zeros(1500,1);
 totalNonTarget=zeros(1500,1);
totalTargetOriginal=zeros(300,1);
totalNonTargetOriginal=zeros(300,1);

% parpool('local');

for i=1:N

    if N==1
        subjectData=load(fileName);
    else
        subjectData=load(fileName{i});
    end
subjectData=subjectData.XXX;
singleChan=104;

targetData=subjectData(1);
nonTargetData=subjectData(2);

targetDataSingleChan=squeeze(targetData.data(singleChan,:,:)); 
% targetDataSingleChan is now NoSamples x NoTrials
nonTargetDataSingleChan=squeeze(nonTargetData.data(singleChan,:,:));

%% Remove artefacts
% Define @threshold to remove all sweeps containing absolute values larger
% than thresholds

threshold=50; %[uV]
surpassesThresholdTarget=find(sum(abs(targetDataSingleChan)>=threshold));
surpassesThresholdNonTarget=find(sum(abs(nonTargetDataSingleChan)>=threshold));
targetDataSingleChan(:,surpassesThresholdTarget)=[];
nonTargetDataSingleChan(:,surpassesThresholdNonTarget)=[];
L1=size(targetDataSingleChan);
L1=L1(2);
L2=size(nonTargetDataSingleChan);
L2=L2(2);



%% 

time=targetData.times;

%Select out of non target sweeps
rng(1);
pickRandIndices=randi(L2,L1,1);
nonTargetDataSingleChan=nonTargetDataSingleChan(:,pickRandIndices);

%temporal means
meanTargetTemp=mean(targetDataSingleChan,2);
meanNonTargetTemp=mean(nonTargetDataSingleChan,2);

%%%%%% f bands %%%%
fun=@findBands;
targetSweeps=num2cell(targetDataSingleChan,1);
targetBands=cellfun(fun,targetSweeps,'UniformOutput',false); 
temp=reshape(cell2mat(targetBands),[1500,L1]);
meanBandsTarget=mean(temp,2);
totalTarget=totalTarget+meanBandsTarget;

nonTargetSweeps=num2cell(nonTargetDataSingleChan,1);
nonTargetBands=cellfun(fun,nonTargetSweeps,'UniformOutput',false); 
temp=reshape(cell2mat(nonTargetBands),[1500,L1]);
meanBandsNonTarget=mean(temp,2);
totalNonTarget=totalNonTarget+meanBandsNonTarget;


% % find shannon wavelet entropies for all sweeps
% fun=@findShannon2;
% 
% targetSweeps=num2cell(targetDataSingleChan,1);
% targetEntropies=cellfun(fun,targetSweeps,'UniformOutput',false); 
% temp=reshape(cell2mat(targetEntropies),[300,L1]);
% meanEntropyTarget=mean(temp,2);
% totalTarget=totalTarget+meanEntropyTarget;
% 
% nonTargetSweeps=num2cell(nonTargetDataSingleChan,1);
% nonTargetEntropies=cellfun(fun,nonTargetSweeps,'UniformOutput',false); 
% temp=reshape(cell2mat(nonTargetEntropies),[300,L1]); 
% meanEntropyNonTarget=mean(temp,2);
% totalNonTarget=totalNonTarget+meanEntropyNonTarget;
% 
% furiTarget=abs(fft(meanTargetTemp)/L1);
% furiNonTarget=abs(fft(meanNonTargetTemp)/L1);
% furiTarget=furiTarget(1:floor(L1/2)+1);
% furiNonTarget=furiNonTarget(1:floor(L1/2)+1);
% f = 500*(0:floor(L1/2))/L1;

totalTargetOriginal=totalTargetOriginal+meanTargetTemp;
totalNonTargetOriginal=totalNonTargetOriginal+meanNonTargetTemp;


figure(i)
subplot(3,2,1)
% Mean signal (single subject average)
plot(time,meanTargetTemp)
hold on
grid on
plot(time,meanNonTargetTemp)
hold off
legend ('target','nonTarget')
xlabel(['t[ms] - Number of sweeps averaged: ',num2str(L1)])
ylabel('[uV]')
title(fileName{i})
% Mean Entropy (Single subject average)

subplot(3,2,2)
hold on
grid on
plot(time,meanBandsTarget(1:300));
plot(time,meanBandsNonTarget(1:300));
hold off
title('delta')

subplot(3,2,3)
hold on
plot(time,meanBandsTarget(301:600));
plot(time,meanBandsNonTarget(301:600));
title('theta')
hold off

subplot(3,2,4)
hold on
plot(time,meanBandsTarget(601:900));
plot(time,meanBandsNonTarget(601:900));
hold off
title('alpha')

subplot(3,2,5)
hold on
grid on
plot(time,meanBandsTarget(901:1200));
plot(time,meanBandsNonTarget(901:1200));
hold off
title('beta') 

subplot(3,2,6)
hold on
grid on
plot(time,meanBandsTarget(1201:1500));
plot(time,meanBandsNonTarget(1201:1500));
title('gamma')
hold off
% legend ('target','nonTarget')
% ylabel('Entropy')
ylabel('Rel band power')
title('gamma')
hold off


% plot(f,furiTarget)
% hold on
% plot(f,furiNonTarget)
% xlabel('f[Hz]')
% legend('target','nonTarget')
% ylabel('fft')
% grid on
% hold off


end
%---------------- % wavelet type

% 'dog' — m-th order derivative of a Gaussian wavelet where m is a positive even integer. The default value of m is 2.
% 'morl' — Morlet wavelet. Results in an analytic Morlet wavelet. The Fourier transform of an analytic wavelet is zero for negative frequencies.
% 'morlex' — non-analytic Morlet wavelet
% 'morl0' — non-analytic Morlet wavelet with zero mean
% 'mexh' — Mexican hat wavelet. The Mexican hat wavelet is a special case of the m-th order derivative of a Gaussian wavelet with m=2.
% 'paul' — Paul wavelet
% 'bump' — Bump wavelet


figure()
subplot(3,2,1)
title('TOTAL: delta (0-4Hz)')
plot(time,totalTarget(1:300))
plot(time,totalNonTarget(1:300))
subplot(3,2,2)
plot(time,totalTarget(301:600))
plot(time,totalNonTarget(301:600))
title('TOTAL:theta (4-7Hz)')
subplot(3,2,3)
plot(time,totalTarget(601:900))
plot(time,totalNonTarget(601:900))
title('TOTAL:alpha (7-13Hz)')
subplot(3,2,4)
plot(time,totalTarget(901:1200))
plot(time,totalNonTarget(901:1200))
title('TOTAL:beta (13-30 Hz)')
subplot(3,2,5)
plot(time,totalTarget(1201:1500))
plot(time,totalNonTarget(1201:1500))
title('TOTAL:gamma (30-49Hz)')
subplot(3,2,6)


% totalTarget=totalTarget./N;
% totalNonTarget=totalNonTarget./N;
% totalTargetOriginal=totalTargetOriginal./N;
% totalNonTargetOriginal=totalNonTargetOriginal./N;
% figure()
% subplot(2,1,1)
% plot(time,totalTarget);
% hold on
% grid on
% plot(time,totalNonTarget);
% hold off
% xlabel('time[s]')
% ylabel('Entropy')
% title('GRAND AVERAGE WAV SHANNON ENTROPY')
% subplot(2,1,2)
% hold on
% plot(time,totalTargetOriginal)
% plot(time,totalNonTargetOriginal)
% grid on
% xlabel('time[s]')
% ylabel('[uV]')
% hold off
%%
 % freq to plot
%                 val_f1=7;
%                 tmp_f1 = abs(Freq-val_f1);
%                 [idx_f1 idx_f1] = min(tmp_f1); %index of closest value
%                 closest_f1 = Freq(idx_f1); %closest value
% %                 index_f1=find(Freq==closest_f1);
% 
%  
%                 val_f2=13;
%                 tmp_f2 = abs(Freq-val_f2);
%                 [idx_f2 idx_f2] = min(tmp_f2); %index of closest value
%                 closest_f2 = Freq(idx_f2); %closest value
% %                 index_f2=find(Freq==closest_f2);



%%
% 
%         figure(4)
%         contour(time,Freq,tf_wavelet_pow);
%         xlabel('Seconds'); ylabel('Pseudo-frequency');
%         set(gca,'YScale','log')
%         axis([-100 time(end) 0 fs/2-1]);
%      
%         figure()
%         subplot(3,1,1)
%         mesh(time,Freq,real(cwtS1.cfs));
%         xlabel('Seconds'); ylabel('Pseudo-frequency');
%         axis([-100 time(end) 0 fs/2]);
%         axis([-100 time(end) 0 100]);
%         subplot(3,1,2)
%         plot(time,relDelta);
%         hold on
%         plot(time,relTheta);
%         plot(time,relAlpha);
%         plot(time,relBeta);
%         plot(time,relGamma);
%         hold off
%         legend('delta','theta','alpha','beta','gamma')
%         subplot(3,1,3)
%         plot(time,shannon)
%         
%         
%        
% %         figure(7) % iz ovoga se odredjuje parametar granica
% %         imagesc(tf_wavelet_pow); 
% %         xlabel('Seconds'); ylabel('Pseudo-frequency');
% 
% 
% 
%----------------


