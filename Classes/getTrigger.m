function trig = getTrigger( trigfile, trigNr )


% Read a trigger file and sort all trigger indices per trigger type.
% param1: Array of chars - Location of the trigger file.
% param2: integer - Triggernumber.

% Test if the file exists.
    Fexist = exist( trigfile, 'file' );
    if Fexist == 0
        disp( 'Trigger file does not exist:' );
        disp( trigfile );
    end

% Read the EEP trigger file.
    trg = read_eep_trg( trigfile );

% tr1 is the matrix with all trigger times
    tr1 = [trg(:).time]';

% tr2 is the matrix with all trigger types
    tr2 = [trg(:).type]';

% tr is the matrix with all trigger times and types
    tr = [tr1, tr2];

% ind is a matrix, containing all "times" a trigger with number "meting" occured
    ind = (tr(:,2) == trigNr);

% Sort all trigger times and save them to trig.t
    trig.t = round(tr(ind,1));