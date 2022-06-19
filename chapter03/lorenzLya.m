clc;clear;
format long;
Z=[];  
a=10; 
c=8/3; 
d0=eps; 
bs = linspace(0,250,5000);
for b=bs
    params = [a,b,c];
    x=1;y=1;z=1;   % #初始基准点
    x1=1;y1=1;z1=1+d0; % #初始偏离点

    tspan = 0:0.1:100;
    [~,Y1]=ode45(@(t,X) Lorenz(t,X,params),tspan,[x;y;z]); 
    n1=length(Y1); xt=Y1(ceil(n1/2):end,1);
    [~,Y2]=ode45(@(t,X) Lorenz(t,X,params),tspan,[x1;y1;z1]); 
    n2=length(Y2);xt_e=Y2(ceil(n2/2):end,1);      

    lsum = mean(log(abs(xt-xt_e)));
Z=[Z lsum]; 
end 
set(gcf,'Position',[488 241 700 400]);
%save fangcheng.txt Y  -ascii;
%save fangcheng Z
plot(bs,Z,'.'); 
axis([0 250 -50 10]);
line([0,250],[0,0],'LineWidth',2,'color','k');
%title('Lorenz System''s LLE v.s. parameter b') 
xlabel('\it{r}','FontName','Times New Roman','FontSize',25) 
ylabel('\it{\lambda}','FontName','Times New Roman','FontSize',25)
set(gca,'FontSize',20)
print('LyaL','-depsc')
%saveas(gcf,'Ly.eps')

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
