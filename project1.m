function varargout = project1(varargin)
% PROJECT1 M-file for project1.fig
%      PROJECT1, by itself, creates a new PROJECT1 or raises the existing
%      singleton*.
%
%      H = PROJECT1 returns the handle to a new PROJECT1 or the handle to
%      the existing singleton*.
%
%      PROJECT1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT1.M with the given input arguments.
%
%      PROJECT1('Property','Value',...) creates a new PROJECT1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project1

% Last Modified by GUIDE v2.5 05-Oct-2018 16:49:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project1_OpeningFcn, ...
                   'gui_OutputFcn',  @project1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before project1 is made visible.
function project1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project1 (see VARARGIN)

% Choose default command line output for project1
handles.output = hObject;
handles.robot = [];                  % Our 3-axis manipilator 
handles.theta1 = 0;                  % Joint angle 1 creation (used for the slider)
handles.theta2 = 0;             	 % Joint angle 2 creation (used for the slider)
handles.theta3 = 0;                  % Joint angle 3 creation (used for the slider)
set(handles.x, 'String', 0);         % End-effector X position 
set(handles.y, 'String', 0);         % End-effector Y position 
set(handles.z, 'String', 0);         % End-effector Z position 
set(handles.joint1, 'String', 0);    % Auxiliary variable for Joint 1 (used for text box input and output
set(handles.joint2, 'String', 0);    % Auxiliary variable for Joint 2 (used for text box input and output
set(handles.joint3, 'String', 0);    % Auxiliary variable for Joint 3 (used for text box input and output
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Create.
function Create_Callback(hObject, eventdata, handles)
% hObject    handle to Create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%link creation 
L(1) = Revolute('d', 0.0548, 'a', 0.0009, 'alpha', 0.0007, 'offset', -0.2699, 'modified','qlim',[-87*pi/180,120*pi/180]);
L(2) = Revolute('d', 0.0359, 'a', 0.1084, 'alpha', 0.002, 'offset', 0.2373, 'modified','qlim',[-159*pi/180,38.5*pi/180]);
L(3) = Revolute('d', -0.0011, 'a', 0.1, 'alpha', -1.555,'offset',-0.0002, 'modified','qlim',[-123*pi/180,40*pi/180]);
handles.robot = SerialLink(L,'base',[-0.132,0.135,0],'tool',[0,0.086,0.0215],'name', 'robot');
axes(handles.axes4); %sets the active axis (1) for plotting
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3],'view', [0 45]); %Plots the robot with an azimuthal angle of 0 deg and and elevation of 45 deg 
axes(handles.axes5); %sets the active axis (2) for plotting
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3],'view', [270 45]); %Plots the robot with an azimuthal angle of 270 deg and and elevation of 45 deg
axes(handles.axes3); %sets the active axis (3) for plotting
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3],'view', [-90 90]); %Plots the robot with an azimuthal angle of -90 deg and and elevation of 90 deg
T = handles.robot.fkine ([handles.theta1, handles.theta2, handles.theta3]); % Forward kinamtics using the initial values of the joint angles
set(handles.x, 'String', T.t(1)); % Extracts the X component of the end-effector position from the transformation matrix
set(handles.y, 'String', T.t(2)); % Extracts the Y component of the end-effector position from the transformation matrix
set(handles.z, 'String', T.t(3)); % Extracts the Z component of the end-effector position from the transformation matrix

