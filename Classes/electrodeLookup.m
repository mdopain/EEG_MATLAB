% Electrode name to number conversion table
%   
%   
%   
%   Written by: Daniël Groothuysen 2012 
%   Fixed by JB
%   

function num = electrodeLookup( electrode )
% List all Electrodes
    names = {'FP1','FPZ','FP2','F7','F3','FZ','F4','F8','FC5','FC1','FC2','FC6','M1','T7','C3','CZ','C4','T8','M2','CP5','CP1','CP2','CP6','P7','P3','Pz','P4','P8','POZ','O1','Oz','O2','AF7','AF3','AF4','AF8','F5','F1','F2','F6','FC3','FCz','FC4','C5','C1','C2','C6','CP3','CPZ','CP4','P5','P1','P2','P6','PO5','PO3','PO4','PO6','FT7','FT8','TP7','TP8','PO7','PO8'};
    num = 0;

% Upper case the shizzle
    electrode = upper( electrode );

% Make a matrix containing the number of the electrode
    numbers = [1:64];

% Make an ARRAY containging the numbers and the names of the electrode
    mapToNum = containers.Map( names, numbers );

% Check if the given electrode exists in the array 
    if isKey( mapToNum, electrode )

    % Save the number of the given electrode
        num = mapToNum( char( electrode ) );
    else
    
    % The electrode could not be found, show a message.
        disp( [ 'ElectrodeLookup: Given Electrode not found: ' char( electrode ) ] );
    end

% Garbage collector!
    clear names mapToNum electrode