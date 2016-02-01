function[]=HistExtremePositions(MinNema,MinIma,MaxNema,MaxIma)
   % Plots histograms of where the extreme values occur for when there and 
   % and when there is no contraction
   
   % Srokaj zajedno

    SrokanMinNema=[];
    SrokanMinIma=[];
    SrokanMaxNema=[];
    SrokanMaxIma=[];
    NoFiles=length(MinNema);
    
    for i=1:NoFiles
        SrokanMinNema=[SrokanMinNema mod(MinNema{i},100)];
        SrokanMinIma=[SrokanMinIma mod(MinIma{i},100)];
        SrokanMaxNema=[SrokanMaxNema mod(MaxNema{i},100)];
        SrokanMaxIma=[SrokanMaxIma mod(MaxIma{i},100)];    
    end

    figure()
    subplot(1,4,1)
        histogram(SrokanMinNema,10)
        ylabel 'Broj pojavljivanja minimuma u opsegu'
        title 'MINIMUM bez kontrakcije'
    subplot(1,4,2)
        histogram(SrokanMinIma,10)
        ylabel 'Broj pojavljivanja minimuma u opsegu'
        title 'MINIMUM sa kontrakcijom'
    subplot(1,4,3)
        histogram(SrokanMaxNema,10)
        ylabel 'Broj pojavljivanja maksimuma u opsegu'
        title 'MAXIMUM bez kontrakcije'
    subplot(1,4,4)
        histogram(SrokanMaxIma,10)
        ylabel 'Broj pojavljivanja maksimuma u opsegu'
        title 'MAXIMUM sa kontrakcijom'
end
