% Function to generate the adaptation graph. 
% 
% Syntax: [graphData,minValues,maxValues]=wenGraph(eeg,average,electrode)
% 
% 
% Inputs are as follows:
% eeg:              EEG data as outputted by EEGLAB
% average:          desired 'epoch resolution'; number of epochs to average
%                   per data point.
% electrode:        channel number of electrode to be used.
% 
% 
% 
% Outputs are as follows:
% graphData:        array containing epoch numbers in the first column, and
%                   corresponding max-min differences in the second. 
% minValues:        vector containing all the minimum values with their
%                   respective indices.
% maxValues:        vector containing all the maximum values with their
%                   respective indices.


function [graphData,minValues,maxValues]=wenGraph(eeg,average,electrode)

hold on
 
 t0=200;
 
 % Following settings are the windows wherein to look for minimum and
 % maximum values of the ERPs.
 windowNegative=[100+t0 300+t0];
 windowPositive=[200+t0 500+t0];
 
 epochNum=length(eeg.data(electrode,1,:));
 
 minValues = zeros(epochNum,2);
 maxValues = zeros(epochNum,2);
 minValAvg = zeros(epochNum,2);
 maxValAvg = zeros(epochNum,2);

 averageEpoch=zeros(length(eeg.data(electrode,:,1)));
 
 graphData=zeros(floor(epochNum/average),2);
 amplitudes=zeros(length(epochNum));
 
 subplot_x=4;
 subplot_y=6;
 
 n=1;       % Counter for the number of datapoints
 figure;
  
 % This loop goes from one to the number of epochs in the dataset. 
 for i=1:epochNum
     
     % 'reset' is a boolean which detects if the loop variable i is a
     % multiple of the variable 'average'. 
     reset = mod(i,average)==0;

     currentEpoch = eeg.data(electrode,:,i);

     % If the specified number of epochs to mediate over (saved in the
     % variable 'average') has not yet been reached, the if statement gets
     % executed. Otherwise, see else. 
     if ~reset
         averageEpoch(n,:)=averageEpoch(n,:)+currentEpoch./average;
     else

         % This code saves the minimum and maximum of the 
         % averaged epochs, first windowing them appropriately, hereby
         % hopefully selecting the EP peaks.
         
         epochWindowNeg = epochWindow(averageEpoch(n,:),windowNegative(1),windowNegative(2));
         epochWindowPos = epochWindow(averageEpoch(n,:),windowPositive(1),windowPositive(2));
         
         % The minimum and maximum coordinates are saved, with in the first
         % column the timepoint (not yet converted to actual time!!), and
         % in the second column the height.
         [minValAvg(n,1),minValAvg(n,2)]=min(epochWindowNeg(:));
         [maxValAvg(n,1),maxValAvg(n,2)]=max(epochWindowPos(:));
         
         % Correcting for the discrepancy between index returned by min and
         % max functions, and the actual timeline
         minValAvg(n,2)=minValAvg(n,2)-t0;
         maxValAvg(n,2)=maxValAvg(n,2)-t0;
         
         % It then saves the epoch number in an array called 'graphData',
         % where the NP-amplitude (difference between maximum and minimum)
         % also gets stored.
            graphData(n,1)=i;
            graphData(n,2)=maxValAvg(n,1)-minValAvg(n,1);
            
            % Plotting each averaged number of epochs along with the
            % selected minimum and maximum, to check if the algorithm
            % approximated the correct peaks
            
            if mod(n,subplot_x*subplot_y)==0
                figure;  
            end
            
            subplot(subplot_x,subplot_y,mod(n,subplot_x*subplot_y)+1)
                                    
            fill([windowNegative(1) windowNegative(2)],[minValAvg(n,1) maxValAvg(n,1)],'b');
            fill([windowPositive(1) windowPositive(2)],[minValAvg(n,1) maxValAvg(n,1)],'r');
            
            plot(eeg.times,averageEpoch(n,:),'g');
            
            hold on
            plot(minValAvg(n,2),minValAvg(n,1),'r*');
            plot(maxValAvg(n,2),maxValAvg(n,1),'b*');
            title(['#' num2str(i)])
            hold off
     
            % Saving the difference of max and min values of each event
            % into a separate vector. 
     amplitudes(i) = maxValues(i,1)-minValues(i,1);
         
         n=n+1;
         averageEpoch(n,:)=currentEpoch./average;
     end
     
     [minValues(i,1),minValues(i,2)] =min(currentEpoch(windowNegative(1):windowNegative(2)));
     [maxValues(i,1),maxValues(i,2)]= max(currentEpoch(windowPositive(1):windowPositive(2)));
     
     % Convert timepoint indices to seconds by subtracting elapsed ms at
     % triggertime
     minValues(i,2)=minValues(i,2)-t0;
     maxValues(i,2)=maxValues(i,2)-t0;
   
     amplitudes(i) = maxValues(i,1)-minValues(i,1);
     
 end

 % Plotting the results
 figure;
 subplot(2,2,1:2);
 plot(1:epochNum,amplitudes,'b');
 title(['min-max differences per event in a ' num2str(epochNum) ' epoch paradigm'],'FontSize',15)
  
 subplot(2,2,3)
 bar(graphData(:,1).',graphData(:,2).');
 title(['min-max differences averaged in ' num2str(average) '-epoch bins in a ' num2str(epochNum) ' epoch paradigm'],'FontSize',15)
 xlabel('Epoch bins')
 ylabel('Averaged NP-amplitude in \muV')
 
 
 subplot(2,2,4)
 plot(graphData(:,1),graphData(:,2));
ylim([0 350])
title('The same data, plotted as a graph','FontSize',15)
 
 