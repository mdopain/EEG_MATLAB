clear all
close all
clc

load('C:\pathsave\pathsave.mat')

% Folders:
% PATH_RESULTS \ FullName \ fig (for figures)
% PATH_RESULTS \ FullName \ PNG (for PNG images)

TrigNr = 101;
Meting = 'BL4R';
MetingDag = 3;

ERP_FZ_Ylim   = [-10 10];
ERP_M1M2_Ylim = [-15 20];
ERP_timeStop  = 1000;

%%
% Set the path to the Workdirectory.
    cd( PATH_WRKDIR );

% Add the paths to the work directory
    addpath( genpath(PATH_SCRIPTS), genpath(PATH_DATA), PATH_RESULTS );

% Start the Tic Timer.
    tic;

%% Get file info
    [ trigfile, cntfile, FullName, Name, date, trigNr, meting ] = getFileInfo( TrigNr, Meting, MetingDag, PATH_DATA );

% Make a lovely name to display as title
    patientName = [date '.' meting '.' FullName ];
    saveName = [date '.' meting '.' Name ];

    setFile = [ date '.' meting '.' Name '.set' ];
    fExist = exist( [PATH_WRKDIR '\epochs\'  setFile ], 'file' );
    if fExist(1) == 0
        error( [ 'SET-File does not exist:' PATH_WRKDIR '\epochs\'  setFile ] )
    end
%% Create folders, if they dont yet exist
    if exist( [ PATH_RESULTS FullName ], 'dir') == false
        disp( [ 'De map ' PATH_RESULTS FullName ' is aangemaakt.'] )
        mkdir( [ PATH_RESULTS FullName ] );
    end

    if exist( [ PATH_RESULTS FullName '\FIG\' ], 'dir') == false
        disp( [ 'De map ' PATH_RESULTS FullName '\FIG\' ' is aangemaakt.'] )
        mkdir( [ PATH_RESULTS FullName '\FIG\'] );
    end

    if exist( [ PATH_RESULTS FullName '\PNG\' ], 'dir') == false
        disp( [ 'De map ' PATH_RESULTS FullName '\PNG\' ' is aangemaakt.'] )
        mkdir( [ PATH_RESULTS FullName '\PNG\'] );
    end

%% Read EEG data
% Start EEGLab
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Read the dataset
    EEG = pop_loadset( 'filename', setFile, 'filepath', [PATH_WRKDIR '\epochs\']  );
    EEG = eeg_checkset( EEG );

    
%% Obtain the Electrode numbers
    FZ = electrodeLookup( 'Fz' );
    M1 = electrodeLookup( 'M1' );
    M2 = electrodeLookup( 'M2' );

    plots = { 'Cz', 'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'CP1', 'CP2', 'CP3', 'CP4', 'CP5', 'CP6' };
    Enr = zeros( length( plots ), 1 );

    for i = 1:length( plots )
        Enr( i ) = electrodeLookup( plots( i ) );
    end

%% Reference to FZ
    EEG2FZ = pop_reref( EEG, [FZ] );
    EEG2FZ.setname = [ patientName ' Fz'];
    EEG2FZ = eeg_checkset( EEG2FZ );
%%
%{
% Make picachu!
    for i = 1:length( plots )
        figure;
        pop_erpimage( EEG2FZ, 1, Enr( i ), [], [], 10, 1, {}, [], '', 'yerplabel', '\muV', 'erp', 'on', 'limits', [-200 ERP_timeStop ERP_FZ_Ylim NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { Enr( i ) EEG2FZ.chanlocs EEG2FZ.chaninfo } );
        title(gca, [ patientName ' ' char( plots( i ) ) ' FZ' ] )
        saveas(gca, [ PATH_RESULTS FullName '\FIG\FZ_' saveName '_' char( plots( i ) ) '.fig' ] );
        saveas(gca, [ PATH_RESULTS FullName '\PNG\FZ_' saveName '_' char( plots( i ) ) '.png' ] );
        close;
    end
%}
%%
    figure
    for i = 1:length( EEG2FZ.times )
        pica( i ) = sum( EEG2FZ.data( Enr( 5 ), i, 1:30 ) );
    end
    plot( EEG2FZ.times, pica ./ EEG2FZ.trials );
    title( gca, 'Average Epoches' )
    xlabel( gca, 'Time' )
    ylabel( gca,'Intensity' )
    hold on
%    saveas( h, [ PATH_RESULTS FullName '\PNG\FZ_' saveName '_' char( plots( i ) ) '.png' ] );

    clear EEG2FZ;

%% Reference to M1M2
%{
    EEG2M1M2 = pop_reref( EEG, [ M1 M2] );
    EEG2M1M2.setname = [ patientName ' M1-M2'];
    EEG2M1M2 = eeg_checkset( EEG2M1M2 );

% Make picachu!
    for i = 1:length( plots )
        figure;
        Enr( i )
        pop_erpimage( EEG2M1M2, 1, Enr( i ), [], [], 10, 1, {}, [], '', 'yerplabel', '\muV', 'erp', 'on', 'limits', [-200 ERP_timeStop ERP_M1M2_Ylim NaN NaN NaN NaN], 'cbar', 'on', 'caxis', [-30 30], 'spec', [1 35], 'topo', { Enr( i ) EEG2M1M2.chanlocs EEG2M1M2.chaninfo } );
        title( gca, [ patientName ' ' char( plots( i ) ) ' M1M2' ] )
        saveas(gca, [ PATH_RESULTS FullName '\FIG\M1M2_' saveName '_' char( plots( i ) ) '.fig'] );
        saveas(gca, [ PATH_RESULTS FullName '\PNG\M1M2_' saveName '_' char( plots( i ) ) '.png'] );
        close;
    end

    clear EEG2M1M2;
%}
%% Stop the timer!
    toc