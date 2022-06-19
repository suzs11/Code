%% Geometric analysis of logistic model
% Program 3a: Graphical iteration.
%clear;
% Initial condition 0.2001, must be symbolic.
nmax=20;
t=sym(zeros(1,nmax));t1=sym(zeros(1,nmax));t2=sym(zeros(1,nmax));
t(1)=sym(0.3);
%mu = 3.2;
%mu=3.5;
mu=2.5;
%mu = 4;
halfm=nmax/2;
axis([0 1 0 1]);
for n=2:nmax
    if (double(t(n-1)))>0 && (double(t(n-1)))<=1
    t(n)=sym(mu*t(n-1)*(1-t(n-1)));
    end
end
for n=1:halfm
    t1(2*n-1)=t(n);
    t1(2*n)=t(n);
end
t2(1)=0;t2(2)=double(t(2));
for n=2:halfm
    t2(2*n-1)=double(t(n));
    t2(2*n)=double(t(n+1));
end
set(gcf,'position',[500,400,800,300]);
subplot(121)
hold on
fsize=16;
plot(double(t1),double(t2),'r');
x=0:0.01:1;y=mu.*x.*(1-x);
plot(x,y,'b');
x=[0 1];y=[0 1];
plot(x,y,'g');
%title('Graphical iteration for the logistic map','FontSize',fsize)
title('a','FontSize',fsize)
set(gca,'XTick',0:0.2:1,'FontSize',fsize)
set(gca,'YTick',0:0.2:1,'FontSize',fsize)
xlabel('x','FontSize',fsize)
ylabel('f_\mu','FontSize',fsize)
hold off
subplot(122)
iter=200;
xx=zeros(1,iter+1);
xx(1)=0.3;
for i=1:iter
    xx(i+1)=mu*xx(i)*(1-xx(i));
end
plot(xx,'LineWidth',1);
title('b','FontSize',fsize)
ylim([0,1])
set(gca,'XTick',0:40:200,'FontSize',fsize);
set(gca,'YTick',0:0.2:1,'FontSize',fsize);
xlabel('n','FontSize',fsize)
ylabel('X_n','FontSize',fsize)