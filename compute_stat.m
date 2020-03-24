% compute mean value and standard deviation
clc;
clear all;

a=data_save;

%% Branch 5
br=a.Branch_5;
Jmin=min(br(:,2));
Index_min=find(br(:,2)<=Jmin);

mean_br = mean(br);
   std_br = std(br);
Delta_min=br(Index_min(1),1);
J_min=br(Index_min(1),2);


%% Branch 26
br=a.Branch_26;
Jmin=min(br(:,2));
Index_min=find(br(:,2)<=Jmin);

mean_br = mean(br);
   std_br = std(br);
Delta_min=br(Index_min(1),1);
J_min=br(Index_min(1),2);


%% Branch 45
br=a.Branch_45;
Jmin=min(br(:,2));
Index_min=find(br(:,2)<=Jmin);

mean_br = mean(br);
   std_br = std(br);
Delta_min=br(Index_min(1),1);
J_min=br(Index_min(1),2);


%% Branch 64
br=a.Branch_64;
Jmin=min(br(:,2));
Index_min=find(br(:,2)<=Jmin);

mean_br = mean(br);
   std_br = std(br);
Delta_min=br(Index_min(1),1);
J_min=br(Index_min(1),2);


%% Branch 108

br=a.Branch_108;
Jmin=min(br(:,2));
Index_min=find(br(:,2)<=Jmin);

mean_br = mean(br),
   std_br = std(br),
Delta_min=br(Index_min(1),1),
J_min=br(Index_min(1),2),


