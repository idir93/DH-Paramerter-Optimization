function Error = ObjFunny(dh_parameters,Num_Links)
%ObjFunny is a function that will take in a vector of dh parameters and
%will return the error from the measured values.

%INPUTS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dh_parameters: A vector that contains the dh parameters of the links.%
%                                   This vector must be in the form
%                                   [d,a,alpha,offset] (offset is optional
%                                   and will be figured out automatically if included)
% Num_Links: This is the number of links the robot has. This variable is %
%                            used to determine if offset values are specified                   %
%END INPUTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

%FILE READING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
Actual_Measurements=xlsread('Project 1 DH Parameter Optimization.xlsx');%
if(size(Actual_Measurements,2)-1 ~= Num_Links)
     error('The number of joints passed in does not match the number of joints in the excel file'); 
end
%END FILE READING%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

% VARIABLES%%%%%%%%%%%%%%%%%%%%%%% %
Predicted_Values=zeros(1,size(Actual_Measurements,1));%
%Pre-allocate the predicted values to make calculations 
%faster
Debug_Mode = 0;% This is used to debug the function           %
%END VARIABLES%%%%%%%%%%%%%%%%%%%%  %

%ERROR CHECKING%%%%%%%
if(Debug_Mode)
    disp('mod 3 is = ')
    mod(numel(dh_parameters),3)
    disp('mod 4 is = ')
    mod(numel(dh_parameters),4)
end
 
%if(mod(numel(dh_parameters),3) ~= 0 && mod(numel(dh_parameters),4) ~= 0 )
%    error('The number of paramters passed does not match what is expected. dh_parameters must contain either a multiple of 3 or 4 values');
%end

%END ERROR CHECKING%%%%%%

%CONDITIONALS%%%%%%%%%%%%%%%
if(mod(numel(dh_parameters),4) == 0)            %
    Used_Offset = 1;                                                        %
else                                                                                        %
    Used_Offset = 0;                                                        % 
end                                                                                        %
%END CONDITIONALS%%%%%%%%%%%%

if(Used_Offset == 1)% If an offset value os included into the parameters
    for(i=1:1:Num_Links)
        %Grab the values that correspond to the dh parameters of the link
        %The argument of the dh_parameters is used to shift to the new link
        %after each iteration has completed.
        L(i)=Revolute('d',dh_parameters(4*i-3),'a',dh_parameters(4*i-2),'alpha',dh_parameters(4*i-1),'offset',dh_parameters(4*i),'modified');
    end
else
    for(i=1:1:Num_Links)
        %Do the same thing as before excpet that no offset was included
        L(i)=Revolute('d',dh_parameters(3*i-2),'a',dh_parameters(3*i-1),'alpha',dh_parameters(3*i),'modified');
    end
end

if(~Debug_Mode)
    %Create the robot and attach a tool and base
    Robot=SerialLink(L,'base',[-0.132,0.135,0],'tool',[0,0.086,0.0215]);% Create the robot and shift it to the proper location on the board
end

if(Debug_Mode)
    Robot=SerialLink(L,'base',[0,0,0],'name','Robot');% Create the robot and shift it to the proper location on the board
    Robot1=SerialLink(L,'base',[0,0,0],'name','Robot1');% Create the robot and shift it to the proper location on the board
    %Robot2=SerialLink(L,'base',[0,0,0],'name','Robot2');% Create the robot and shift it to the proper location on the board
    %Robot3=SerialLink(L,'base',[0,0,0],'name','Robot3');% Create the robot and shift it to the proper location on the board
    subplot(2,2,1);
    Robot.plot([0,0]);
    subplot(2,2,2);
    Robot1.plot([0,pi/2]);
    %subplot(2,2,3);
    %Robot2.plot([pi,pi,pi]);
    %subplot(2,2,4);
    %Robot3.plot([pi/2,pi/2,pi/2]);
end

for(i=1:1:size(Actual_Measurements,1))% loop through the measurements
   T=Robot.fkine(Actual_Measurements(i,1:1:Num_Links));%Compute the transformation matrix for this robot
   Translation=T.transl% Grab the translation information from the transformation matrix
   %Calculates the distance between origin and the tip of the tool.
   Predicted_Values(i)=sqrt(Translation(1)^2+Translation(2)^2+Translation(3)^2);
end

%Calculate the error of the system
Error=sum((Actual_Measurements(:,Num_Links+1)'-Predicted_Values).^2);

end%end of entire .m file

