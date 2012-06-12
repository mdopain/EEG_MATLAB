% Electrode name to number conversion table
%   
%   
%   
%   Written by: Daniël Groothuysen 2012 
%   Fixed by JB
%   

function num = electrodeLookup( electrode )
% List all Electrodes
    names = {'fp1','fpz','fp2','f7','f3','fz','f4','f8','fc5','fc1','fc2','fc6','m1','t7','c3','cz','c4','t8','m2','cp5','cp1','cp2','cp6','p7','p3','pz','p4','p8','poz','o1','oz','o2','af7','af3','af4','af8','f5','f1','f2','f6','fc3','fcz','fc4','c5','c1','c2','c6','cp3','cpz','cp4','p5','p1','p2','p6','po5','po3','po4','po6','ft7','ft8','tp7','tp8','po7','po8','Fp1','Fpz','Fp2','F7','F3','Fz','F4','F8','FC5','FC1','FC2','FC6','M1','T7','C3','Cz','C4','T8','M2','CP5','CP1','CP2','CP6','P7','P3','Pz','P4','P8','POz','O1','Oz','O2','AF7','AF3','AF4','AF8','F5','F1','F2','F6','FC3','FCz','FC4','C5','C1','C2','C6','CP3','CPz','CP4','P5','P1','P2','P6','PO5','PO3','PO4','PO6','FT7','FT8','TP7','TP8','PO7','PO8'};

% Make a matrix containing the number of the electrode
    numbers = [1:64 1:64];

% Make an ARRAY containging the numbers and the names of the electrode
    mapToNum = containers.Map( names, numbers );

% Check if the given electrode exists in the array 
    if isKey( mapToNum, electrode )

    % Save the number of the given electrode
        num = mapToNum( char( electrode ) );
    else
    
    % The electrode could not be found, show a message.
        disp( 'ElectrodeLookup: Given Electrode not found!' );
    end

% Garbage collector!
    clear names mapToNum electrode