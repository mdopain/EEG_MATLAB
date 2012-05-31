PATH_DATA = 'C:\Users\Jeffrey Benistant\Desktop\Mathlab';
PATH_EEGLAB = 'G:\MDO\eeglab9_0_8_6b';
PATH_RESULTS = 'G:\MDO\Results\';


% Fuck Yeah!
clear all
close all
clc

% Start the Tic Timer.
    tic

% Set the path to the Data Files.
    cd PATH_DATA

% Get the location of a Trig- / CNT-file
    [ trigfile, cntfile, name, date, trigNr, meting ] = getFileInfo( 101, '1L', 1);

% Output some message to the end user, that the file was correctly loaded
% or so...
    disp(['Trig-File found: ' trigfile]);

% Set a variable to use for this patient in filenames, plotnames, etc.
    patientName = [date '.' meting '.' name];
%% Start the serious business.
% - Load the Data

%%%%
% Load the Trigger file
%
% Read and obtain the Trigger points from the Trigger file.
    trig = getTrigger( trigfile, trigNr );
% From this moment on, trig.t contains the triggers.

%%%%
% Load the EEG file
%
% First find out until where we should reed the EEG file (until what
% timestamp)
% First, add 2000 ms to the last triggerpoint.
% Then, since the sample frequency is 5000 Hz. multiply the number with 5.
    endEEG = (trig.t( end ) + 2000) * 5;

% Beside the endEEG, we can also calculate the start EEG time...
% Find the first trigger point, substract 1000ms from it and multiply with
% 5.
    startEEG = (trig.t( start ) - 1000) * 5;

% Read the EEG data.
    eeg = read_eep_cnt( cntfile, startEEG, endEEG );
    eeg = eeg.data;

% Downsample the EEG data to 1000 Hz.
    eeg = downsample( eeg', 5 )';

% Montage M1M2
    eeg = makeMontage( eeg, ['Fz']);
%% Filtering :D
% - Put the signal on zero around the Trigger event.
% - Apply a Highpass filter
% - Apply a Lowpass filter
% - Apply a Stopband filter

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

saveas(gca, [PATH_RESULTS name '\' nametype '_PSD.fig'])

% make trigline and add
trig=zeros(1,length(eeg));
    for i=1:nr_trig
        samplenr=trig38(i);
        trig(samplenr)=1;
    end

eeg_trig= [eeg;trig];
clear eeg;

% EEGlab
cd PATH_EEGLAB
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
EEG = pop_saveset( EEG, 'filename',[nametype 'FZ.set'],'filepath',[PATH_RESULTS name]);    
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
saveas(gca, [PATH_RESULTS name '\' nametype '_channels_FZ.fig'])


%%
EEG = pop_saveset( EEG, 'filename',[nametype ' epoch FZ.set'],'filepath',[PATH_RESULTS name]);    

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
saveas(gca, [PATH_RESULTS name '\' nametype '_C3_FZ.fig'])

figure; pop_erpimage(EEG,1, CP3,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { CP3 EEG.chanlocs EEG.chaninfo } );
title(gca,[nametype ' CP3 FZ'])
saveas(gca, [PATH_RESULTS name '\' nametype '_CP3_FZ.fig'])


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
save([PATH_RESULTS name '\' nametype '.mat'], 'CZM1M2','C3M1M2', 'CP3M1M2', 'CZFZ', 'CP3FZ','C3FZ', 'name', 'nametype')

% plot CZ C3 and CP3 to M1M2
ylimERP=[-15 20];
figure; pop_erpimage(EEG,1, C3,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { C3 EEG.chanlocs EEG.chaninfo } );
title(gca,[nametype ' C3 M1M2'])
saveas(gca, [PATH_RESULTS name '\' nametype '_C3_M1M2.fig'])

figure; pop_erpimage(EEG,1, CP3,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { CP3 EEG.chanlocs EEG.chaninfo } );
title(gca,[nametype ' CP3 M1M2'])
saveas(gca, [PATH_RESULTS name '\' nametype '_CP3_M1M2.fig'])

figure; pop_erpimage(EEG,1, CZ,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { CZ EEG.chanlocs EEG.chaninfo } );
title(gca,[nametype ' CZ M1M2'])
saveas(gca, [PATH_RESULTS name '\' nametype '_CZ_M1M2.fig'])

% Plot heads (discard M1 M2 and TP7)
EEG = pop_select( EEG,'nochannel',{'M1', 'M2', 'TP7' });
EEG.setname=[nametype 'M1M2 no M1, M2, TP7']; 
EEG = eeg_checkset( EEG );
pop_topoplot(EEG,1, [20 50  70 80  90  100  110  120 130 140 150  185 200 230 260 280 300 320 350 400 ] ,'',[] ,0,'electrodes','on');
title(gca,{[nametype ' epoch M1M2'], '20 ms'})
saveas(gca, [PATH_RESULTS name '\' nametype '_heads_M1M2.fig'])

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
saveas(gca, [PATH_RESULTS name '\' nametype '_heads_FZ.fig'])

toc