clear all
close all
clc

% Declaring path variables. End the string with a "\"
global PATH_WRKDIR PATH_EEGLAB PATH_DATA PATH_RESULTS PATH_EPOCH
PATH_WRKDIR     = 'C:\Users\Jeffrey Benistant\Desktop\Mathlab\';
PATH_EEGLAB     = [ PATH_WRKDIR 'eeglab10_2_5_8b\' ];
PATH_DATA       = [ PATH_WRKDIR 'Data\Raw\' ];
PATH_EPOCH      = [ PATH_WRKDIR 'Data\Epochs\' ];
PATH_RESULTS    = [ PATH_WRKDIR 'Results\Output\' ];

% Folders:
% PATH_RESULTS \ FullName \ FIG (for figures)
% PATH_RESULTS \ FullName \ PNG (for PNG images)

    EPs         = { '01.06.OO4R.Daniel', '01.06.BL4R.Daniel' };
    FileName    = 'Filename';
    IMGTitle    = 'Ogen open compare Daniel';

    EpochStart = 1;  % Fill in 0, to start at the beginning
    EpochStop  = 50; % t/m % Fill in 0 to go till the end.

    MakeERP = 0;
    MakePlot = 1;
% Electrodes to plot
    plotsR = { 'CP3' };
    plotsL = { 'CP4' };

% Output formats (see the saveas function)
    output = { 'png' };

% Rereference to
    Reference = { 'FZ' };

% Advanced config...
    ERP_Ylim        = [-10 10];
    ERP_timeStop    = 1000;

%%
% Start the Tic Timer.
    tic;

% Set the path to the Workdirectory.
    cd( PATH_WRKDIR );

% Define a variable for the legend
    PLOTlegend = {};

% Colours
    EPsColour   = { 'b-', 'r-', 'g-', 'y-', 'o-', 'p-' };
    EPsColourNr = 1;

%% Preform Checks
    if length( EPs ) == 0
        error( 'EPs: dude... WAKER UP! You gotta select the EPs yourself, me not gonna do that 4 you!' )
    end
        
    if MakeERP == 0 && MakePlot == 0
        error( '... You stupid. No pica made this way! (MakePlot = 0; MakeERP = 0)' );
    end
    
    if length( plotsR ) == 0
        error( 'Serials? plotsR is empty' );
    end
    
    if length( plotsL ) == 0
        error( 'Serials? plotsL is empty' );
    end
    
%% Get file info
    for i = 1:length( EPs )
        fExist = exist( [PATH_EPOCH char( EPs( i ) ) '.set' ], 'file' );
        if fExist(1) == 0
            error( [ 'MakePicachu: SET-File does not exist:' PATH_EPOCH char( EPs( i ) ) '.set' ] )
        end
    end

%% Create folders, if they dont yet exist

% In the Results folder, create a directory with the name of the patient
    if exist( [ PATH_RESULTS ], 'dir') == false
        mkdir( [ PATH_RESULTS ] );
        disp( [ 'De map ' PATH_RESULTS ' is aangemaakt.'] )
    end

% Create a subfolder in the Results directory, with the name of the format!
% (in capital)
    for i = 1:length( output )
        if exist( [ PATH_RESULTS char( upper( output( i ) ) ) '\' ], 'dir') == false
            mkdir( [ PATH_RESULTS char( upper( output( i ) ) ) '\'] );
            disp( [ 'De map ' PATH_RESULTS char( upper( output( i ) ) ) '\' ' is aangemaakt.'] )
        end
    end

%% Obtain the Electrode numbers
    for i = 1:length( Reference )
        ReferenceNrs( i ) = electrodeLookup( Reference( i ) );
    end

%% Read EEG data
% Start EEGLab
    [ ALLEEG STARTEEG CURRENTSET ALLCOM ] = eeglab;

% For each SET file, loop through
    for FileNr = 1:length( EPs )
%%
    % Fill a matrix with zero's
        clear Enr plots;

    % Figure out wheter the Left or the Right hand data is loading...
        tmp = strfind( char( EPs( FileNr ) ), 'R.' );
        if length( tmp ) > 0
            plots = plotsR;
        else
            tmp = strfind( char( EPs( FileNr ) ), 'L.' );
            if length( tmp ) > 0
                plots = plotsL;
            else
                error( 'Sjit! I cannot figure out whether this is the Left or the Right hand!' );
            end
        end

    % Fill the matrix with the "plots" corresponding electrode numbers.
        Enr = zeros( length( plots ), 1 );
        for i = 1:length( plots )
            Enr( i ) = electrodeLookup( plots( i ) );
        end

%% Load the EEG data!
    % Loading electrode location
        EEG = pop_chanedit( STARTEEG, 'load',{ [PATH_EEGLAB 'elpos64_goed.loc' ] 'filetype' 'autodetect'} );
        EEG = eeg_checkset( EEG );

    % Read the dataset
        EEG = pop_loadset( 'filename', [ char( EPs( FileNr ) ) '.set' ], 'filepath', PATH_EPOCH );
        EEG = eeg_checkset( EEG );

    % Reference to FZ
        EEG = pop_reref( EEG, ReferenceNrs );
        EEG.setname = [ EPs( FileNr ) ' Fz' ];
        EEG = eeg_checkset( EEG );

        tmpRefNRs = '';
        for i=1:length( Reference )
            tmpRefNRs = [ tmpRefNRs Reference( i ) ];
        end

%% Make picachu!
        if MakeERP == 1
            for i = 1:length( plots )
                figure;
                pop_erpimage( EEG, 1, Enr( i ), [], [], 10, 1, {}, [], '', 'yerplabel', '\muV', 'erp', 'on', 'limits', [-200 ERP_timeStop ERP_Ylim NaN NaN NaN NaN] ,'cbar','on','caxis',[-30 30] ,'spec',[1 35] ,'topo', { Enr( i ) EEG.chanlocs EEG.chaninfo } );
                title(gca, [ char( EPs( FileNr ) ) ' ' char( plots( i ) ) ' FZ' ] )
                for z = 1:length( output )
                    saveas(gca, [ PATH_RESULTS char( upper( output( z ) ) ) '\EPR_' char( tmpRefNRs ) '_' char( EPs( FileNr ) ) '_' char( plots( i ) ) '.' char( output( z ) ) ] );
                end
                close;
            end
        end
%}
%% Determine what epoches to use...
        clear EStop EStart;

        if( EpochStop < EpochStart )
            error( 'EpochStop is bigger than EpochStart. You are weird!' );
        end

        if EpochStop == 0
            EStop = EEG.trials;
        else
            EStop = EpochStop;
        end

        if EpochStart == 0
            EStart = 1;
        else
            EStart = EpochStart;
        end

%% Make the plot
        if MakePlot == 1
            for ii = 1:length( Enr )
                for iii = 1:length( EEG.times )
                    pica( iii ) = sum( EEG.data( Enr( ii ), iii, EStart:EStop ) );
                end
                plot( EEG.times, pica ./ ( ( EStop - EStart ) + 1), char( EPsColour( EPsColourNr ) ) );
                EPsColourNr = (EPsColourNr + 1);
                ylim( [-10 10] );
                PLOTlegend = cat(1, PLOTlegend, [ char( EPs( FileNr ) ) ' ' char( plots( ii ) ) ] );
                hold on
            end
        end

        clear EEG;
    end
    title( IMGTitle );
    xlabel( 'Time' );
    ylabel( 'Intensity' );

% Save and show the image
    legend( PLOTlegend );
    for z = 1:length( output )
        PlotName = [ PATH_RESULTS char( upper( output( z ) ) ) '\PLOT_' FileName '.' char( output( z ) ) ];

    % Dont automaticaly overwrite the file!
        fExist = exist( PlotName, 'file' );
        if fExist(1) == 0
            saveas(gca, PlotName );
        else
            if questdlg( 'De file bestaat al: Overschrijven?', 'Save the cows!', 'Graag', 'ik ben Belg', 'Graag' )
                saveas(gca, PlotName );
            end
        end
    end
    close all;

%% Stop the timer!
    toc