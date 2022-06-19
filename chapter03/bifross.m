%% Clear workspace, clear Command Window, close all Figure windows.
%% Bifurcation diagrams for the R¨ossler system.
clear; clc;
a = 0.2;
b = 0.2;
cs = linspace(0,250,500);
fonts=24;
Z = [];
for cc=cs
    params = [a,b,cc];
    x = 1; y =1; z = 1;
    tspan = 0:0.1:100;
    [T2,Y2]=ode45(@(t,X) Rossler(t,X,params),tspan,[x;y;z]); 
    Y3 = Y2(500:end,1);
    N = length(Y3(:,1));
    for i = 2:N-1
        dz = (Y3(i+1,1) -Y3(i,1))*(Y3(i,1)-Y3(i-1,1));
        ddz = Y3(i+1,1)+Y3(i-1,1)-2*Y3(i,1);
        zn = Y3((dz<0).*(ddz<0)==1,1);
        if (dz<0 && ddz<0)
            Z = [Z; cc Y3(i,1)];
        end
    end
end
save bif.mat Z
figure;
fonts=20;
set(gcf,'unit','centimeters','position',[10,6 20 13])
plot(Z(:,1),Z(:,2),'.','LineWidth',1.5)
xlabel('\fontsize{20}c','FontSize',fonts)
ylabel('\fontsize{20}x','FontSize',fonts)
set(gca,'FontSize',20)
%set(gca,'YTick',0.4:0.1:1,'FontSize',fsize)
%print('bifross','-depsc')

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
