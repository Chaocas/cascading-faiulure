classdef eLink
       
    properties
        
        P;
        Yp;
        ID;
        
        source_x;
        source_y;
        
        sink_x;
        sink_y;
        
        width=1.5;                                     % line width
        
        scale=1;
        
        ep=0.5;
        
        x=0;
        y=0;
         
    end
      
    methods
        
        function obj=arrow(obj)           
            
            if(sign(obj.P)==1)
                
                  obj.scale=10/norm([obj.sink_x-obj.x, obj.sink_y-obj.y]);
                
                  quiver(obj.x,obj.y,obj.ep*(obj.sink_x-obj.x),obj.ep*(obj.sink_y-obj.y),0,'MaxHeadSize',obj.scale,'Color','k','LineWidth',obj.width);
            
            elseif(sign(obj.P)==-1)
                
                  obj.scale=10/norm([obj.source_x-obj.x, obj.source_y-obj.y]);
                
                  quiver(obj.x,obj.y,obj.ep*(obj.source_x-obj.x),obj.ep*(obj.source_y-obj.y),0,'MaxHeadSize',obj.scale,'Color','k','LineWidth',obj.width);
                
            end
                
        end
        
        function obj=disp(obj)
                
            line([obj.source_x obj.sink_x],[obj.source_y obj.sink_y],'LineWidth',obj.width,'Color','c');                              
            
            % text(obj.x,obj.y,sprintf('%d',obj.ID),'Color','m','FontSize',6);
            
        end
        
        function obj=disturb(obj)
                
            line([obj.source_x obj.sink_x],[obj.source_y obj.sink_y],'LineWidth',obj.width,'Color','r');                              
            
            % text(obj.x,obj.y,sprintf('%d',obj.ID),'Color','m','FontSize',6);
            
        end
        
        function obj=hvdc(obj)
                
            line([obj.source_x obj.sink_x],[obj.source_y obj.sink_y],'LineWidth',obj.width,'Color','b');                              
            
        end
        
        function obj=idle(obj)
                
            line([obj.source_x obj.sink_x],[obj.source_y obj.sink_y],'LineWidth',obj.width,'Color','y');                              
            
        end
        
    end
    
end
