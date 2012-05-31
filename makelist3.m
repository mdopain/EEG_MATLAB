clear all
close all 
clc
%%
% met deze m-file wordt een list gemaakt die nodig is voor de SSEP Gui van
% Marleen. Daarnaast worden 'even' wat plaatjes geplot. 

cd G:\MDO\Analyse
tic
i=1;
for k=[22:24];
    persons=k;
for set=[1,2,3] %1=tonisch, 2=burst, 3=uit
    setting=set;
        
    [trigfile,cntfile, name, name_wth_nr]=switchpatients3(persons, setting);
    if length(trigfile)>1   % When trigfile for this setting is present, run code, otherwise, try other setting
    
        switch setting
            case 1    
                vas= xlsread('G:\MDO\Data\VASscores.xlsx',1,['H' num2str(k +5 )]);
                vas_ep= xlsread('G:\MDO\Data\VASscores.xlsx',1,['O' num2str(k+5)]);
            case 2
                vas= xlsread('G:\MDO\Data\VASscores.xlsx',1,['S' num2str(k+5)]);
                vas_ep= xlsread('G:\MDO\Data\VASscores.xlsx',1,['Z' num2str(k+5)]);
            case 3
                vas= xlsread('G:\MDO\Data\VASscores.xlsx',1,['AD' num2str(k+5)]);
                vas_ep= xlsread('G:\MDO\Data\VASscores.xlsx',1,['AK' num2str(k+5)]);
        end
            
        try
            pEP= load(['G:\MDO\Results\', name, '\', name_wth_nr, num2str(setting), '.mat']);
        catch
            disp(['G:\MDO\\Results\', name, '\', name_wth_nr, num2str(setting), '.....mat not found']);
        end

    try
    list{i,1}=k;
    list{i,2}=name;
    list{i,3}=name_wth_nr;
    list{i,4}=setting;
    list{i,5}=vas;
    list{i,6}=vas_ep;
    list{i,7}=pEP.CP3FZ;  %Let op het kanaal dat je kiest.
    i=i+1;
    vas=[];
    catch
    end
    end

    figure(1)
    switch setting
        case 1
            
            try 
                if list{i-1,4}==1
                plot([-200:1:499],zeros(700,1),'Color',[0.6 0.6 0.6])
                hold on
                line([0 0 ],[-3 5], 'Color',[0.6 0.6 0.6]);
                hold on
                plot([-200:1:499], mean(pEP.CP3FZ(:,3:23)'), 'b') 
                title(name_wth_nr)
                text(-100, 2, 'tonic', 'Color', 'b')
                hold on
                else 
            end
            catch
            end
            
        case 2    
            try 
                if list{i-1,4}==2
                plot([-200:1:499],zeros(700,1),'Color',[0.6 0.6 0.6])
                hold on
                line([0 0 ],[-3 5], 'Color',[0.6 0.6 0.6]);
                hold on
                plot([-200:1:499],  mean(pEP.CP3FZ(:,3:23)'), 'r') 
                title(name_wth_nr)
                text(-100, 1, 'burst', 'Color', 'r')
                hold on
                else
            end
            catch
            end
            
        case 3
            
                try
                    if list{i-1,4}==3
                    plot([-200:1:499],zeros(700,1),'Color',[0.6 0.6 0.6])
                    hold on
                    line([0 0 ],[-3 5], 'Color',[0.6 0.6 0.6]);
                    hold on
                    plot([-200:1:499],  mean(pEP.CP3FZ(:,3:23)'), 'k') 
                    %title(name_wth_nr)
                    text(-100, -1, 'off', 'Color', 'k')
                    hold on
                     else
            end
                catch
                end
           
    end
saveas(gcf,['G:\MDO\\',  name_wth_nr ,'_all_ERPs_CP3FZ.fig'])
%saveas(gcf,['G:\MDO\\Results\',  name_wth_nr ,'_all_ERPs.fig'])                    

end %setting aanwezig?
hold off
end %bekijk alle settings
save('G:\MDO\\Results\listCP3FZ.mat', 'list')
toc
%% High vs Low VAS
l=1;
h=1;
i=1;
for i=1:size((list),1)
    if list{i,5} < 50
        EPlowvas(l,:)=mean(list{i,7}(:,:)');
        l=l+1;
    elseif list{i,5}>50
        EPhighvas(h,:)=mean(list{i,7}(:,:)');
        h=h+1;
    end
end

time=[-200:499];
figure(2)
subplot 121
plot(time,EPlowvas(:,:)')
hold on
plot(time,mean(EPlowvas(:,:)),'r','LineWidth', 3)
title('VAS <5')
ylim([-10 40])
subplot 122
plot(time,EPhighvas(:,:)')
hold on
plot(time,mean(EPhighvas(:,:)),'r','LineWidth', 3)
title('VAS >5')
ylim([-10 40])
saveas(gca, 'Peps by VAS CP3FZ.fig')
%% Tonic vs Burst vs OFF
l=1;
h=1;
for i=1:size((list),1)
    if list{i,4} ==1 
        tonic(l,:)=mean(list{i,7}(:,3:23)'); %hier kun je ook kiezen om niet alle 63 stimuli te nemen, maar bijv een deel (zoals 3:23)
        l=l+1;
    elseif list{i,4}==2
        burst(h,:)=mean(list{i,7}(:,3:23)');
        h=h+1;
    elseif list{i,4}==3
        off(h,:)=mean(list{i,7}(:,3:23)');
        h=h+1;
    end
end

time=[-200:499];
figure(5)
subplot 131
plot(time,tonic(:,:)')
hold on
plot(time,mean(tonic),'r','LineWidth', 3)
title('Tonic')
ylim([-10 10])
subplot 132
plot(time,burst')
hold on
plot(time,mean(burst),'r','LineWidth', 3)
title('Burst')
ylim([-10 10])
subplot 133
plot(time,off(:,:)')
hold on
plot(time,mean(off),'r','LineWidth', 3)
title('OFF')
ylim([-10 10])
saveas(gca, 'Peps tonic burst off CP3FZ 3 23.fig')
