    clear all; close all; clc;
%%
cd G:\MDO\Analyse\GuiMarleen

user='Marjanne';
if strcmp(user,'Marjanne')
    mainfolder='G:\MDO\Results\';  % Select mainfolder 
elseif strcmp(user,'Cecile')
    mainfolder='G:\MDO\Results\';  % Select mainfolder     
end

labelFolder=[mainfolder,'Labels\'];
saveFolder=[labelFolder,'\'];
load('G:\MDO\Results\listCP3FZ.mat' )

N=size(list,1); % Randomize SSEPs
[~,order]=sort(randn(1,N));
list=list(order,:);

for i=1:N %i=1:N % start SSEP GUI
    disp([num2str(N+1-i), ' SSEPs to go'])
    k=list{i,1};
    name=list{i,2};
    name_wth_nr=list{i,3};
    setting=list{i,4};
    vas=list{i,5};
    vas_pep=list{i,6};
    data=mean(list{i,7}'); %gemiddelde van alle trials

    SSEPgui(k,name,name_wth_nr,setting,vas,vas_pep,data,user,saveFolder)
    uiwait()
end



    
    
    

