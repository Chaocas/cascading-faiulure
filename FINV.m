function Y=FINV(Y_p)

    global A Bus_type INV Yp P_b n_e; 

    B=A'*diag(Y_p)*A;

    %************************************Identify Subnetworks**********************************

    [nComponents, sizes, members] = NetworkComponents(B);

      for i=1:nComponents                                                                                                          % number of Islands or connected components

                SubINV=zeros(sizes(i),sizes(i));

                Subnet(1:sizes(i),1:sizes(i))=B(members{i},members{i});                                            % extract subnetworks from the whole network

                if(sum(Bus_type(members{i}))~=0)

                     Gb=find(Bus_type(members{i}));                                                                          % generator bus 

                     SubINV(setdiff(1:sizes(i),Gb(1)),setdiff(1:sizes(i),Gb(1)))=inv(Subnet(setdiff(1:sizes(i),Gb(1)),setdiff(1:sizes(i),Gb(1))));                                % inverse matrix             

                end

                Y(members{i},members{i})=SubINV;

                if(sum(Bus_type(members{i}))==0)                                                                            % subnetwork with only load buses

                   Y(members{i},members{i})=INV(members{i},members{i});

                   P_b(members{i},1)=zeros(sizes(i),1);

                end    

                if(sum(Bus_type(members{i}))==length(members{i}))&&(length(members{i})~=1)         % subnetwork with only generator buses

                   for j=1:n_e

                        if(ismember(find(A(j,:)),members{i})==[1 1])

                             Yp(j,1)=0;

                        end

                   end

                end

      end
                  
end