clear all
close all
clc

% Declaring path variables. End the string with a "\"
global PATH_WRKDIR PATH_EEGLAB PATH_DATA PATH_RESULTS PATH_EPOCH
PATH_WRKDIR     = 'C:\Users\Jeffrey Benistant\Desktop\Mathlab\';
PATH_EEGLAB     = [ PATH_WRKDIR 'eeglab10_2_5_8b\' ];
PATH_DATA       = [ PATH_WRKDIR 'Data\Raw\' ];
PATH_EPOCH      = [ PATH_WRKDIR 'Data\Epochs\' ];
PATH_RESULTS    = [ PATH_WRKDIR 'Results\' ];

% Folders:
% PATH_RESULTS \ FullName \ fig (for figures)
% PATH_RESULTS \ FullName \ PNG (for PNG images)

%%
% To do:
% Meerdere files inladen. (1x, 2x, 4x, 8x PT aan een hand)
% Van alle EP's, apparte PNG's maken
% Meerdere PT's in een plaatje tonen (eerste 30?)
% De eerste 30 vs de laatste 30 in een plaatje tonen

%% Vragen:
% Moet het signaal gesmooth worden, of is het goed zoals het is?
% Wellciht nog een filter eroverheen???

    TrigNr    = 104;
    Hand      = 'R';
    MetingDag = 4;
    PTs       = [1 2 4 8];
    PTsColour = { 'b-', 'r-', 'g+', 'yo' };
% Electrodes to plot
    plots = { 'CP3' };

% Output formats (see the saveas function)
    output = { 'png' };

% Rereference to
    Reference = { 'FZ' };


% Advanced config...
    ERP_FZ_Ylim   = [-10 10];
    ERP_M1M2_Ylim = [-15 20];
    ERP_timeStop  = 1000;

%%
% Start the Tic Timer.
    tic;

% Set the path to the Workdirectory.
    cd( PATH_WRKDIR );

%% Get file info
    setFiles = [];
    legend   = [];
    for i = 1:length( PTs )
        [ trigfile, cntfile, FullName, Name, date, trigNr, meting ] = getFileInfo( TrigNr, [num2str( PTs( i ) ) Hand], MetingDag, PATH_DATA );

        setFile = [ date '.' num2str( PTs( i ) ) upper( Hand ) '.' Name '.set' ];
        legends = [ legend; [num2str( PTs( i ) ) upper( Hand )] ];
        fExist = exist( [PATH_EPOCH setFile ], 'file' );
        if fExist(1) == 0
            disp( [ 'MakePicachu: SET-File does not exist:' PATH_EPOCH setFile ] )
        else
            setFiles = [ setFiles; setFile ];
        end
    end

% Make a lovely name to display as title
    patientName = [date ' alle PTs ' FullName ];
    saveName = [date '.allPTs.' Name ];

%% Create folders, if they dont yet exist

% In the Results folder, create a directory with the name of the patient
    if exist( [ PATH_RESULTS FullName ], 'dir') == false
        disp( [ 'De map ' PATH_RESULTS FullName ' is aangemaakt.'] )
        mkdir( [ PATH_RESULTS FullName ] );
    end
    
% Create a subfolder in the Results directory, with the name of the format!
% (in capital)
    for i=1:length( output )
        if exist( [ PATH_RESULTS FullName '\' char( upper( output( i ) ) ) '\' ], 'dir') == false
            disp( [ 'De map ' PATH_RESULTS FullName '\' char( upper( output( i ) ) ) '\' ' is aangemaakt.'] )
            mkdir( [ PATH_RESULTS FullName '\' char( upper( output( i ) ) ) '\'] );
        end
    end

%% Obtain the Electrode numbers
    for i = 1:length( Reference )
        ReferenceNrs( i ) = electrodeLookup( Reference( i ) );
    end

% Fill a matrix with zero's
    Enr = zeros( length( plots ), 1 );

% Fill the matrix with the "plots" corresponding electrode numbers.
    for i = 1:length( plots )
        Enr( i ) = electrodeLookup( plots( i ) );
    end


%% Read EEG data
% Start EEGLab
    [ ALLEEG STARTEEG CURRENTSET ALLCOM ] = eeglab;

% For each SET file, loop through 
    for FileNr=1:length( setFiles )

    % Loading electrode location
        EEG = pop_chanedit( STARTEEG, 'load',{ [PATH_EEGLAB 'elpos64_goed.loc' ] 'filetype' 'autodetect'} );
        EEG = eeg_checkset( EEG );

    % Read the dataset
        EEG = pop_loadset( 'filename', setFiles( FileNr, : ), 'filepath', PATH_EPOCH );
        EEG = eeg_checkset( EEG );

    % Reference to FZ
        EEG = pop_reref( EEG, ReferenceNrs );
        EEG.setname = [ patientName ' Fz' ];
        EEG = eeg_checkset( EEG );

%% Make picachu!

        for i = 1:length( plots )
            figure;
            pop_erpimage( EEG, 1, Enr( i ), [], [], 10, 1, {}, [], '', 'yerplabel', '\muV', 'erp', 'on', 'limits', [-200 ERP_timeStop ERP_FZ_Ylim NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { Enr( i ) EEG.chanlocs EEG.chaninfo } );
            title(gca, [ patientName ' ' char( plots( i ) ) ' FZ' ] )
            saveas(gca, [ PATH_RESULTS FullName '\FIG\FZ_' saveName '_' char( plots( i ) ) '.fig' ] );
            saveas(gca, [ PATH_RESULTS FullName '\PNG\FZ_' saveName '_' char( plots( i ) ) '.png' ] );
            close;
        end
%}
%%
        for i = 1:length( EEG.times )
            pica( i ) = sum( EEG.data( Enr( 1 ), i, 1:20 ) );
        end
        plot( EEG.times, pica ./ EEG.trials, char( PTsColour( FileNr ) ) );
        ylim( [-10 10] );
        hold on
%        legend( legends( FileNr ) );

        clear EEG;
    end
    title( 'Paul, 1, 2, 4, 8x PT' )
    xlabel( 'Time' )
    ylabel( 'Intensity' )

% Save and show the image
    hold on
    saveas( gcf, [ PATH_RESULTS FullName '\PNG\FZ_' saveName '_' char( plots( i ) ) '.png' ] );
    
%% Stop the timer!
    toc