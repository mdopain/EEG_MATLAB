%   makeMontage
%
%       Function to calculate a new montage from an eeg signal.
%
%       Expects input from read_eep_cnt(), requires electrodeLookup.m
%
%   Written by Daniël Groothuysen 2012
%   Fixed by JB
%
%       Inputs are the raw EEG, a string array 'electrodeNames' which
%       contains the electrodes you want to make a montage to, and a
%       boolean 'all' to give the option to make a montage to the average
%       of all electrodes.
%
%       Output is the newly calculated montage.


%function [EEGmontage] = makeMontage( eeg, electrodeNames, all )
electrodeNames = 'Fz';
all = 0;

electrodeNames = cellstr( electrodeNames );
n = length(electrodeNames);
electrodeNumbers = zeros(n);
montageValue = 0;

% First, the channel numbers corresponding to the electrode names in the
% string are resolved using electrodeLookup().

for i = 1:n;
    electrode = electrodeNames(i)
    electrode = char( electrode );
    electrodeNumbers(i) = electrodeLookup( electrode );
end

% The vector which gets subtracted from the signal, gets calculated. An
% average of all the electrodes are used when the boolean 'all' is true.

if all == 1
    for i = 1:64
        montageValue = montageValue + (1/64) .* eeg(i,:);
    end
else
    for i = 1:n
        montageValue = montageValue + (1/n) .* eeg( electrodeNumbers( i ),:);
    end
end

% Then, for every channel in the EEG, this montageValue gets subtracted
% from the signal, resulting in the EEGmontage array.

EEGmontage = zeros( 64, length( eeg(i,:) ) );

for i=1:64
    EEGmontage(i) = eeg(i,:) - montageValue;
end

clear eeg
