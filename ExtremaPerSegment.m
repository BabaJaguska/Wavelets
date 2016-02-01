function[MinXcell,MinYcell,MaxXcell,MaxYcell,P2Pcell]=ExtremaPerSegment(WavApprox)
    
    NoFiles=length(WavApprox);
    MinXcell={};
    MinYcell={};
    MaxXcell={};
    MaxYcell={};
    P2Pcell={};
  
    for x=1:NoFiles
        % minimumi i maksimumi za svaki segment
        MinX=[];
        MinY=[];
        MaxX=[];
        MaxY=[];
        i=1;
        P2P=[];
        LenSig=length(WavApprox{x});
        levo=1;
        desno=100;
        while(desno<=LenSig)
            Segment=WavApprox{x}(levo:desno);
            MinY=[MinY min(Segment)];
            temp=find(Segment==MinY(i));
            MinX=[MinX temp(1)+100*(i-1)];
            MaxY=[MaxY max(Segment)];
            temp=find(Segment==MaxY(i)); % ovo ti nije nuzno iste duzine vektor kao i MaxY.
            % zbog toga temp
            MaxX=[MaxX temp(1)+100*(i-1)];
            P2P=[P2P MaxY(i)-MinY(i)];
            levo=desno+1;
            desno=desno+100;
            i=i+1;
        end
        MinXcell{x}=MinX;
        MinYcell{x}=MinY;
        MaxXcell{x}=MaxX;
        MaxYcell{x}=MaxY;
        P2Pcell{x}=P2P;
    end
end
