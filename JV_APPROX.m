function y = JV_APPROX(v,F,x)

% calculate perturbation

global n_e;

% dim = size(x,2);

dim = size(x,1);

if norm(v,2) > eps
    
    sum = 0;
    
    for i = 1 : dim
        
        sum = sum + sqrt(eps) * (1 + x(i));
        
    end
    
    per = (1 / (dim * norm(v, 2))) * sum;
    
else
    
    sum = 0;
    
    for i = 1 : dim
        
        sum = sum + sqrt(eps) * (1 + x(i));
        
    end
    
    per = sum / dim;
    
end

matx=vec2mat(x,n_e)';

matR = F(matx);                                                   % unperturbed residual

R=matR(:);

% xper = x' + per * v;    

xper = x + per * v;                                                 % perturbed vector

mat_xper = vec2mat(xper,n_e)';

mat_Rper = F(mat_xper);                                       % perturbed residual

Rper = mat_Rper(:); 

y = (Rper - R) / per;                                               % approximation of jacobian action on krylov vector

end