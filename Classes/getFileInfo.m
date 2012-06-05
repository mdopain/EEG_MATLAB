function [ trigfile, cntfile, FullName, date, trigNr, meting ] = getFileInfo( trigNr, meting, dag, PATH_DATA )

% Deelnemers:
% 101: Daniel
% 102: Paul
% 999: Jeffrey
% 104: Ruurd
% 110: Niek
% 111: Juriaan Brands
%
% Meting: 1L, 1R, 2L, 2R, 4L, 4R, 8L, 8R
%
% Dag: 1 / 2 / 3 / 4

if PATH_DATA == false
    PATH_DATA = '';
    disp( 'getFileInfo: No path given.' );
end

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
end

switch dag
    case 1
        date = '25.05';
    case 2
        date = '30.05';
end

trigfile = [ PATH_DATA date '.' int2str( trigNr ) '.' meting '.' Name '.trg'];
cntfile  = [ PATH_DATA date '.' int2str( trigNr ) '.' meting '.' Name '.cnt'];

fExist = exist( trigfile, 'file' );
if fExist(1) == 0
	disp(['getFileInfo: Trig-File does not exist:' trigfile]);
end

fExist = exist( cntfile, 'file' );
if fExist(1) == 0
    disp(['getFileInfo: CNT-File does not exist:' cntfile]);
end