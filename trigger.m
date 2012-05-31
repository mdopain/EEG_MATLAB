function trig = trigger(trg)

% Sorts all trigger indices per trigger
% Edited by Marjanne Bom, November 2011
% Daphne Mulders, January 2011
% Edited by Erik te Woerd, March 2
% Written by011


tr1 = [trg(:).time]';                 % tr1 is the matrix with all trigger times
tr2 = [trg(:).type]';                 % tr2 is the matrix with all trigger types

tr = [tr1, tr2];                      % tr is the matrix with all trigger times and types

% ind38 = find(tr(:,2) == 38);    
ind38 = tr(:,2) == 38;              % ind38 is matrix met alle posities van tr waar 38 staat
trig.t38 = round(tr(ind38,1));      % trig.t38 is matrix met alle type 38 trigger times gesorteerd