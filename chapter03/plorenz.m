clc;clear;
a = 10;
b = 28;
c = 8/3;
params = [a,b,c];
x0 = 1.0; y0 = 1.0; z0 = 1.0;
%options=odeset('MaxStep',0.001);
[T0,Y0]=ode45(@(t,X) Lorenz(t,X,params),[0,30],[x0;y0;z0]);
n = length(Y0);
x = Y0(n,1);y = Y0(n,2);z = Y0(n,3);
[T,Y]=ode45(@(t,X) Lorenz(t,X,params),[0,50],[x;y;z]); 
%Y(:,1) = Y(:,1)/max(Y(:,1));
%Y(:,2) = Y(:,2)/max(Y(:,2));
%Y(:,3) = Y(:,3)/max(Y(:,3));
%save fangcheng.txt Y  -ascii;
%save fangcheng T Y
%% The Figures
figure;
fsize=14;
set(gcf,'Position',[300 50 1100 700])
subplot(441)
plot(Y(:,1),Y(:,2))
title('a','FontSize',fsize)
set(gca,'XTick',-1:0.5:1,'FontSize',fsize)
set(gca,'YTick',-1:0.5:1,'FontSize',fsize)
xlabel('x','FontSize',fsize)
ylabel('y','FontSize',fsize)
subplot(442)
plot(Y(:,2),Y(:,3))
title('a','FontSize',fsize)
set(gca,'XTick',-1:0.5:1,'FontSize',fsize)
set(gca,'YTick',-1:0.5:1,'FontSize',fsize)
xlabel('y','FontSize',fsize)
ylabel('z','FontSize',fsize)
subplot(443)
plot(Y(:,1),Y(:,3))
title('a','FontSize',fsize)
set(gca,'XTick',-1:0.5:1,'FontSize',fsize)
set(gca,'YTick',-1:0.5:1,'FontSize',fsize)
xlabel('x','FontSize',fsize)
ylabel('z','FontSize',fsize)
%axis off
subplot(4,4,[5,6,7])
plot(T,Y(:,1),'LineWidth',1)
ylabel('x','FontSize',fsize)
set(gca,'ytick',-1:1:1,'FontSize',fsize)
set(gca,'xtick',[],'xticklabel',[])
subplot(4,4,[9,10,11])
plot(T,Y(:,2),'LineWidth',1)
ylabel('y','FontSize',fsize)
set(gca,'ytick',-1:1:1,'FontSize',fsize)
set(gca,'xtick',[],'xticklabel',[])
subplot(4,4,[13,14,15])
plot(T,Y(:,3),'LineWidth',1)
ylabel('z','FontSize',fsize)
set(gca,'ytick',-1:1:1,'FontSize',fsize)
xlabel('time','FontSize',fsize)
subplot(4,4,[4,8,12,16])
plot3(Y(:,1),Y(:,2),Y(:,3))
xlabel('X','FontSize',18)
ylabel('Y','FontSize',18)
zlabel('Z','FontSize',18)
%saveas(gcf,'lorenz3','epsc')
%print('lorenz3.pdf','-dpdf','-fillpage')

%% Each plotted dot on the tent-like map is a pair (zn, zn1) of maximumz-coordinates
 % of loops of the trajectory, one following the other.
N = size(Y,1);
fonts=24;
dz = (Y(3:N,3) -Y(2:N-1,3)).*(Y(2:N-1,3)-Y(1:N-2,3));
ddz = Y(3:N,3)+Y(1:N-2,3)-2*Y(2:N-1,3);
zn = Y((dz<0).*(ddz<0)==1,3);
figure;
set(gcf,'Position',[500 300 500 400])
plot(zn(1:end-1),zn(2:end),'k.','LineWidth',3)
xlabel('\fontsize{20}z_n','FontSize',fonts)
ylabel('\fontsize{20}z_{n+1}','FontSize',fonts)
set(gca,'XTick',0.4:0.1:1,'FontSize',fsize)
set(gca,'YTick',0.4:0.1:1,'FontSize',fsize)
%% bifurcation diagrams for Lorenz system
bs = 0:0.1:200;
fsize=24;
figure;
set(gcf,'Position',[300 50 800 400])
Z = [];
for bb=bs
    params = [a,c,bb];
    x = 1; y =1; z = 1;
    [T2,Y2]=ode45(@(t,X) Lorenz(t,X,params),[0,100],[x;y;z]); 
    Y3 = Y2(800:end,3);
    N = length(Y3(:,1));
    for i = 2:N-1
        dz = (Y3(i+1,1) -Y3(i,1))*(Y3(i,1)-Y3(i-1,1));
        ddz = Y3(i+1,1)+Y3(i-1,1)-2*Y3(i,1);
        zn = Y3((dz<0).*(ddz<0)==1,1);
        if (dz<0 && ddz<0)
            Z = [Z; bb Y3(i,1)];
        end
    end
end
plot(Z(:,1),Z(:,2),'r.')
xlabel('\fontsize{20}b','FontSize',fonts)
ylabel('\fontsize{20}z','FontSize',fonts)
%set(gca,'XTick',2:1:7,'FontSize',fsize)
%set(gca,'YTick',0.4:0.1:1,'FontSize',fsize)


%% plot your figure before
%  % figure resize
% close all;
% figure
% x=0:0.1:10; 
% y=sin(x);
% plot(x,y,'b-')
% legend('sin');
% hold on;
% z = cos(x);
% plot(x,z,'r-')
% legend('cos');
% 
% % set(gcf,'Position',[500 500 260 220]);%左下角位置，宽高，这里的260正好是7cm，适合半个word页面
% % set(gca,'Position',[.13 .17 .80 .74]); %同样应用是在画图到word
% 
% set(gcf,'unit','normalized','position',[0.1,0.25,0.8,0.5]); %采用相对值设置，相对屏幕
% set (gca,'position',[0.1,0.1,0.8,0.8] );
% figure_FontSize=8;
% set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
% set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','middle');
% set(findobj('FontSize',10),'FontSize',figure_FontSize);
% set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1);
% xlab = xlabel('x轴');
% ylab = ylabel('y轴');
% set(ylab,'Rotation',0);
% title('图名');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%解释：
% set(gcf,'Position',[100 100 260 220]);这句是设置绘图的大小，不需要到word里再调整大小。我给的参数，图的大小是7cm
% set(gca,'Position',[.13 .17 .80 .74]);这句是设置xy轴在图片中占的比例，可能需要自己微调。
% figure_FontSize=8;
% set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
% set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','middle');
% set(findobj('FontSize',10),'FontSize',figure_FontSize);这4句是将字体大小改为8号字，在小图里很清晰
% set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);这句是将线宽改为2



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
% opts=odeset('MaxStep',0.02);
% [t,x]=ode45(@lorenzfun,[0,31],[1,2,1],opts);
% ax=figure(1);
% subplot(311)
% plot(t,x(:,1)','k.','linewidth',2);
% ylabel('\it{x(t)}','FontName','Times New Roman','FontSize',26);
% subplot(312)
% plot(t,x(:,2)','g.','linewidth',2);
% ylabel('\it{y(t)}','FontName','Times New Roman','FontSize',26);
% subplot(313)
% plot(t,x(:,3)','m.','linewidth',2);
% xlabel('\it{t}','FontName','Times New Roman','FontSize',26);
% ylabel('\it{z(t)}','FontName','Times New Roman','FontSize',26);
% figure(2)
% plot(x(:,1),x(:,3)','c:','linewidth',2);
% xlabel('\it{x}','FontName','Times New Roman','FontSize',26);
% ylabel('\it{z}','FontName','Times New Roman','FontSize',26);