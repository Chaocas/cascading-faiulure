function Y=SysAE(X)  

global  dmin dmax;

Y=zeros(7,1); 

Y(1,1)=Plink(X(7))'*Deriv_Plink(X(7))+X(1)-X(2);
Y(2,1)=X(7)-dmax+X(3)^2;
Y(3,1)=X(7)-dmin-X(4)^2;
Y(4,1)=X(1)*(X(7)-dmax);               
Y(5,1)=X(2)*(X(7)-dmin);   
Y(6,1)=X(1)-X(5)^2;
Y(7,1)=X(2)-X(6)^2;     

end


% X(1)-mu1
% X(2)-mu2
% X(3)-x1
% X(4)-x2
% X(5)-y1
% X(6)-y2
% X(7)-delta-disturbance

