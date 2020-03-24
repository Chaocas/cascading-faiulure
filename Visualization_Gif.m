% Visualize the cascading process of power system

clear;

global A Yp P_e P_b n_c n_b n_e I_id Bus_type ID_hvdc;

Coord=[3 16; 5 16; 2 15; 1 14; 1 13; 3 13; 5 13; 1 11; 1 10; 1 9;
             3 14; 5 14; 7 13; 7 14; 7 12; 5 12; 5 11; 7 11; 8 11; 8 10;
              6 9;  6 8;  6 7; 7 5;  6 4; 6 3;  2 4;  2 7; 2 8; 5 9; 
              3 9;  4 7;  8 14; 9 11; 9 14; 9 12; 10 13; 10 11;10 15; 13 15;
              14 15; 14 14; 11 14; 12 14; 11 14; 11 12; 12 11; 13 12; 13 11; 16 11;
              15 11; 15 12; 15 13; 15 15; 18 15; 16 15; 17 13; 16 13; 18 10; 18 9;
              18 7; 17 8; 17 10; 17 7; 13 7; 13 9; 15 8; 12 7; 11 7; 8 7;
              8 8; 7 8; 10 8; 9 7; 10 7; 10 4; 11 6; 12 4; 12 5; 13 6;
              12 6; 11 4; 11 3; 10 2; 9 1; 8 1; 7 1; 11 1; 12 2; 12 1;
              13 1; 14 2; 14 3; 14 4; 13 3; 13 4; 13 5; 14 5; 15 6; 15 4;
              15 2; 15 1; 18 3; 17 4; 18 4; 17 6; 18 6; 19 4; 19 3; 18 2;
              17 2; 17 1; 4 9; 4 5; 4 4; 12 9; 6 16; 10 5];
               
for i=1:n_b

    bus(i)=Node;
    bus(i).ID=i;
    bus(i).x=Coord(i,1);
    bus(i).y=Coord(i,2);
    
    if(Bus_type(i,1)==1)
        
        bus(i).type=1;
        
    end

end

for i=1:n_e

    element(i)=eLink;    
    element(i).ID=i;
    
    Index=find(A(i,:));
    
    if(A(i,Index(1))==-1)
        
        i1=Index(1);
        i2=Index(2);
        
    else
        
        i1=Index(2);
        i2=Index(1);
        
    end
    
    element(i).source_x=bus(i1).x;
    element(i).source_y=bus(i1).y;
    
    element(i).sink_x=bus(i2).x;
    element(i).sink_y=bus(i2).y;
    
    element(i).x=(element(i).source_x+element(i).sink_x)/2;
    element(i).y=(element(i).source_y+element(i).sink_y)/2;
    
end

figure(1);

set(gcf,'Color',[1,1,1]);

for k=1:n_c
    
    delete(gca);
    
    axis([0 20 0 18]);         
    
    axis off;
    
    hold on;

    title(['Step ' num2str(k-1)]);
    
    for i=1:n_e
        
        element(i).P=P_e(i,k);
        
        element(i).Yp=Yp(i,k);
        
        if(abs(element(i).Yp)>=0.01)
           
           if(i==I_id)&&(k~=1)                                     % disturbance input
               
                element(i).disturb;
                hold on;
               
           else
               
                element(i).disp;
                hold on;
           
           end
           
%            element(i).arrow;
%            hold on;      
        
           if(element(i).P==0)&&(element(i).Yp~=0)
            
                element(i).idle;
                hold on;
            
           end

        end
        
        
        if(ismember(i,ID_hvdc))
             
            element(i).hvdc;
            hold on;
                
        end
        
    end
    
    for i=1:n_b
        
        bus(i).P=P_b(i,k);
        bus(i).disp;
        hold on;
        
    end
    
    pause(1);
    
    f=getframe(gcf);
    im=frame2im(f);
    [I,map]=rgb2ind(im,256);
    if (k==1)
        imwrite(I,map,'FACTS_3HVDC.gif','gif','Delaytime',1);
    else
        imwrite(I,map,'FACTS_3HVDC.gif','gif','writemode','append','Delaytime',1);        
    end
    
    if(k~=n_c)
        
         delete(gca);
    
    end
     
end

