function[DataVector]=ReadSignals()
%% Reading the signals

% Set working directory
cd('C:\Users\TECNALIA2014BELI\Desktop\Minjino\!BONESTIM\programi\DrK softver\SVI signali')

% Read multiple files, put them in a cell array Data
% Data will contain NoFiles files, where each file contains 3 columns,
% corresponding to the three axes of the accelerometer

fname=uigetfile('*.txt','Selektuj fajlove za citanje',...
'C:\Users\TECNALIA2014BELI\Desktop\Minjino\!BONESTIM\programi\DrK softver\SVI signali',...
'multiselect','on');
NoFiles=length(fname); % WARNING! If you read only 1 file, this will not work,
% as length will give the number of characgters in the filename
Data={};
for i=1:NoFiles
   Data{i}=load(fname{i}); 
end


%% Some basic pre-filtering

% Remove data points that are larger than median+X standard deviations
% (set them to the median)
X=3;
for Z=1:NoFiles
    [Nrow, Ncol]=size(Data{Z});
    SD=zeros(1,Ncol);
    M=zeros(1,Ncol);
    for I=1:Ncol
        SD(I)=std(Data{Z}(:,I));
        M(I)=median(Data{Z}(:,I));
        for J=1:Nrow
             if (Data{Z}(J,I)>(M(I)+X*SD(I)) || (Data{Z}(J,I)<(M(I)-X*SD(I))))
                Data{Z}(J,I)=M(I);
             end
        end
    end
end

% Define some constants
 fs=100;  % sampling rate 
 % fs je zapravo 1000Hz ali posto se uvek snima 100 odbiraka, ovo bolje radi sa fs=100Hz
 low=0.1; high=6;
 W=2*high/fs;
 [b14, a14]=butter(4,W,'low'); 
 

 % Filter data and place it in Dataf
 Dataf={};
 % Filter and normalize in reference to the maximum of all 3 axes
 for j=1:NoFiles
        [Nrow, Ncol]=size(Data{j});
        Dataf{j}=zeros(Nrow,Ncol);
        % Dodaj minimum svuda pa nadji maksimume
        % Nadji maksimum od sve tri ose, pa njom podeli da normalizujes
        MaxByAxis=zeros(1,3);
        for I=1:Ncol
            Data{j}(:,I)=detrend(Data{j}(:,I));
            Data{j}(:,I)=Data{j}(:,I)+abs(min(Data{j}(:,I)));
            MaxByAxis(I)= max(Data{j}(:,I));
        end
        
        Max=max(MaxByAxis);
        for I=1:Ncol
           Data{j}(:,I)=Data{j}(:,I)/Max;
           Dataf{j}(:,I)=filtfilt(b14,a14,Data{j}(:,I));
        end 
        
 end
 
 % Take the data, square every axis, add them together, then square root them.
 % That's how you get DataVector
 DataVector={};
 for i=1:NoFiles
 DataVector{i}=sqrt(Dataf{i}(:,1).^2+Dataf{i}(:,2).^2+Dataf{i}(:,3).^2);
 end
end
