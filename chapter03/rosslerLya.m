clc;clear;
format long;
Z=[];  
a = 0.2;
b = 0.2;
d0=eps; 
bs = linspace(0,250,5000);
for c=bs
    params = [a,b,c];
    x=1;y=1;z=1;   % #初始基准点
    x1=1+d0;y1=1+d0;z1=1+d0; % #初始偏离点

    tspan = 0:0.1:2000;
    [~,Y1]=ode45(@(t,X) Rossler(t,X,params),tspan,[x;y;z]); 
    n1=length(Y1); xt=Y1(ceil(n1/2):end,1);
    [~,Y2]=ode45(@(t,X) Rossler(t,X,params),tspan,[x1;y1;z1]); 
    n2=length(Y2);xt_e=Y2(ceil(n2/2):end,1);      

    lsum = mean(log(abs(xt-xt_e)));
Z=[Z lsum]; 
end 
figure;
set(gcf,'unit','centimeters','position',[10,6 20 13])
plot(bs,Z,'.'); 
%axis([0 250 -30 10])
line([0,250],[0,0],'LineWidth',2,'color','k');
%title('Lorenz System''s LLE v.s. parameter b') 
xlabel('\fontsize{20}c','FontSize',20)
ylabel('\fontsize{20}\lambda','FontSize',20)
set(gca,'FontSize',20)
print('LyaR','-depsc')
save shu.mat Z
%saveas(gcf,'Ly.eps')

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
