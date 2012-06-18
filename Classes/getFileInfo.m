function [ trigfile, cntfile, FullName, Name, date, trigNr, meting ] = getFileInfo( trigNr, meting, dag, PATH_DATA )

% Deelnemers:
% 101: Daniel
% 102: Paul
% 999: Jeffrey
% 104: Ruurd
% 110: Niek
% 111: Juriaan Brands
% 112: ???
% 113: Thijs van den Broek
%
% Meting: 1L, 1R, 2L, 2R, 4L, 4R, 8L, 8R
%
% Dag: 1 / 2 / 3 / 4 / 5 / 6 / 7 / 8
%
% PATH_DATA: Path to the data directory

% Get the path, if none is given display it
    if PATH_DATA == 0
        PATH_DATA = '';
        disp( 'getFileInfo: No path given.' );
    end

% Preset info
    Name = '';
    FullName = '';

% Find the corresponding name and fullName by the Trigger number
    switch trigNr
        case 101
            Name = 'Daniel';
            FullName = 'Daniel Groothuysen';
        case 102
            Name = 'Paul';
            FullName = 'Paul Jonkers';
        case 231
            Name = 'Jeffrey';
            FullName = 'Jeffrey Benistant';
        case 104
            Name = 'Ruurd';
            FullName = 'Ruurd de Schipper';
        case 110
            Name = 'Niek';
            FullName = 'Niek Prins';
        case 111
            Name = 'Juriaan';
            FullName = 'Juriaan Brands';
        case 112
            Name = 'Rienco';
            FullName = 'Rienco Muilwijk';
        case 113
            Name = 'Thijs';
            FullName = 'Thijs van den Broek';
        otherwise
            disp('Shit! Cannot find the name...')
    end

% find the corresponding date by the daynumber
    switch dag
        case 1
            date = '25.05';
        case 2
            date = '30.05';
        case 3
            date = '01.06';
        case 4
            date = '06.06';
        case 5
            date = '08.06';
        case 6
            date = '14.06';
        case 7
            date = '15.06';
        case 8
            date = '19.06';
    end

% Make a string containing the paths to the files
    trigfile = [ PATH_DATA date '.' int2str( trigNr ) '.' meting '.' Name '.trg'];
    cntfile  = [ PATH_DATA date '.' int2str( trigNr ) '.' meting '.' Name '.cnt'];

% Check if the TRIGfile exists
    fExist = exist( trigfile, 'file' );
    if fExist(1) == 0
        disp(['getFileInfo: Trig-File does not exist:' trigfile]);
    end

% Check if the CNTfile exists
    fExist = exist( cntfile, 'file' );
    if fExist(1) == 0
        disp(['getFileInfo: CNT-File does not exist:' cntfile]);
    end

% Garbage collector!
    clear dag PATH_DATA
