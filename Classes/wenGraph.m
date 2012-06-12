% Function to generate the gewenningsgrafiek. 

% Inputs:
% ---------------------------------------------
% eeg:              EEG data as outputted by EEGLAB
% average:          desired 'epoch resolution'; number of epochs to average per
%                   data point.
% electrode:       channel number of electrode to be used.
% 
% Outputs:
% ---------------------------------------------
% graphData:        array containing epoch numbers in the first column, and
%                   corresponding max-min differences in the second. 


function [graphData,minValues,maxValues]=wenGraph(eeg,average,electrode)

hold on
 
 window=[0.100 0.600];
 epochNum=length(eeg.data(electrode,1,:));
 
 % The following variables have as their first column the 
 minValues=zeros(epochNum,2);
 maxValues=zeros(epochNum,2);
 minValAvg=zeros(epochNum,2);
 maxValAvg=zeros(epochNum,2);
 
 averageEpoch=zeros(length(eeg.data(electrode,:,1)));
 
 graphData=zeros(floor(epochNum/average),2);
 
 timeBeforePulse=200;
 
 n=1;       % Counter for the number of datapoints
 
 
 % This loop goes from one to the number of epochs in the dataset. 
 for i=1:epochNum
     
     % 'reset' is a boolean which detects if the loop variable i is a
     % multiple of the variable 'average'. 
     reset = mod(i,average)==0;
     if reset
         figure;
         title(['from ' num2str(i) ' to ' num2str(i+9)])
     end
     
     subplot(3,4,mod(i,10)+1)
     currentEpoch = eeg.data(electrode,:,i);
     
     % If the specified number of epochs to mediate over (saved in the
     % variable 'average') has not yet been reached, the if statement gets
     % executed. Otherwise, see else. 
     if ~reset
         averageEpoch(n,:)=averageEpoch(n,:)+currentEpoch;
     else
         % This code saves the minimum and maximum of the past number of
         % averaged epochs, to hopefully select the EP peaks. 
         [minValAvg(n,1),minValAvg(n,2)]=min(averageEpoch(n,:));
         [maxValAvg(n,1),maxValAvg(n,2)]=max(averageEpoch(n,:));
         
         % It then saves the epoch number in an array called 'graphData',
         % where the NP-amplitude (difference between maximum and minimum)
         % also gets stored.
         graphData(n,1)=i;
         graphData(n,2)=maxValAvg(n,1)-minValAvg(n,1);
         n=n+1;
         averageEpoch(n,:)=currentEpoch;
     end
     
     [minValues(i,1),minValues(i,2)] = min(currentEpoch);
     [maxValues(i,1),maxValues(i,2)]= max(currentEpoch);
     
     % Convert time indices to seconds by subtracting 200 ms
     minValues(i,2)=minValues(i,2)-timeBeforePulse;
     maxValues(i,2)=maxValues(i,2)-timeBeforePulse;
     
     plot(eeg.times,currentEpoch,'g');
     hold on
     plot(minValues(i,2),minValues(i,1),'b*');
     hold on
     plot(maxValues(i,2),maxValues(i,1),'r*');
     
     amplitudes(i) = maxValues(i,1)-minValues(i,1);
     
 end


 figure;
 plot(1:epochNum,amplitudes,'b');
 title(['min-max differences per event in a ' num2str(epochNum) ' epoch paradigm'])
 figure;
 title(['min-max differences averaged in ' num2str(average) '-number bins in a ' num2str(epochNum) ' epoch paradigm','FontSize',25])
 subplot(1,2,1)
 bar(graphData(:,1).',graphData(:,2).');
 subplot(1,2,2)
 plot(graphData(:,1),graphData(:,2));
ylim([0 350])
 
 