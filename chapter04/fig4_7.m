clc;clear;
a = 10;
b = 28;
c = 8/3;
params = [a,b,c];
x = 1.0; y = 1.0; z = 1.0;
tspan=0:0.02:200;
[T,Y]=ode45(@(t,X) Lorenz(t,X,params),tspan,[x;y;z]); 
Y = Y(5000:end,:);
%save lorenz28_200.txt Y -ascii;
%save lorenz28_200 Y;
data = Y;
%% To find the parameter time delay
fontSize=18;
tau = mdDelay(Y(:,1), 'maxLag',25, 'plottype', 'all');
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
plot3(data(:,1),data(:,2),data(:,3),'LineWidth',1);view([67,30])
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
view([67,30]);
xlabel('X(t)','FontSize',18)
ylabel('X(t-\tau)','FontSize',18)
zlabel('X(t-2\tau)','FontSize',18)

function dX = Lorenz(t,X,params) 
a = params(1);
b = params(2);
c = params(3);
x=X(1); 
y=X(2); 
z=X(3);
dX = zeros(3,1);
dX(1)=a*(y-x);
dX(2)=x*(b-z)-y;
dX(3)=x*y-c*z;
end 