% Update handles structure
guidata(hObject, handles);
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.theta1 = get (hObject,'Value'); %returns position of slider in radians to theta 1 
set(handles.joint1, 'String', handles.theta1*180/pi); % displays value of theta 1 in Deg
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3]); % Plots the new configuration
T = handles.robot.fkine ([handles.theta1, handles.theta2, handles.theta3]); % Forward kinamtics using the updated value of theta 1
set(handles.x, 'String', T.t(1)); % Extracts the X component of the end-effector position from the transformation matrix
set(handles.y, 'String', T.t(2)); % Extracts the Y component of the end-effector position from the transformation matrix
set(handles.z, 'String', T.t(3)); % Extracts the Z component of the end-effector position from the transformation matrix
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.theta2 = get(hObject, 'Value');
set(handles.joint2, 'String', handles.theta2*180/pi);
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3]);
T = handles.robot.fkine ([handles.theta1, handles.theta2, handles.theta3]);
set(handles.x, 'String', T.t(1));
set(handles.y, 'String', T.t(2));
set(handles.z, 'String', T.t(3));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.theta3 = get(hObject, 'Value');
set(handles.joint3, 'String', handles.theta3*180/pi);
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3]);
T = handles.robot.fkine ([handles.theta1, handles.theta2, handles.theta3]);
set(handles.x, 'String', T.t(1));
set(handles.y, 'String', T.t(2));
set(handles.z, 'String', T.t(3));
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function joint1_Callback(hObject, eventdata, handles)
% hObject    handle to joint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of joint1 as text
%        str2double(get(hObject,'String')) returns contents of joint1 as a double
handles.theta1 = str2num(get(handles.joint1, 'String'))*pi/180; % Extracts date from the text box and converts it to a number in radians
% Checks if the input angle is out of range. If so, set the angle to either
% upper limit or lower limit depending on the sign.
if(handles.theta1 < handles.robot.qlim(1,1) || handles.theta1 > handles.robot.qlim(1,2))
    if(handles.theta1 > 0)
        handles.theta1 = handles.robot.qlim(1,2);
    else
        handles.theta1= handles.robot.qlim(1,1);
    end
    set(handles.joint1, 'String', handles.theta1*180/pi);
end
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3]);
T = handles.robot.fkine ([handles.theta1, handles.theta2, handles.theta3]);
set(handles.x, 'String', T.t(1));
set(handles.y, 'String', T.t(2));
set(handles.z, 'String', T.t(3));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function joint1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to joint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of joint2 as text
%        str2double(get(hObject,'String')) returns contents of joint2 as a double
handles.theta2 = str2num(get(handles.joint2, 'String'))*pi/180;
if(handles.theta2 < handles.robot.qlim(2,1) || handles.theta2 > handles.robot.qlim(2,2))
    if(handles.theta2 > 0)
        handles.theta2 = handles.robot.qlim(2,2);
    else
        handles.theta2= handles.robot.qlim(2,1);
    end
    set(handles.joint2, 'String', handles.theta2*180/pi);
end
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3]);
T = handles.robot.fkine ([handles.theta1, handles.theta2, handles.theta3]);
set(handles.x, 'String', T.t(1));
set(handles.y, 'String', T.t(2));
set(handles.z, 'String', T.t(3));
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function joint2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function joint3_Callback(hObject, eventdata, handles)
% hObject    handle to joint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of joint3 as text
%        str2double(get(hObject,'String')) returns contents of joint3 as a double
handles.theta3 = str2num(get(handles.joint3, 'String'))*pi/180;
if(handles.theta3 < handles.robot.qlim(3,1) || handles.theta3 > handles.robot.qlim(3,2))
    if(handles.theta3 > 0)
        handles.theta3 = handles.robot.qlim(3,2);
    else
        handles.theta3= handles.robot.qlim(3,1);
    end
    set(handles.joint3, 'String', handles.theta3*180/pi);
end
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3]);
T = handles.robot.fkine ([handles.theta1, handles.theta2, handles.theta3]);
set(handles.x, 'String', T.t(1));
set(handles.y, 'String', T.t(2));
set(handles.z, 'String', T.t(3));
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function joint3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_Callback(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x as text
%        str2double(get(hObject,'String')) returns contents of x as a double


% --- Executes during object creation, after setting all properties.
function x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_Callback(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y as text
%        str2double(get(hObject,'String')) returns contents of y as a double


% --- Executes during object creation, after setting all properties.
function y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_Callback(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z as text
%        str2double(get(hObject,'String')) returns contents of z as a double


% --- Executes during object creation, after setting all properties.
function z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
