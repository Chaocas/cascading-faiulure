% Optimization algorithm for the operation of HVDC links, load shedding or generator tripping

function [Y, ALP, GAM, P_r, P_i]=UpdatePb(Pb)

global  A n_b ID_hvdc Pb_0;  

Rcr=0.1;
Rci=0.1;
RL=0.1;

alp=pi/15;
gam=pi/4;

DeltPb=zeros(n_b,1);

for j=1:numel(ID_hvdc)

        Id=3*sqrt(3)*(cos(alp)-cos(gam))/(pi*(Rcr+RL-Rci));

        Pr=3*sqrt(3)*Id*cos(alp)/pi-Rcr*Id^2;

        Pi=3*sqrt(3)*Id*cos(gam)/pi-Rci*Id^2;

        ID_bus=find(A(ID_hvdc(j),:));

        if(A(ID_hvdc(j),ID_bus(1))==1)

            DeltPb(ID_bus(1),1)=-Pr;
            DeltPb(ID_bus(2),1)=Pi;

        else

            DeltPb(ID_bus(1),1)=Pi;
            DeltPb(ID_bus(2),1)=-Pr;

        end

        Pb(ID_bus(1),1)=Pb_0(ID_bus(1),1);

        Pb(ID_bus(2),1)=Pb_0(ID_bus(2),1);

        P_bus=Pb+DeltPb;                                      %  BIG Problem Iteration 

end

    Y=P_bus;
    
    ALP=alp;
    
    GAM=gam;
    
    P_r=Pr;
    
    P_i=Pi;

end


