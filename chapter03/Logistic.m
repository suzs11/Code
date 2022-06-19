n=10000;
a=3.0:0.001:4;   %����ȡ��0.001����ԭ��ĸ���ϸ
len=length(a);
a=reshape(a,len,1);
sum=zeros(len,1);
unit=ones(len,1);
x=unit*0.1;
for i=1:n
    y=a.*(unit-2*x);
    sum=sum+log(abs(y));
    x=a.*x.*(unit-x);
end
fsize = 20;
lamuda=sum/10000;%���������޸Ĺ�
set(gcf,'position',[500,400,900,270]);
subplot(121)
plot(a,lamuda,'.')
line([3,4],[0,0],'Color','k','Linewidth',1)
%grid on
set(gca,'XTick',3:0.25:4,'FontSize',fsize)
set(gca,'YTick',-8:2:3,'FontSize',fsize)
xlabel('\fontsize{18}\mu')
ylabel('\fontsize{15}Lyapunov Exponent') 
title('a','FontSize',fsize)
%title('\fontsize{16}a\fontname{}，Lyapunov\fontname{指数}ָĹ�ϵ')

%% bifurcation diagram
fsize=20;
u=0:0.001:4;
X=ones(250,4001);
X(1,:)=0.3*X(1,:);
for j=1:250
    X(j+1,:)=u.*(X(j,:)-X(j,:).^2);
end
%set(gcf,'unit','centimeters','position',[20,10,10,6]);
u1=3.5:0.001:4;
X1=ones(250,501);
X1(1,:)=0.3*X1(1,:);
for j=1:250
    X1(j+1,:)=u1.*(X1(j,:)-X1(j,:).^2);
end
%set(gcf,'position',[500,400,900,270]);
subplot(122)
plot(u1,X1(150:end,:),'k.')
xlim([3.5,4])
set(gca,'Xtick',3.5:0.1:4,'FontSize',fsize);
set(gca,'Ytick',0:0.2:1,'FontSize',fsize)
xlabel('\fontsize{18}\mu')
ylabel('\fontsize{18}x')
title('b','FontSize',fsize)
axes('position',[0.55,0.55,0.3,0.3])
plot(u,X(150:end,:),'k.')
%saveas(gcf,'lBL','epsc')

%% The Plot skills
% 绘制原图
% x=0:0.01:10;
% y=sin(10*x);
% figure;
% ax1=axes;
% plot(ax1,x,y,'LineWidth',1);
% ylim([-1,2.6]);
% % 绘制子图
% fig=ax1.Parent;
% ax2=copyobj(ax1,fig);
% set(ax2,'Position',[.5 .6 .3 .3],'XLim',[1.25,1.60],'YLim',[0.5,1.2]);
% % 绘制选框
% rec=rectangle(ax1,'Position',[ax2.XLim(1), ax2.YLim(1), diff(ax2.XLim), diff(ax2.YLim)]);
% % 绘制连线(该部分不需要更改)
% XLp=ax2.Position(1);
% XRp=sum(ax2.Position([1,3]));
% YDp=ax2.Position(2);
% YUp=sum(ax2.Position([2,4]));
% XLr=ax1.Position(1)+ax1.Position(3)/diff(ax1.XLim)*(rec.Position(1)-ax1.XLim(1));
% XRr=ax1.Position(1)+ax1.Position(3)/diff(ax1.XLim)*(sum(rec.Position([1,3]))-ax1.XLim(1));
% YDr=ax1.Position(2)+ax1.Position(4)/diff(ax1.YLim)*(rec.Position(2)-ax1.YLim(1));
% YUr=ax1.Position(2)+ax1.Position(4)/diff(ax1.YLim)*(sum(rec.Position([2,4]))-ax1.YLim(1));
% ano(1)=annotation('arrow',[0,0],[0,0]);
% ano(2)=annotation('arrow',[0,0],[0,0]);
% ano(3)=annotation('arrow',[0,0],[0,0]);
% ano(4)=annotation('arrow',[0,0],[0,0]);
% set(ano(1),'X',[XLr,XLp],'Y',[YDr,YDp],{'HeadLength','HeadWidth'},{0,0});
% set(ano(2),'X',[XLr,XLp],'Y',[YUr,YUp],{'HeadLength','HeadWidth'},{0,0});
% set(ano(3),'X',[XRr,XRp],'Y',[YDr,YDp],{'HeadLength','HeadWidth'},{0,0});
% set(ano(4),'X',[XRr,XRp],'Y',[YUr,YUp],{'HeadLength','HeadWidth'},{0,0});
% set(ano(1),'Visible','off');
% set(ano(4),'Visible','off');
% % 标签
% xlabel('X');
% ylabel('Y');
% title('Title');
% % 调节尺寸
% set(gcf,'Units','centimeters','Position',[2 2 15 8]);
% % 导出图片
% exportgraphics(gcf,'003.png','Resolution',600)
