% Provide the ID of falsely tripped branches due to hidden failures 

function Y = Branch_hf(i, A)

p_hf = 0.05;

id_bus = find(A(i,:));

id_branch1= find(A(:,id_bus(1))); 

id_branch2= find(A(:,id_bus(2))); 

id_branch = union(id_branch1,id_branch2);

num_br = numel(id_branch);

vec_rand = rand(num_br,1);

X_id=find(vec_rand<p_hf, 1);

if(isempty(X_id))
    
    Y = [];
    
else
    
    Y = id_branch(X_id(1));
    
end

end