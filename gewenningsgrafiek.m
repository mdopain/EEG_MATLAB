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
    fExist = exist( [PATH_DATA '\epochs\'  setFile ], 'file' );
    if fExist(1) == 0
        error( [ 'SET-File does not exist:' PATH_DATA '\epochs\'  setFile ] )
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
    EEG = pop_loadset( 'filename', setFile, 'filepath', [PATH_DATA '\epochs\']  );
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
    EEG2M1M2 = pop_reref( EEG, [M1 M2] );
    EEG2M1M2.setname = [ patientName ' M1M2'];
    EEG2M1M2 = eeg_checkset( EEG2M1M2 );
    
    
 %% Generate EPs per trigger
 
 [A,min,max]=wenGraph(EEG2M1M2,20,electrodeLookup('C3'));
 
 
%% Stop the timer!
    toc