function Y=Val_Plink(x)

global Yp Xp Yp_0 INV A Ts T_step Pb_0 P_b n_c n_b n_e I_id ID_hvdc n_delay n_branch ctr Kp Ki Kd data;

u=zeros(n_e,1);

H=zeros(n_e,n_e);

for i=1:n_e
    H(i,i)=1;
end

u(I_id,1)=x;
                                                                  
P_b=zeros(n_b,n_c);                                             % Active power on bus

P_b(:,1)=Pb_0;   

Xp=data.branch(:,4);

Yp=zeros(n_e,n_c+1);      

Yp(:,1)=Yp_0;

Y_p=Yp_0;

Y_p(ID_hvdc,1)=0;

sum_Per=zeros(n_e,1);

Ref=ctr;

Xc=zeros(n_e,1);

Xref=zeros(n_e,1);

VPer=zeros(n_e,1);

Xmin=0;

Xmax=100; 

Tc=1;

t=0;

dt=0.1;                                                                % Time interval for each step

n_step=round(Ts/dt);                                           
                                                                
Timer=0.5;                                                           % Time dalay in relays

n_delay=round(Timer/dt);                                       % Count number in timer

n_branch=n_delay*ones(n_e,1);                             % preset s=count number for each branch

INV=zeros(n_b,n_b);

[Y, ~, ~, ~, ~]=UpdatePb(P_b(:,1));                        % HVDC Links

P_b(:,1)=Y; 

%*******************Cascading Dynamics************%  

    while(t<=n_step)    
        
        if(t==round(T_step/dt))
            
            Y_p=Y_p+u;

        end
        
        INV=FINV(Y_p);
        
        P_e=-diag(Y_p)*A*INV*P_b(:,1);
        
        Per=-min(Ref-abs(P_e),zeros(n_e,1));
        
        Per(ID_hvdc,1)=0;
        
        sum_Per=sum_Per+Per*dt;

        diff_Per=(Per-VPer)/dt;

        u_x=Kp*Per+Ki*sum_Per+Kd*diff_Per;

        Xc=Xc+(-Xc+Xref+u_x)*dt/Tc;
        
        if(abs(Y_p(I_id,1))>1e-4)
            
            Xp(I_id,1)=-1/Y_p(I_id,1);
        
        else
            
            Y_p(I_id,1)=0;
            Xp(I_id,1)=0;
            Xc(I_id)=0;
            H(I_id,I_id)=0;
        
        end
        
        for i=1:n_e
            
            if(Xc(i)<=Xmin)
                
                Xc(i)=Xmin;
              
            elseif(Xc(i)>=Xmax)
                
                 Xc(i)=Xmax;
                 
            end
            
            if(Xp(i,1)+Xc(i)~=0)
                Y_p(i,1)=-1/(Xp(i,1)+Xc(i));
            else
                Y_p(i,1)=0;  
                Xp(i,1)=0;
                Xc(i)=0;
            end
            
            if (abs(P_e(i))>=ctr(i))
                
                n_branch(i,1)=n_branch(i,1)-1;
                
                if(n_branch(i,1)<=0)
                    Y_p(i,1)=0;    
                    Xp(i,1)=0;
                    Xc(i)=0;
                    H(i,i)=0;
                    
                    Id_branch_hf = Branch_hf(i,A);
                    
                    if(~isempty(Id_branch_hf))
                        
                       Y_p(Id_branch_hf,1)=0;    
                       Xp(Id_branch_hf,1)=0;
                       Xc(Id_branch_hf)=0;
                       H(Id_branch_hf,i)=0; 
                      
                    end    
                    
                end
                
            elseif(abs(P_e(i))<ctr(i))&&(Y_p(i,1)~=0)
                
                n_branch(i,1)=n_delay;
                
            end
        
        end
        
        Y_p(ID_hvdc,1)=0;
        
        H(ID_hvdc,ID_hvdc)=0;
        
        VPer=Per;                                                    % store transmission power last step
    
        t=t+1;
        
        Y_p=H*Y_p;
        
    end

    Y=P_e;

end




