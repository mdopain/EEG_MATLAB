% Declaring path variables. End the string with a "\"
global PATH_WRKDIR PATH_SCRIPTS PATH_DATA PATH_EEGLAB PATH_RESULTS
PATH_WRKDIR     = 'C:\Users\Paul\Desktop\Matlab MDO\';
PATH_SCRIPTS    =  PATH_WRKDIR;
PATH_DATA       =  [ PATH_WRKDIR 'data\'] 
PATH_EEGLAB     = [ PATH_WRKDIR 'eeglab10_2_5_8b\' ];
PATH_RESULTS    = [ PATH_WRKDIR 'Results\' ];

if ~exist('C:\pathsave','dir')
    mkdir('C:\pathsave')
end

save('C:\pathsave\pathsave.mat');