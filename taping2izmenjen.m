close all
clc

%% izbor fajl
d=uigetfile('*.mat','Izaberite fajl','MultiSelect', 'on'); %% treba izabrati sve signale iz fajla
St1=[];
St2=[];
St3=[];
St4=[];
St5=[];
St6=[];
St7=[];

RMS1=[];
RMS2=[];
RMS3=[];
RMS4=[];
RMS5=[];
RMS6=[];
RMS7=[];



for i=1:length(d)
data=load(d{i});
s=data.w2;
fs=200;
N=length(s);
time=(0:N-1)/fs;

%prikaz originalog signala
figure;
plot(time,s);
xlabel('Vreme[s]'); 
ylabel('Amplituda'); 
title(['Originalni signal']); 

%% izdvajanje sekvence
istop=data.istop;
istart=data.istart;
s1=s(istart:istop);
N1=length(s1);
petina=round(N1/5);
s1=s1(1:end);
time1=(0:N1-1)/fs;


%% primena diskretne WT
[c,l] = wavedec(s1,7,'db4');

% iscrtavanje koeficijenata detalja
% figure;
% plot(1:length(c),c);
D1=detcoef(c,l,1);
D2=detcoef(c,l,2);
D3=detcoef(c,l,3);
D4=detcoef(c,l,4);
D5=detcoef(c,l,5);
D6=detcoef(c,l,6);
D7=detcoef(c,l,7);


%%%%% 


St1= [St1 std(D1)];
St2= [St2 std(D2)];
St3= [St3 std(D3)];
St4= [St4 std(D4)];
St5= [St5 std(D5)];
St6= [St4 std(D6)];
St7= [St7 std(D7)];

RMS1= [RMS1 rms(D1)];
RMS2= [RMS2 rms(D2)];
RMS3= [RMS3 rms(D3)];
RMS4= [RMS4 rms(D4)];
RMS5= [RMS5 rms(D5)];
RMS6= [RMS4 rms(D6)];
RMS7= [RMS7 rms(D7)];


figure;
subplot(7,1,1)
plot(1:length(D1),D1);
subplot(7,1,2)
plot(1:length(D2),D2);
subplot(7,1,3)
plot(1:length(D3),D3);
subplot(7,1,4)
plot(1:length(D4),D4);
subplot(7,1,5)
plot(1:length(D5),D5);
subplot(7,1,6)
plot(1:length(D6),D6);
subplot(7,1,7)
plot(1:length(D7),D7);




%% odredjivanje procentualnog udela energije koeficijenata detalja i aproksimacije
[Ea,Ed] = wenergy(c,l);
ED1(i)=Ed(1);
ED2(i)=Ed(2);
ED3(i)=Ed(3);
ED4(i)=Ed(4);
ED5(i)=Ed(5);
ED6(i)=Ed(6);
ED7(i)=Ed(7);
EA(i)=Ea;
end;

L=length(d);

x=zeros(L,7);  % standardna devijacija. na x osi nivoi na y osi vrednosti STD koeficijenata za svakog pacijenta
for i=1:L
    x(i,1)=St1(i);
    x(i,2)=St2(i);
    x(i,3)=St3(i);
    x(i,4)=St4(i);
    x(i,5)=St5(i);
    x(i,6)=St6(i);
    x(i,7)=St7(i);
end
figure;

plot(x','ob');
title('Standard Deviation of Wavelet Coefficients as f(scale)');
 xlim([0 8]);
 xlabel('Scale');
 ylabel('STD of wavelet coefficients for d MSA patients');
 
 figure;
 boxplot(x);
 title('STD as f(scale),boxplot');
 xlabel('Scale');
 ylabel('STD for d MSA patients')
 
% figure;
% plot(1:d,EA,'o');
% title('Promena energetskog udela koef aproksimacije za sve ispitanike');
% figure;
% plot(1:d,ED1,'o');
% title('Promena energetskog udela koef detalja prvog nivoa za sve ispitanike');
% figure;
% plot(1:d,ED2,'o');
% title('Promena energetskog udela koef detalja drugog nivoa za sve ispitanike');
% figure;
% plot(1:d,ED3,'o');
% title('Promena energetskog udela koef detalja treceg nivoa za sve ispitanike');
% figure;
% plot(1:d,ED4,'o');
% title('Promena energetskog udela koef detalja cetvrtog nivoa za sve ispitanike');


y=zeros(L,7);  % energija. na x osi nivoi na y osi vrednosti energije za svakog pacijenta
for i=1:L
    y(i,1)=ED1(i);
    y(i,2)=ED2(i);
    y(i,3)=ED3(i);
    y(i,4)=ED4(i);
    y(i,5)=ED5(i);
    y(i,6)=ED6(i);
    y(i,7)=ED7(i);
end
figure;
plot(y','og');
title('Wavelet Energy as f(scale)');
 xlim([0 8]);
 xlabel('Scale');
 ylabel('Wavelet energy for d MSA patients');
 figure;
 boxplot(y);
 title('Wavelet Energy as f(scale),boxplot');
 xlabel('Scale');
 ylabel('WEnergy for d MSA patients')
 
 
 r=zeros(L,7);  % energija. na x osi nivoi na y osi vreLnosti energije za svakog pacijenta
for i=1:L
    r(i,1)=RMS1(i);
    r(i,2)=RMS2(i);
    r(i,3)=RMS3(i);
    r(i,4)=RMS4(i);
    r(i,5)=RMS5(i);
    r(i,6)=RMS6(i);
    r(i,7)=RMS7(i);
end
figure;
plot(r','og');
title('rms as f(scale)');
 xlim([0 8]);
 xlabel('Scale');
 ylabel('rms for d MSA patients');
 figure;
 boxplot(r);
 title('rms as f(scale),boxplot');
 xlabel('Scale');
 ylabel('rms for d MSA patients')
 
 % ide rms, pa std pa energija
 allFeatures=[r(:,3:7) x(:,3:7) y(:,3:7)];
 
 % ovde upisujes
 csvwrite('pdFeaturesTOTAL.csv',allFeatures); 
