function varargout = SSEPgui(varargin)
%      SSEPGUI M-file for SSEPgui.fig
%      SSEPGUI, by itself, creates a new SSEPGUI or raises the existing
%      singleton*.
%
%      H = SSEPGUI returns the handle to a new SSEPGUI or the handle to
%      the existing singleton*.
%
%      SSEPGUI('Property','Value',...) creates a new SSEPGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to SSEPgui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SSEPGUI('CALLBACK') and SSEPGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SSEPGUI.M with the given input
%      arguments.
%
%      *See GUI dervs on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SSEPgui

% Last Modified by GUIDE v2.5 29-Feb-2012 21:34:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SSEPgui_OpeningFcn, ...
                   'gui_OutputFcn',  @SSEPgui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before SSEPgui is made visible.
function SSEPgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

global pEP results user ymax saveFolder 

% SSEPgui(k,name,name_wth_nr,setting,vas,vas_pep,data,user,saveFolder)

% Input
pEP.k=varargin(1);
pEP.name=varargin(2);
pEP.name_wth_nr=varargin(3);
pEP.setting=varargin(4);
pEP.vas=varargin(5);
pEP.vas_pep=varargin(6);
pEP.data=varargin(7);
user=varargin(8);
saveFolder=varargin(9);    

% Inititate
results.noise=0;
results.absent=0;
results.PlateN=0;
results.NlateN=0;
results.xy=zeros(2,8);
results.remarks=[];
results.vas=pEP.vas;

ymax=8;
plotSSEP();

% Choose default command line output for SSEPgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SSEPgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = SSEPgui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Baseline
function Baseline_Callback(hObject, eventdata, handles)
% hObject    handle to Absent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
[xi,yi,but] = ginput(1); 
if but==1                                            
    results.xy(1:2,1) = [xi;yi]; 
    plotSSEP()
end

% --- Executes on button press in N20
function N20_Callback(hObject, eventdata, handles)
% hObject    handle to Noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
[xi,yi,but] = ginput(1);                                               
if but==1                                            
    results.xy(1:2,2) = [xi;yi];          
    plotSSEP()
end

% --- Executes on button press in P30.
function P30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
[xi,yi,but] = ginput(1);                                               
if but==1                                            
    results.xy(1:2,3) = [xi;yi]; 
    plotSSEP()
end

% --- Executes on button press in N35.
function N35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
[xi,yi,but] = ginput(1);                                               
if but==1                                            
    results.xy(1:2,4) = [xi;yi];       
    plotSSEP()
end

% --- Executes on button press in P45.
function P45_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
[xi,yi,but] = ginput(1);                                               
if but==1                                            
    results.xy(1:2,5) = [xi;yi];         
    plotSSEP()
end

% --- Executes on button press in Pcombi.
function Pcombi_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
[xi,yi,but] = ginput(1);                                               
if but==1                                            
    results.xy(1:2,6) = [xi;yi]; 
    plotSSEP()
end

% --- Executes on button press in Plate.
function Plate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
[xi,yi,but] = ginput(1);
if but==1                                            
    results.PlateN=results.PlateN+1; 
    results.xy(1:2,5+2*results.PlateN) = [xi;yi]; 
    plotSSEP()
end

% --- Executes on button press in Nlate.
function Nlate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
[xi,yi,but] = ginput(1);
if but==1                                            
    results.NlateN=results.NlateN+1;
    results.xy(1:2,6+2*results.NlateN) = [xi;yi]; 
    plotSSEP()
end

% --- Executes on button press in Noise checkbox
function Noise_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
results.noise=get(hObject,'Value');

% --- Executes on button press in Absent checkbox
function Absent_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
results.absent=get(hObject,'Value');

% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results user pEP saveFolder
% if results.absent==0 && results.noise==0 && results.xy(1,2)==0 &&results.xy(2,2)==0&& results.xy(3,2)==0
%     warndlg('Place markers first or select one of the "No markers" checkboxes');
% % elseif (min(min(results.xy))~=0 || max(max(results.xy))~=0) && results.xy(1,1)==0 && results.xy(2,1)==0
% %     warndlg('Select baseline first');
% else
    save([saveFolder{:}, num2str(pEP.name_wth_nr{:}),num2str(pEP.setting{:}),'.mat'],'results','user')
    close
