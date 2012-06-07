clear all
close all
clc

% Declaring path variables. End the string with a "\"
global PATH_WRKDIR PATH_SCRIPTS PATH_DATA PATH_EEGLAB PATH_RESULTS
PATH_WRKDIR     = 'C:\Users\Jeffrey Benistant\Desktop\Mathlab\';
PATH_SCRIPTS    = [ PATH_WRKDIR 'Analyse2\' ];
PATH_DATA       = [ PATH_WRKDIR 'Data\data\' ];
PATH_EEGLAB     = [ PATH_WRKDIR 'eeglab10_2_5_8b\' ];
PATH_RESULTS    = [ PATH_WRKDIR 'Results\' ];

TrigNr = 102;
Meting = '8R';
MetingDag = 1;
Montage = ['M1'; 'M2'];
Montage2All = 1; % 0 or 1

NoEEGChangels = {'TP8' 'PO7' 'PO8'};

%{
% Add the path's to the work directory
addpath( PATH_SCRIPTS, PATH_DATA, PATH_EEGLAB, PATH_RESULTS );
=======

% Change this boolean statement if you want the hardcoded paths instead of
% dialogs
if 1==1
    PATH_WRKDIR = 'C:\Users\Daniel\Documents\Studie\MDO_offline\';
    PATH_SCRIPTS = 'C:\Users\Daniel\Documents\Studie\MDO_offline\GITtest\';
    PATH_DATA = 'C:\Users\Daniel\Documents\Studie\MDO_offline\data MDO\';
    PATH_EEGLAB = 'C:\Users\Daniel\Documents\Studie\MDO_offline\vanuit MST\eeglab9_0_8_6b\';
    PATH_RESULTS = 'C:\Users\Daniel\Documents\Studie\MDO_offline\results\';
else
    PATH_WRKDIR = [uigetdir('C:\Users\','Select work directory') '\'];
    PATH_SCRIPTS = [uigetdir(PATH_WRKDIR,'Select scripts directory') '\'];
    PATH_DATA = [uigetdir(PATH_WRKDIR,'Select data directory') '\'];
    PATH_EEGLAB = [uigetdir(PATH_WRKDIR,'Select EEGlab directory') '\'];
    PATH_RESULTS = [uigetdir(PATH_WRKDIR,'Select results directory') '\'];
end

% Add the paths to the work directory
addpath( genpath(PATH_SCRIPTS), PATH_DATA, PATH_EEGLAB, PATH_RESULTS );
%}

% Start the Tic Timer.
    tic;

% Set the path to the Workdirectory.
    cd( PATH_WRKDIR );

% Get the location of a Trig- / CNT-file
    [ trigfile, cntfile, name, date, trigNr, meting ] = getFileInfo( TrigNr, Meting, MetingDag, PATH_DATA);

% Create a directory for the output
    if exist( [ PATH_RESULTS name ], 'dir') == false
        disp( [ 'De map ' PATH_RESULTS name ' is aangemaakt.'] )
        mkdir( [ PATH_RESULTS name ] );
    end
% Output some message to the end user, that the file was correctly loaded
% or so...
    disp(['Trig-File found: ' trigfile]);

% Set a variable to use for this patient in filenames, plotnames, etc.
    patientName = [date '.' meting '.' name ];
%% Start the serious business.
% - Load the Data

%%%%
% Load the Trigger file
%
% Read and obtain the Trigger points from the Trigger file.
    disp( [ 'Reading TRIGGER data: ' patientName ] )
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

% Read the EEG data.
    disp( [ 'Reading EEG data: ' patientName ] )
    eeg = read_eep_cnt_( cntfile, 1, endEEG );
    eeg = eeg.data;

% Downsample the EEG data to 1000 Hz.
    eeg = downsample( eeg', 5 )';

% Montage M1M2
%JB    eeg = makeMontage( eeg, Montage, Montage2All );

    clear endEEG
%% Filtering :D
% - Put the signal on zero around the Trigger event.
% - Apply a Highpass filter
% - Apply a Lowpass filter
% - Apply a Stopband filter


    disp( [ 'Applying filters: ' patientName ] )
    disp( '-Replace artefacts' )

% Find out how many triggers there are
    nr_trig = size( trig.t, 1 );

%%%% replace EEG artefacts
% Replace the data around the trigger with "0"
    for i = 1:nr_trig
        starti = trig.t(i) - 5;
        eindi = trig.t(i) + 20;
        for j = 1:64
            eegstart = eeg(j, starti);
            eegeind = eeg(j, eindi);
            diffstap = (eegeind - eegstart) / 26;
            eegstuk = [1 : 26] * diffstap + eegstart;
            eeg( j, starti:eindi ) = eegstuk;
        end
    end

%%%% Image!
% 1) Create a figure of the filtered signal (visual feedback);
    figure;
    [Pxx, w] = pwelch( eeg(48, :), [], [], [], 1000, 'onesided' );
    semilogy( w, Pxx )
    title('Puls artefacts')    
    hold on



% High-pass filter
    disp( '-High-pass filter' )
    sampletime = 1/1000;
    cutofflow = 0.5;
    order = 2;
    nfc1 = 2 * sampletime * cutofflow;

% Create the actual filter
    [B, A] = butter(order, nfc1, 'high');
% Apply the actual filter
    eeg = filtfilt( B, A, eeg' )';

    [Pxx, w] = pwelch( eeg(48, :), [], [], [], 1000, 'onesided' );
    semilogy( w, Pxx )
    title('low CP3')    
    hold on

    disp( '-Low Pass filter' )
% High filt 
    sampletime=1/1000;
    cutoffhigh=50;
    order=4;

% Filtering
    nfc2 = 2 * sampletime * cutoffhigh;         % Index for filtering (0.0<nfc2<1.0), high freq
    [B,A] = butter( order, nfc2, 'low' );            % Create 2nd order butterworth filter with bandpass (defined before)    
    eeg = filtfilt( B, A, eeg' )';               % Filter the EEG signal with the butterworth filter

% 1) Create a figure of the filtered signal (visual feedback);
    [Pxx, w] = pwelch( eeg( 48, :), [], [], [], 1000, 'onesided' );
    semilogy( w, Pxx, 'r' )
    title( 'Low Pass' )
    hold on


% NOTCH filt 50 HZ
   disp( '-Stopband filter 50HZ' )
    sampletime = 1/1000;
    cutofflow = 49;
    cutoffhigh = 51;
    order2 = 1;

    nfc1 = 2 * sampletime * cutofflow;               % Index for filtering (0.0<nfc2<1.0), high freq
    nfc2 = 2 * sampletime * cutoffhigh;
    [B,A] = butter( order2, [ nfc1 nfc2 ], 'stop' );    % Create 2nd order butterworth filter with bandpass (defined before)    
    eeg = filtfilt( B, A, eeg' )';                      % Filter the EEG signal with the butterworth filter

%%%% Image!
% Create a figure of the filtered signal (visual feedback);
    [ Pxx, w ] = pwelch( eeg( 48, :), [], [], [], 1000, 'onesided' );
    semilogy( w, Pxx, 'g' )
    title( 'notch 50' )
    hold on

% Save the image
    disp( '-Save the Signal of all electrodes' )
    saveas( gca, [ PATH_RESULTS name '\' patientName '_PSD.fig' ] )


% Calculate the FFT of the FZ electrode
    Fs = 1000;                                  % Sampling frequency
    T = 1/Fs;                                   % Sample time
    y = eeg( electrodeLookup( 'fz' ), : );      % Signal (electrode 6)
    L = length( y );

    NFFT = 2^16;
    Y = fft( y, NFFT ) / L;
    f = Fs / 2 * linspace( 0, 1, NFFT / 2 + 1 );

%% FFT Image!
% Plot single-sided amplitude spectrum.
    figure
    plot(f,2*abs(Y(1:NFFT/2+1))) 
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
    hold on

% Save the image
    disp( '-Save the Signal of the FFT over FZ' )
    saveas( gca, [ PATH_RESULTS name '\' patientName '_FFT_FZ.fig' ] )

%%

% make trigline and add it to the EEG matrix
    trigers = zeros( 1, length( eeg ) );
    for i = 1:nr_trig
        trigers( trig.t(i) ) = 1;
    end

eeg_trig = [eeg; trigers];
clear eeg trig;

%% EEGlab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

EEG = pop_importdata( 'dataformat', 'array', 'nbchan', 0, 'data', 'eeg_trig', 'srate', 1000, 'pnts', 0, 'xmin', 0, 'comments', char( 'downsampling 5', 'reference M1M2', 'stimulusartefact removed', 'low 0.5 Hz orde 2', 'high 45 Hz orde 4', 'notch 45-55 Hz orde 4' ) );
EEG.setname = patientName;
EEG = eeg_checkset( EEG );

clear eeg_trig

EEG = pop_chanevent( EEG, 65, 'edge', 'leading', 'edgelen', 0, 'nbtype', 1 );
EEG.setname=[ patientName 'FZ'];
EEG = eeg_checkset( EEG );

EEG=pop_chanedit(EEG, 'load',{[ PATH_EEGLAB 'elpos64_goed.loc' ] 'filetype' 'autodetect'});
EEG = pop_saveset( EEG, 'filename',[patientName 'FZ.set'],'filepath',[PATH_RESULTS name]);
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
EEG = eeg_checkset( EEG );

EEG = pop_select( EEG,'nochannel',{'TP8' 'PO7' 'PO8'});
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
EEG = eeg_checkset( EEG );

% Epochs
EEG = pop_epoch( EEG, {  }, [-0.2 1.0], 'newname', [ patientName ], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-200   -10]);
EEG = eeg_checkset( EEG );
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);

% Reject data
pop_eegplot( EEG, 1, 1, 1);
saveas(gca, [PATH_RESULTS name '\' patientName '_channels_FZ.fig'])

%% FZ
%{
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
title(gca,[patientName ' C3 FZ'])
saveas(gca, [PATH_RESULTS name '\' patientName '_C3_FZ.fig'])

figure; pop_erpimage(EEG,1, CP3,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { CP3 EEG.chanlocs EEG.chaninfo } );
title(gca,[patientName ' CP3 FZ'])
saveas(gca, [PATH_RESULTS name '\' patientName '_CP3_FZ.fig'])


%% Rereference to M1M2
M1 = find( ismember( { EEG.chanlocs.labels }, 'M1' ) == 1 );
M2 = find( ismember( { EEG.chanlocs.labels }, 'M2' ) == 1 );
EEG = pop_reref( EEG, [M1 M2] );
EEG.setname=[ patientName ' M1M2'];
EEG = eeg_checkset( EEG );

CZ=find(ismember({EEG.chanlocs.labels}, 'Cz')==1);
C3=find(ismember({EEG.chanlocs.labels}, 'C3')==1);
CP3=find(ismember({EEG.chanlocs.labels}, 'CP3')==1);

% Make squeeze EEG
CZM1M2=squeeze(EEG.data(CZ,:,:));
C3M1M2=squeeze(EEG.data(C3,:,:));
CP3M1M2=squeeze(EEG.data(CP3,:,:));

%save EPs 
save([PATH_RESULTS name '\' patientName '.mat'], 'CZM1M2','C3M1M2', 'CP3M1M2', 'CZFZ', 'CP3FZ','C3FZ', 'name', 'patientName')

% plot CZ C3 and CP3 to M1M2
ylimERP=[-15 20];
figure; pop_erpimage(EEG,1, C3,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { C3 EEG.chanlocs EEG.chaninfo } );
title(gca,[patientName ' C3 M1M2'])
saveas(gca, [PATH_RESULTS name '\' patientName '_C3_M1M2.fig'])

figure; pop_erpimage(EEG,1, CP3,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { CP3 EEG.chanlocs EEG.chaninfo } );
title(gca,[patientName ' CP3 M1M2'])
saveas(gca, [PATH_RESULTS name '\' patientName '_CP3_M1M2.fig'])

figure; pop_erpimage(EEG,1, CZ,[],[],10,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[-200 500 ylimERP NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { CZ EEG.chanlocs EEG.chaninfo } );
title(gca,[patientName ' CZ M1M2'])
saveas(gca, [PATH_RESULTS name '\' patientName '_CZ_M1M2.fig'])
%}
%%

% eeg.Redraw
% eeg.History
toc