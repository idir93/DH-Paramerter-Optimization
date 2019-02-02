%Project_1R Create model of our 3-axis robot for assignment 1
%
% Project_1R is a script that creates the workspace variable p560 which
% describes the kinematic characteristics of the 3-axis
%  manipulator using modified DH conventions. 
%
%
% all parameters are in SI units: m and radians.
clear L
deg= pi/180;
L(1) = Revolute('d', 0.0548,...     % link length (Dennavit-Hartenberg notation)
    'a', 0.0009,...                 % link offset (Dennavit-Hartenberg notation)
    'alpha', 0.0007,...             % link twist (Dennavit-Hartenberg notation)
    'offset', -0.2699,...           % Offset angle in radians
    'modified',...                  % We used modified DH parameters from the ones used in the toolbox
    'qlim',[-87*deg,120*deg]);      % Joint limits in radians
L(2) = Revolute('d', 0.0359,...
    'a', 0.1084,...
    'alpha', 0.002,...
    'offset', 0.2373,...
    'modified',...
    'qlim',[-159*deg,38.5*deg]);
L(3) = Revolute('d', -0.0011,...
    'a', 0.1,...
    'alpha', -1.555,...
    'offset',-0.0002, 'modified','qlim',[-123*deg,40*deg]);

  Robot = SerialLink(L,'base',[-0.132,0.135,0],'tool',[0,0.086,0.0215],'name', 'robot'); % Creating the robot with tool and base postions
  clear L
  %end of m file
