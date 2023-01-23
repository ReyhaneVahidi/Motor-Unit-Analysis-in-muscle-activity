clc,
clear all,
close all,

%% load
slow = load('Slow_Contraction.mat');

%% task1
%plotting the spikes
firingmatrix = [];
for cell= 1:length(slow.MUPulses)
    empty=zeros(1,69540);
    for d= 1:length(slow.MUPulses{cell})
        empty(1,slow.MUPulses{cell})=1;
    end
    firingmatrix(cell,:) = empty;
end
firingmatrix=logical(firingmatrix);
%converting the signal into newton
cfactor=0.02;
g=9.81;
sig=slow.ref_signal;
sig_newton=(sig/cfactor)*g;
t_arum = 0 : 1/2048 : length(sig_newton)/slow.fsamp - 1/2048;
% plot  signal
figure()
title('spike trains and the force signal');
plotSpikeRaster(firingmatrix,'PlotType','vertline','VertSpikeHeight',0.9);
xlabel('time(s)');
ylabel('Motor Units');
hold on
yyaxis right
plot(sig_newton)
 
%% task2
%spiketriggeraveraging
STA_window= 0.05;
fsamp=2048;
    
muap=spikeTriggeredAveraging (slow.SIG,slow.MUPulses,STA_window,fsamp);
selected_muap= muap{6};


combined_muap=selected_muap';
combined_muap=vertcat(combined_muap(:));
combined_muap{61,1}=[1:103];
figure()

for i=1:size(combined_muap)
    subplot(13,5,i);
    plot(combined_muap{i});
    title(i)
end

%% task3
%calculating rms for MUAPs
rms_muap=[];
for row=1:13
    for col=1:5
        rms_muap(row,col)=rms(selected_muap{row,col});
    end
end
%plotting heatmap
figure()
imagesc(rms_muap)
title('Heatmap Motor Unit 6')
%comparing 2 more motor units
muap12=muap{12};
muap22=muap{22};
rms_muap12=[];
for row=1:13
    for col=1:5
        rms_muap12(row,col)=rms(muap12{row,col});
    end
end

rms_muap22=[];
for row=1:13
    for col=1:5
        rms_muap22(row,col)=rms(muap22{row,col});
    end
end
figure()
imagesc(rms_muap12)
title('heatmap Motor Unit 12')
figure()
imagesc(rms_muap22)
title('Heatmap Motor Unit 22')