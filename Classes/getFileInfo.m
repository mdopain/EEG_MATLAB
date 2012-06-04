function [ trigfile, cntfile, name, date, trigNr, meting ] = getFileInfo( trigNr, meting, dag, PATH_DATA )

% Deelnemers:
% 101: Daniel
% 102: Paul
% 999: Jeffrey
% 104: Ruurd
% 110: Niek
% 111: ???
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
        name='Daniel Groothuyssen';
    case 102
        name='Paul Jonkers';
    case 999
        name='Jeffrey Benistant';
    case 104
        name='Ruurd de Schipper';
    case 110
        name='Niek Prins';
    case 111
        name='Juriaan Brandts';
% Is dit trouwens de naam en casenr van die dude?

switch dag
    case 1
        date = '25.05';
    case 2
        date = '30.05';
end

trigfile = [ PATH_DATA date '.' int2str( trigNr ) '.' meting '.Daniel.trg'];
cntfile  = [ PATH_DATA date '.' int2str( trigNr ) '.' meting '.Daniel.cnt'];

fExist = exist( cntfile, 'file' );
if fExist(1) == 0
	disp(['getFileInfo: Trig-File does not exist:' trigfile]);
end

fExist = exist( cntfile, 'file' );
if fExist(1) == 0

    disp(['getFileInfo: CNT-File does not exist:' cntfile]);
end

