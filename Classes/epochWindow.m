% Function to window an epoch, that is to say; to convert every value
% outside the specified window to zero.

% Inputs are:
% epoch:        The epoch to be windowed
% min:          The point in time from which the window starts. Watch out!!
%               this is an INDEX OF THE EPOCH, not an actual time (first add the number
%               of milliseconds before the stimulus!)
% max:          Same story as min.
% 
% 
% Output is the windowed epoch.

function [windowedEpoch] = epochWindow(epoch,min,max)

windowedEpoch = zeros(length(epoch));

for j=1:length(epoch)
    outOfWindow = (j<=min) || (j>=max);
             if outOfWindow
                windowedEpoch(j) = 0;
             else
                windowedEpoch(j) = epoch(j);
             end
end