% Clear workspace, clear Command Window, close all Figure windows.
clear, clc, close all
a = 0.2;
b = 0.2;
c = 5.7;
params = [a,b,c];
x0 = 0.7; y0 =0.4; z0 = 0.5;
[T0,Y0]=ode45(@(t,X) Rossler(t,X,params),[0,20],[x0;y0;z0]);
x = Y0(end,1);y = Y0(end,2);z = Y0(end,3);
[T,Y]=ode45(@(t,X) Rossler(t,X,params),[0,200],[x;y;z]); 
% Y(:,1) = Y(:,1)/max(Y(:,1));
% Y(:,2) = Y(:,2)/max(Y(:,2));
% Y(:,3) = Y(:,3)/max(Y(:,3));
%save fangcheng.txt Y  -ascii;
%save fangcheng T Y
%% The Figures
h=figure('Position',[300 50 1100 750],'Color',[1 1 1]);
fsize=18;
subplot('position',[0.1 0.8 0.2 0.2]);
plot(Y(:,1),Y(:,2))
title('A','FontSize',fsize)
%set(gca,'XTick',-1:0.5:1,'FontSize',fsize)
%set(gca,'YTick',-1:0.5:1,'FontSize',fsize)
xlabel('x','FontSize',fsize)
ylabel('y','FontSize',fsize)
hold on
subplot('position',[0.4 0.8 0.2 0.2]);
plot(Y(:,2),Y(:,3));
title('B','FontSize',fsize)
%set(gca,'XTick',-1:0.5:1,'FontSize',fsize)
%set(gca,'YTick',-1:0.5:1,'FontSize',fsize)
xlabel('y','FontSize',fsize)
ylabel('z','FontSize',fsize)
hold on
subplot('position',[0.7 0.8 0.2 0.2]);
plot(Y(:,1),Y(:,3))
title('C','FontSize',fsize)
%set(gca,'XTick',-1:0.5:1,'FontSize',fsize)
%set(gca,'YTick',-1:0.5:1,'FontSize',fsize)
xlabel('x','FontSize',fsize)
ylabel('z','FontSize',fsize)
hold on

h(4)=axes('position',[0.1 0.5 0.5 0.2]);
plot(T,Y(:,1),'LineWidth',1.5)
ylabel('x','FontSize',fsize)
title('D','FontSize',fsize)
%set(gca,'ytick',-1:1:1,'FontSize',fsize)
set(gca,'xtick',[],'xticklabel',[])
hold on
subplot('position',[0.1 0.3 0.5 0.2]);
plot(T,Y(:,2),'LineWidth',1.5)
title('E','FontSize',fsize)
ylabel('y','FontSize',fsize)
%set(gca,'ytick',-1:1:1,'FontSize',fsize)
set(gca,'xtick',[],'xticklabel',[])
hold on
subplot('position',[0.1 0.1 0.5 0.2]);
plot(T,Y(:,3),'LineWidth',1.5)
title('F','FontSize',fsize)
ylabel('z','FontSize',fsize)
%set(gca,'ytick',-1:1:1,'FontSize',fsize)
xlabel('time','FontSize',fsize)
hold on
subplot('position',[0.7 0.1 0.3 0.7]);
plot3(Y(:,1),Y(:,2),Y(:,3))
title('G','FontSize',fsize)
xlabel('X','FontSize',18)
ylabel('Y','FontSize',18)
zlabel('Z','FontSize',18)
% %saveas(gcf,'rossler2','eps')
% %print('rossler2.pdf','-dpdf','-fillpage')
% 
% %%
% c0 = [2.3, 3.3, 5.3, 4, 6.3,7.3];
% i=1;
% figure;
% set(gcf,'Position',[300 50 1000 500])
% for c1=c0
% params = [a,b,c1];
% x = 1; y =1; z = 1;
% [T1,Y1]=ode45(@(t,X) Rossler(t,X,params),[0,200],[x;y;z]); 
% % Y1(:,1) = Y1(:,1)/max(Y1(:,1));
% % Y1(:,2) = Y1(:,2)/max(Y1(:,2));
% % Y1(:,3) = Y1(:,3)/max(Y1(:,3));
% subplot(2,3,i)
% plot3(Y1(1000:end,1),Y1(1000:end,2),Y1(1000:end,3),'LineWidth',1)
% xlabel('X','FontSize',18)
% ylabel('Y','FontSize',18)
% zlabel('Z','FontSize',18)
% i = i+1;
% end
% %% Bifurcation diagrams for the R¨ossler system.
% cs = 2.05:0.001:7.0;
% fsize=24;
% figure;
% set(gcf,'Position',[300 50 800 400])
% Z = [];
% for cc=cs
%     params = [a,b,cc];
%     x = 1; y =1; z = 1;
%     [T2,Y2]=ode45(@(t,X) Rossler(t,X,params),[0,200],[x;y;z]); 
%     Y3 = Y2(2000:end,1);
%     N = length(Y3(:,1));
%     for i = 2:N-1
%         dz = (Y3(i+1,1) -Y3(i,1))*(Y3(i,1)-Y3(i-1,1));
%         ddz = Y3(i+1,1)+Y3(i-1,1)-2*Y3(i,1);
%         zn = Y3((dz<0).*(ddz<0)==1,1);
%         if (dz<0 && ddz<0)
%             Z = [Z; cc Y3(i,1)];
%         end
%     end
% end
% plot(Z(:,1),Z(:,2),'r.')
% xlabel('\fontsize{20}c','FontSize',fonts)
% ylabel('\fontsize{20}x','FontSize',fonts)
% set(gca,'XTick',2:1:7,'FontSize',fsize)
% %set(gca,'YTick',0.4:0.1:1,'FontSize',fsize)


function dX = Rossler(t,X,params) 
a = params(1);
b = params(2);
c = params(3);
x=X(1); 
y=X(2); 
z=X(3);
dX = zeros(3,1);
dX(1)=-y-z;
dX(2)=x+a*y;
dX(3)=b+(x-c)*z;
end 