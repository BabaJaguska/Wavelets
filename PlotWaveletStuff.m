function[]=PlotWaveletStuff(MinX,MinY,MaxX,MaxY,P2P,WavApprox,WholeWav,DataVector)
  % Plots the original signal DataVector
  % Plots the wavelet transformation of DataVector: WholeWav, as a heatmap
  % Plots the WavApprox (mean of wavelet transformation on scales 10 to 50)
  % Plots the extrema and peak-2-peak on each 100point segment of WavApprox

    NoFiles=length(WavApprox);    
    for i=1:NoFiles
        figure(i);
        % Upper plot, approximation and extrema
        subplot(2,1,1)
          plot(DataVector{i}); axis tight;
          hold on;
          plot(mean(WholeWav{i}(10:50,:)),'r'); axis tight;
          plot(MinX{i},MinY{i},'g*'); axis tight;
          plot(MaxX{i},MaxY{i},'k*')
          plot(50:100:length(P2P{i})*100,P2P{i},'-ob');
          hold off
          set(gca,'xtick',0:100:length(DataVector{i}))
          grid on;
          title('Signal and its wavelet approximation (scales 10:50)')
          legend('Signal','WavApprox','Minimum','Maximum','Min-to-Max','location','southoutside','orientation','horizontal')
        % Lower plot, heatmap of the wavelets
        subplot(2,1,2)
          imagesc(WholeWav{i}); grid on;
          set(gca,'ytick',0:10:80);
          set(gca,'xtick',0:100:length(DataVector{i}));
          title 'Continuous Wavelet Transform'
          xlabel 'Sample'
          ylabel 'Scale'
        
    end
end
