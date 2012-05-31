clear all
close all 
clc
%%
tic
for k=[22]; % Jullie hebben pt 22 tot 24
    persons=k;
    clearvars -except k persons nametype
    close all
for set=[1] %1=tonisch, 2=burst, 3=uit 
    clearvars -except k set persons nametype
    cd G:\MDO\Analyse
    setting=set;
    [trigfile,cntfile, name, name_wth_nr]=switchpatients3(persons, setting);
    if length(trigfile)>1   % When trigfile for this setting is present, run code, otherwise, try other setting
    nametype=[name_wth_nr,num2str(setting)];
   
%Onderstaande groene code om te checken of de namen bij switchpatients goed
%zijn ingevoerd, zodat je niet verrast wordt dat na 30 min matlab een
%bestand niet kan vinden. 
%                     disp([num2str(k) ' ' nametype ' aanwezig'])
%                         else
%                         disp([num2str(k) ' ' nametype ' niet aanwezig'])    
%                         end
% 
%                     end
%                     end
% dan hieronder even zo'n %% 

% Make result folder for output
if exist (['G:\MDO\Results\' name], 'dir')~=7
    mkdir('G:\MDO\Results', name)
end

trg = read_eep_trg(trigfile);          % Inlezen trigger file via read_eep_trg
trig = trigger(trg);                    % Triggers sorteren per soort en chronologisch
trig38=trig.t38;                
endEEG=trig38(end)*5+1510*5;


eeg = read_eep_cnt(cntfile,1,endEEG);
eeg = eeg.data;

% Downsample EEG
eeg=downsample(eeg',5)';

% Montage M1M2
eeg=EEGmontageFZ(eeg);

% replace EEG artifacts
nr_trig=size(trig38,1);

    for i=1:nr_trig
        starti=trig38(i)-5;
        eindi=trig38(i)+20;
        for j=1:64
        eegstart=eeg(j,starti);
        eegeind=eeg(j,eindi);
        diffstap=(eegeind-eegstart)/26;
        eegstuk=[1 : 26]*diffstap+eegstart;
        eeg(j,starti:eindi)=eegstuk;
        end
    end   

% LOW filt
sampletime=1/1000;
cutofflow=0.5;
order=2;
  
    % Filtering
    nfc1 = 2*sampletime*cutofflow;        % Index for filtering (0.0<nfc1<1.0), low freq
    [B,A]=butter(order,nfc1, 'high');    % Create 2nd order butterworth filter with bandpass (defined before)
    eeg=filtfilt(B,A,eeg')';               % Filter the EEG signal with the butterworth filter

figure;
[Pxx,w]=pwelch(eeg(48,:),[],[],[],1000,'onesided');
semilogy(w,Pxx)
xlim([0 100])
title('low CP3')    
hold on

% High filt 
sampletime=1/1000;
cutoffhigh=45;
order=4;

    % Filtering
    nfc2 = 2*sampletime*cutoffhigh;         % Index for filtering (0.0<nfc2<1.0), high freq
    [B,A]=butter(order,nfc2, 'low');            % Create 2nd order butterworth filter with bandpass (defined before)    
    eeg=filtfilt(B,A,eeg')';               % Filter the EEG signal with the butterworth filter

% figure;
[Pxx,w]=pwelch(eeg(48,:),[],[],[],1000,'onesided');
semilogy(w,Pxx,'r')
xlim([0 100])
ylim([10e-4 10e3])
title('high CP3')
hold on

% NOTCH filt 
sampletime=1/1000;
cutofflow=45;
cutoffhigh=55;
order2=4;

    nfc1 = 2*sampletime*cutofflow;               % Index for filtering (0.0<nfc2<1.0), high freq
    nfc2 = 2*sampletime*cutoffhigh;
    [B,A]=butter(order2,[nfc1 nfc2], 'stop');    % Create 2nd order butterworth filter with bandpass (defined before)    
    eeg=filtfilt(B,A,eeg')';                      % Filter the EEG signal with the butterworth filter

% figure;
[Pxx,w]=pwelch(eeg(48,:),[],[],[],1000,'onesided');
semilogy(w,Pxx,'g')
xlim([0 100])
title('notch CP3')

saveas(gca, ['G:\MDO\Results\' name '\' nametype '_PSD.fig'])

% make trigline and add
trig=zeros(1,length(eeg));
    for i=1:nr_trig
        samplenr=trig38(i);
        trig(samplenr)=1;
    end

eeg_trig= [eeg;trig];
clear eeg;

% EEGlab
cd G:\MDO\eeglab9_0_8_6b
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;% Load eeglab

% EEG = pop_loadset('filename',[ nametype, 'FZ.set'],'filepath',['G:\\\Afstuderen\\Results\\',name '\\']);
% EEG = eeg_checkset( EEG );


EEG = pop_importdata('dataformat','array','nbchan',0,'data','eeg_trig','srate',1000,'pnts',0,'xmin',0,'comments',strvcat('downsampling 5','reference M1M2','stimulusartefact removed','low 0.5 Hz orde 2','high 45 Hz orde 4','notch 45-55 Hz orde 4'));
EEG.setname=nametype;
EEG = eeg_checkset( EEG );

clear eeg_trig 

EEG = pop_chanevent(EEG, 65,'edge','leading','edgelen',0,'nbtype',1);
EEG.setname=[ nametype 'FZ'];
EEG = eeg_checkset( EEG );

EEG=pop_chanedit(EEG, 'load',{'G:\MDO\\eeglab9_0_8_6b\\elpos64_goed.loc' 'filetype' 'autodetect'});
EEG = pop_saveset( EEG, 'filename',[nametype 'FZ.set'],'filepath',['G:\MDO\Results\' name]);    
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
EEG = eeg_checkset( EEG );

EEG = pop_select( EEG,'nochannel',{'TP8' 'PO7' 'PO8'});
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
EEG = eeg_checkset( EEG );

% Epochs
EEG = pop_epoch( EEG, {  }, [-0.2       0.5], 'newname', [nametype ' epoch FZ'], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-200   -10]);
EEG = eeg_checkset( EEG );
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);

% Reject data
pop_eegplot( EEG, 1, 1, 1);
saveas(gca, ['G:\MDO\Results\' name '\' nametype '_channels_FZ.fig'])


%%
EEG = pop_saveset( EEG, 'filename',[nametype ' epoch FZ.set'],'filepath',['G:\MDO\Results\' name]);    

%% FZ
CZ=find(ismember({EEG.chanlocs.labels}, 'Cz')==1);
C3=find(ismember({EEG.chanlocs.labels}, 'C3')==1);
CP3=find(ismember({EEG.chanlocs.labels}, 'CP3')==1);

% Make squeeze EEG
CZFZ=squeeze(EEG.data(CZ,:,:));
C3FZ=squeeze(EEG.data(C3,:,:));
CP3FZ=squeeze(EEG.data(CP3,:,:));

% plot CZ C3 en CP3
ylimERP=[-10 10];
figure; pop_erpimage(EEG,1, C3,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { C3 EEG.chanlocs EEG.chaninfo } );
title(gca,[nametype ' C3 FZ'])
saveas(gca, ['G:\MDO\Results\' name '\' nametype '_C3_FZ.fig'])

figure; pop_erpimage(EEG,1, CP3,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { CP3 EEG.chanlocs EEG.chaninfo } );
title(gca,[nametype ' CP3 FZ'])
saveas(gca, ['G:\MDO\Results\' name '\' nametype '_CP3_FZ.fig'])


%% Rereference to M1M2
M1=find(ismember({EEG.chanlocs.labels}, 'M1')==1);
M2=find(ismember({EEG.chanlocs.labels}, 'M2')==1);
EEG = pop_reref( EEG, [M1 M2] );
EEG.setname=[ nametype ' M1M2'];
EEG = eeg_checkset( EEG );

CZ=find(ismember({EEG.chanlocs.labels}, 'Cz')==1);
C3=find(ismember({EEG.chanlocs.labels}, 'C3')==1);
CP3=find(ismember({EEG.chanlocs.labels}, 'CP3')==1);

% Make squeeze EEG
CZM1M2=squeeze(EEG.data(CZ,:,:));
C3M1M2=squeeze(EEG.data(C3,:,:));
CP3M1M2=squeeze(EEG.data(CP3,:,:));

%save EPs 
save(['G:\MDO\Results\' name '\' nametype '.mat'], 'CZM1M2','C3M1M2', 'CP3M1M2', 'CZFZ', 'CP3FZ','C3FZ', 'name', 'nametype')

% plot CZ C3 and CP3 to M1M2
ylimERP=[-15 20];
figure; pop_erpimage(EEG,1, C3,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { C3 EEG.chanlocs EEG.chaninfo } );
title(gca,[nametype ' C3 M1M2'])
saveas(gca, ['G:\MDO\Results\' name '\' nametype '_C3_M1M2.fig'])

figure; pop_erpimage(EEG,1, CP3,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { CP3 EEG.chanlocs EEG.chaninfo } );
title(gca,[nametype ' CP3 M1M2'])
saveas(gca, ['G:\MDO\Results\' name '\' nametype '_CP3_M1M2.fig'])

figure; pop_erpimage(EEG,1, CZ,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { CZ EEG.chanlocs EEG.chaninfo } );
title(gca,[nametype ' CZ M1M2'])
saveas(gca, ['G:\MDO\Results\' name '\' nametype '_CZ_M1M2.fig'])

% Plot heads (discard M1 M2 and TP7)
EEG = pop_select( EEG,'nochannel',{'M1', 'M2', 'TP7' });
EEG.setname=[nametype 'M1M2 no M1, M2, TP7']; 
EEG = eeg_checkset( EEG );
pop_topoplot(EEG,1, [20 50  70 80  90  100  110  120 130 140 150  185 200 230 260 280 300 320 350 400 ] ,'',[] ,0,'electrodes','on');
title(gca,{[nametype ' epoch M1M2'], '20 ms'})
saveas(gca, ['G:\MDO\Results\' name '\' nametype '_heads_M1M2.fig'])

%% rereference to FZ, only for plotting of heads (so M1 and M2 are
% disabeld, as wel as TP7)
FZ=find(ismember({EEG.chanlocs.labels}, 'FZ')==1);
EEG = pop_reref( EEG, [FZ] );
EEG.setname=[ nametype 'FZ'];
EEG = eeg_checkset( EEG );

CZ=find(ismember({EEG.chanlocs.labels}, 'Cz')==1);
C3=find(ismember({EEG.chanlocs.labels}, 'C3')==1);
CP3=find(ismember({EEG.chanlocs.labels}, 'CP3')==1);

% Make squeeze EEG
CZFZ=squeeze(EEG.data(CZ,:,:));
C3FZ=squeeze(EEG.data(C3,:,:));
CP3FZ=squeeze(EEG.data(CP3,:,:));

% Plot heads FZ
EEG = pop_select( EEG,'nochannel',{'FZ', 'TP7' });
EEG.setname=[nametype 'FZ no FZ TP7']; 
EEG = eeg_checkset( EEG );
pop_topoplot(EEG,1, [20 50 60 70 80  90 95 100 105 110  120 130 140 150  185 200 230 260 300 350 ] ,'',[] ,0,'electrodes','on');
title(gca,{[nametype ' epoch FZ'], '20 ms'})
saveas(gca, ['G:\MDO\Results\' name '\' nametype '_heads_FZ.fig'])


    end
end
end

toc