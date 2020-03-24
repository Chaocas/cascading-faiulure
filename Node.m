classdef Node
       
    properties
        
    V;
    P;
    Theta;
    x=0;
    y=0;
    ID=0;                                             % bus ID
    type=0;                                          % 0-load bus; 1-generator bus
    size=18;                                        % ball size
    
    end
    
    methods
        
        function obj=disp(obj)
            
            if(obj.type==0)
                
                  plot(obj.x,obj.y,'g.','MarkerSize',obj.size);        
            
            else
                
                 plot(obj.x,obj.y,'r.','MarkerSize',obj.size);                                   
            
            end
            
            text(obj.x,obj.y,sprintf('%d',obj.ID),'FontSize',6);
            
        end
        
    end
    
end