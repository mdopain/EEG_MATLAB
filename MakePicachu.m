clear all
close all
clc

% Declaring path variables. End the string with a "\"
global PATH_WRKDIR PATH_SCRIPTS PATH_DATA PATH_RESULTS
PATH_WRKDIR     = 'C:\Users\Jeffrey Benistant\Desktop\Mathlab\';
PATH_SCRIPTS    = [ PATH_WRKDIR 'Analyse2\' ];
PATH_DATA       = [ PATH_WRKDIR 'Data\data\' ];
PATH_RESULTS    = [ PATH_WRKDIR 'Results\' ];

% Folders:
% PATH_RESULTS \ FullName \ fig (for figures)
% PATH_RESULTS \ FullName \ PNG (for PNG images)

TrigNr = 102;
Meting = '4R';
MetingDag = 1;

ERP_FZ_Ylim   = [-10 10];
ERP_M1M2_Ylim = [-15 20];
ERP_timeStop  = 1000;

%%
% Set the path to the Workdirectory.
    cd( PATH_WRKDIR );

% Add the path's to the work directory
    addpath( PATH_SCRIPTS, PATH_DATA, PATH_RESULTS );

% Start the Tic Timer.
    tic;

%% Get file info
    [ trigfile, cntfile, FullName, Name, date, trigNr, meting ] = getFileInfo( TrigNr, Meting, MetingDag, PATH_DATA );

% Make a lovely name to display as title
    patientName = [date '.' meting '.' FullName ];
    saveName = [date '.' meting '.' Name ];

    setFile = [ date '.' meting '.' Name '.set' ];
    setPath = [PATH_RESULTS FullName '\' ];
    fExist = exist( [setPath setFile ], 'file' );
    if fExist(1) == 0
        error( [ 'MakePicachu: SET-File does not exist:' setPath setFile ] )
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
    EEG = pop_loadset( 'filename', setFile, 'filepath', setPath );
    EEG = eeg_checkset( EEG );

%% Make Pica!
%{
    figure
    for i = 1:length( EEG.times )
        pica( i ) = sum( EEG.data(14,i,:) );
    end
    plot( EEG.times, pica ./ EEG.trials );
    title('All Epoches')
    xlabel('Time')
    ylabel('Intensity')
    hold on
%}
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

% Make picachu!
    for i = 1:length( plots )
        figure;
        pop_erpimage( EEG2FZ, 1, Enr( i ), [], [], 10, 1, {}, [], '', 'yerplabel', '\muV', 'erp', 'on', 'limits', [-200 ERP_timeStop ERP_FZ_Ylim NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { Enr( i ) EEG2FZ.chanlocs EEG2FZ.chaninfo } );
        title(gca, [ patientName ' ' char( plots( i ) ) ' FZ' ] )
        saveas(gca, [ PATH_RESULTS FullName '\FIG\FZ_' saveName '_' char( plots( i ) ) '.fig' ] );
        saveas(gca, [ PATH_RESULTS FullName '\PNG\FZ_' saveName '_' char( plots( i ) ) '.png' ] );
        close;
    end

    clear EEG2FZ;

%% Reference to M1M2
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
%% Stop the timer!
    toc