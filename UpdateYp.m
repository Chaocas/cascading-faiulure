% Optimization algorithm of the operation of FACTS devices 

function Y=UpdateYp(Y_p,k)

global  Kp Ki Kd n_e Xp P_b A ctr I_id ID_hvdc T_step INV dt n_branch n_delay VXc;   
    
    sum_Per=zeros(n_e,1);
    
    Ref=ctr';
         
    Xc=zeros(n_e,1);
   
    Xref=zeros(n_e,1);
    
    VPer=zeros(n_e,1);
    
    if (k~=1)
        
        Xc=VXc;
    
    end
    
    Xmin=0;
    
    Xmax=10; 
    
    Tc=1;
    
    t=0;
    
    n_step=round(T_step/dt);
    
    figure(1);
    
    while(t<=n_step)    

        INV(:,:,k)=FINV(Y_p,k);
        
        P_e=-diag(Y_p)*A*INV(:,:,k)*P_b(:,k);
        
        Per=-min(Ref-abs(P_e),zeros(n_e,1));
        
        Per(ID_hvdc,1)=0;
        
%         if(norm(Per)==0)&&(k>=2)

%             break;

%         end
        
        sum_Per=sum_Per+Per*dt;

        diff_Per=(Per-VPer)/dt;

        u=Kp*Per+Ki*sum_Per+Kd*diff_Per;

        plot((k-1)*n_step+t,norm(Per),'--b.');
        hold on;

        Xc=Xc+(-Xc+Xref+u)*dt/Tc;
        
        if(abs(Y_p(I_id,1))>1e-4)
            Xp(I_id,1)=-1/Y_p(I_id,1);
        else
            Y_p(I_id,1)=0;
            Xp(I_id,1)=0;
            Xc(I_id)=0;
        end
        
        for i=1:n_e
            
            if(Xc(i)<=Xmin)
                
                Xc(i)=Xmin;
              
            elseif(Xc(i)>=Xmax)
                
                 Xc(i)=Xmax;
                 
            end
            
            if (abs(P_e(i))>=ctr(i))
                
                n_branch(i,1)=n_branch(i,1)-1;
                
                if(n_branch(i,1)<=0)
                    Y_p(i,1)=0;    
                    Xp(i,1)=0;
                    Xc(i)=0;
                end
                
            elseif(abs(P_e(i))<ctr(i))&&(Y_p(i,1)~=0)
                
                n_branch(i,1)=n_delay;
                
            end
            
            if(Xp(i,1)+Xc(i)~=0)
                Y_p(i,1)=-1/(Xp(i,1)+Xc(i));
            else
                Y_p(i,1)=0;  
            end
        
        end
        
        Y_p(ID_hvdc,1)=0;
        
        VPer=Per;                                                    % store power flow last step
    
        t=t+1;
        
        VXc=Xc;
        
    end
        
        Y=Y_p;

end


