% figure plot
clc;
close all;

x=1:1:10;

J=[171.9 171.8 171.7 92.93 92.93 80.65 80.65 61.51  61.51  61.51];

Del=[22.16 19.29 9.53  37.38 37.38 37.43 37.43 37.45 37.45 37.45 ];

subplot(2,1,1);
plot(x,Del,'--ro','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','b',...
                       'MarkerSize',10);
grid on;
axis([1 10 0 40]);
hold on;
xlabel('Iterations');
ylabel('Disturbance');

subplot(2,1,2);
plot(x,J,'--ro','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',10);
grid on;
axis([1 10 50 180]);
hold on;
xlabel('Iterations');
ylabel('Cost function');