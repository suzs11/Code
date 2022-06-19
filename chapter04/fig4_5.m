clc;clear;
n=10000;
a=4;   
x = zeros(n,1);
x(1)=0.32;
for i=1:n-1
    %y=a.*(unit-2*x);
    %sum=sum+log(abs(y));
    x(i+1)=a.*x(i).*(1-x(i));
end
fsize = 20;
plot(x)
Y = x(5000:end,1);
save rosser6_3_200.txt Y -ascii;
%save lorenz28_200 Y;
data = Y;
%% To find the parameter time delay
fontSize=18;
tau = mdDelay(Y(:,1), 'maxLag',40, 'plottype', 'all');
set(gca,'FontSize',fontSize,'fontWeight','normal')
disp('x: tau = ' + string(tau))

%% Estimate the embedding dimension (Figure 2b in the article)
[fnnPercent, embeddingDimension] = mdFnn(data,tau);
%set(gca,'FontSize',fontSize,'fontWeight','normal')
%print('Figure2b','-dpng')

%% Construct time delayed versions of the x-variable (Figure 1b-d in the article)
% To see the effect in the plot we use an exaggerated value of tau, so for 
% illustration purposes we set tau = 40.
m=3;
figure();
set(gcf,'color','white')
set(gcf,'Position',[300 100 1100 500])
% Plot the x variable
figure = subplot(3,3,[1,4,7]);
plot3(data(:,1),data(:,1),data(:,1),'LineWidth',1);view([50,15])
xlabel('X','FontSize',18)
ylabel('Y','FontSize',18)
zlabel('Z','FontSize',18)
title('\fontsize{20}A')
subplot(3,3,2), plot(data(:,1),'LineWidth',1.5)
set(gca,'xtick',[],'xticklabel',[])
ylabel('X(t)')
axis([0 2000 min(data(:,1)) max(data(:,1))])
%set(gca,'FontSize',fontSize,'fontWeight','normal')
set(findall(gcf,'type','text'),'FontSize',fontSize,'fontWeight','normal')
% Plot the x variable delayed by tau
subplot(3,3,5), plot(data(1 + tau:end,1),'LineWidth',1.5)
set(gca,'xtick',[],'xticklabel',[])
ylabel('X(t-\tau)')
axis([0 2000 min(data(:,1)) max(data(:,1))])
%set(gca,'FontSize',fontSize,'fontWeight','normal')
set(findall(gcf,'type','text'),'FontSize',fontSize,'fontWeight','normal')
subplot(3,3,8), plot(data(1 + 2 * tau:end,1),'LineWidth',1.5)
ylabel('X(t-2\tau)')
xlabel('time')
axis([0 2000 min(data(:,1)) max(data(:,1))]);
%set(gca,'FontSize',fontSize,'fontWeight','normal')
set(findall(gcf,'type','text'),'FontSize',fontSize,'fontWeight','normal');
%print('FillPageFigure','-depsc')
subplot(3,3,[3,6,9])
plot3(data(1:end-(m-1)*tau,1),data(1+tau:end-(m-2)*tau,1),data(1+2*tau:end,1))
view([50,15]);
xlabel('X(t)','FontSize',18)
ylabel('X(t-\tau)','FontSize',18)
zlabel('X(t-2\tau)','FontSize',18)
