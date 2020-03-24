%***********************************************************************************    
% Goal: Identify Initial Faults of Critical Elements in Power Systems with 
% FACTS Devices and HVDC Links 
% Function: Identify the Disruptive Disturbance on Selected Branch
% Time delay in Timer (0.5s) before before branch outages
% Method: KKT Conditions without HVDC dynamics 
% Example: IEEE 118 Bus System 
% Created by Chao Zhai at NTU 
% Date:17-10-2019
%***********************************************************************************    

clc;
clear all;
close all;

global A I_id Bus_type Pb_0 P_b ctr n_b n_c n_e Xp Yp_0 Ts Kp Ki Kd ID_hvdc data ep dmin dmax Kdata T_step;

%*******************Parameter Setting***************%

data=case118;                                                  % Call data on IEEE 118-Bus System
Ts=10;                                                         % Simulation time
T_step=1;                                                      % Time duration at each step
n_c=round(Ts/T_step);                                          % Number of cascading steps
n_e=length(data.branch(:,1));                                  % Number of elements
n_b= length(data.bus(:,1));                                    % Number of buses
Pbase=data.baseMVA;                                            % Power base
A=zeros(n_e,n_b);                                              % Node-element incidence matrix        
ID_hvdc=[4 16 38];                                             % HVDC link ID

n_times=100;                                                   % Times of simulations for each branch
Kdata=zeros(n_times,2);                                        % Keep data during cascading failures    1-disturbance,  2-cost function

p_hf=0.05;                                                     % Probability of an exposed line tripping falsely due to hidden failure 

I_id=5;                                                        %  Selected branch to add the disturbance

for i=1:n_e
    
    A(i,data.branch(i,1))=-1;
    
    A(i,data.branch(i,2))=1;
    
end
    
ep=1e-2;                                                             % Time step for partial derivative of Plink

ctr=1.05*thre;                                                       % Threshold of over power 

Kp=4;

Ki=3;

Kd=2;

%% iterations

for k_time=1:n_times
    
k_time,    

P_b=zeros(n_b,n_c);                                            % Active power on buses

u=zeros(n_e,n_c);                                                 % Control input or disturbance       

Yp_0=-data.branch(:,4).^-1;

Yp_0(ID_hvdc,1)=0;                                               % Treat HVDC link as outage branch 

Yp(:,1)=Yp_0;

Xp=data.branch(:,4);

dmin=0;

dmax=abs(Yp_0(I_id,1));

Bus_type=zeros(n_b,1);                                       

for i=1:n_b                                                           % 1-Slack/Generator bus; 0-Load bus
    
    if(data.bus(i,2)==1)
        Bus_type(i,1)=0;
    else
        Bus_type(i,1)=1;
    end
    
end

Id_gen=data.gen(:,1);

P_b(Id_gen,1)=data.gen(:,2)/Pbase;

P_b(:,1)=P_b(:,1)-data.bus(:,3)/Pbase;

for i=1:n_c
    
    P_b(:,i)=P_b(:,1);     
    
end

Pb_0=P_b(:,1);   

%************************JFNK******************%  

max_iter=3;

max_ep=1e-7;

X0=rand(7,1);

X0(7,1)=rand*dmax;

[X,Res]=JFNK(@SysAE,X0,max_ep,max_iter);

%********************Disturbance***************%   

Delta=X(7,1);

if(Delta>dmax)

    Delta=dmax;

elseif(Delta<0)
    
    Delta=dmin;   

end
    
%*********************Validation****************%   

Delta;

FY=Val_Plink(Delta);

J=norm(FY)^2;

Kdata(k_time,1) = Delta;
Kdata(k_time,2) = J;

end

Kdata,

%% draw figure 

% figure(1)
% x=1:1:n_c;
% y=(Kdata(:,(n_b+n_e+5)));
% plot(x,y,'--ro','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',10);
% hold on;                   
% axis([1 n_c 0 200]);
% hold on;
% xlabel('Cascading step');
% ylabel({'No. of outage';'branches'});
% grid on;








