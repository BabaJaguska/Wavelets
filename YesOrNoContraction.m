function[MinNema,MinIma,MaxNema,MaxIma]=YesOrNoContraction(MinX,MaxX,Markeri)
% Takes as input all local minima and maxima (positions),
% and Markers, which are thresholds set by observation, 
% that signify the beginning of a contraction
% whereas before that marker,there is no contraction visible

    MinNema={};
    MinIma={};
    MaxNema={};
    MaxIma={};
    NoFiles=length(MinX);
    
    for i=1:NoFiles
        MinNema{i}=MinX{i}(1:Markeri(i)/100);
        MinIma{i}=MinX{i}(Markeri(i)/100+1:end);
        MaxNema{i}=MaxX{i}(1:Markeri(i)/100);
        MaxIma{i}=MaxX{i}(Markeri(i)/100+1:end);
    end

end