%end

% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles,pEP)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
results.noise=0; set(handles.checkbox2,'Value',0)
results.absent=0; set(handles.checkbox3,'Value',0)
results.PlateN=0; 
results.NlateN=0;
results.xy=zeros(2,8);
plotSSEP()

function Remarks_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global results
results.remarks=get(hObject,'String');


% --- Executes on button press in minus button
function Plus_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ymax
ymax=ymax-1;
plotSSEP()

% --- Executes on button press in plus button
function Minus_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ymax
ymax=ymax+1;
plotSSEP()



function plotSSEP()
% Get data and initiate
global pEP results ymax t
t=[-200:1:499];
%Marker={'B','N20','P30','N35','P45','P30-45'};
data=pEP.data{:};
setting=pEP.setting{:};
channels=size(data,2);     
dataSum=zeros(500,1);
name_wth_nr=pEP.name_wth_nr{:};


bmin=4; bmax=14;
plot([bmin bmax+1],[ymax ymax],'k')
plot([bmin bmax+1],[-ymax -ymax],'k')

xlabel('time (ms)')
ylabel('Cortical (\muV)')
ylim([-ymax ymax])
xlim([-200 500])
box on         

plot(t,data,'k','linewidth',2)
        nullijn=zeros(1,length(t));
        inul=find(t==0);
        hold on
        plot(t,nullijn, 'Color',[0.6 0.6 0.6])
        hold on
        line([t(inul) t(inul)],[-ymax ymax], 'Color',[0.6 0.6 0.6]);
        hold on
%set(gca,'ydir','reverse')

% Plot Markers
for i=1:6
    if ~(results.xy(1,i)==0 && results.xy(2,i)==0)
        x=results.xy(1,i); 
        y=find(t>=x); y=data(y(1));
        results.xy(2,i)=y; 
        plot(x, y,'r*')
    end
end
for i=1:results.NlateN
    x=results.xy(1,6+2*i); 
    y=find(t>=x); y=data(y(1));
    results.xy(2,6+2*i)=y; 
    plot(x,y,'r*')
    disp(['N', num2str(i)])
end
for i=1:results.PlateN
    x=results.xy(1,5+2*i); 
    y=find(t>=x); y=dataMean(y(1)); 
    results.xy(2,5+2*i)=y; 
    plot(x,y,'r*')
    text(x, y-(ymax/8),['P', num2str(i)],'color','r')
end
hold off 

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showcolorerp1.
function showcolorerp1_Callback(hObject, eventdata, handles)
global pEP

try
open(['G:\MDO\Results\',pEP.name{:}, '\', pEP.name_wth_nr{:}, num2str(pEP.setting{:}),' rej_CP3_FZ.fig'])
set(gca,'Title',text('String',''))
catch
    try
        open(['G:\MDO\Results\',pEP.name{:}, '\', pEP.name_wth_nr{:}, num2str(pEP.setting{:}),'_CP3_FZ.fig'])
        set(gca,'Title',text('String',''))
    catch
    disp(['G:\MDO\Results\',pEP.name{:}, '\', pEP.name_wth_nr{:}, num2str(pEP.setting{:}),'_CP3_FZ.fig not found'])
    end
end
    


% --- Executes on button press in ExtraFig.
function ExtraFig_Callback(hObject, eventdata, handles)
global pEP

    try
       
    uiopen(['G:\MDO\Results\',pEP.name{:}, '\', pEP.name_wth_nr{:},'_all_ERPs_CP3FZ.fig'],1)
    set(gca,'Title',text('String',''))
    catch
        try
            uiopen(['G:\MDO\Results\',pEP.name{:}, '\', pEP.name_wth_nr{:}, '_all_ERPs_CP3FZ.fig'],1)
            set(gca,'Title',text('String',''))
        catch
            disp(['G:\MDO\Results\',pEP.name{:}, '\', pEP.name_wth_nr{:}, '_all_ERPs_CP3FZ.fig not found'])
        end
    end
    
guidata(hObject, handles);