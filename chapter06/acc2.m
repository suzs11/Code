Acc_D = [0.924824,0.932152; 0.957174,0.957225; 0.913783,0.948758];
b =bar(Acc_D);
grid on;
ylim([0.90,1]);
ch = get(b,'children');
set(gca,'XTickLabel',{'CNN1','VGG19 Trans','VGG'},'fontsize',16)
%set(ch,'FaceVertexCData',[1 0 1;0 0 0;])
legend('Direct','RP','Box','off');
xlabel('\bf{Model}','fontsize',20);
ylabel('\bf{Accuracy}','fontsize',20);


% for i=1:2 
% xtips1 = b(i).XEndPoints;
% ytips1 = b(i).YEndPoints; %获取 Bar 对象的 XEndPoints 和 YEndPoints 属性
% labels1 = string(b(i).YData); %获取条形末端的坐标
% text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
%     'VerticalAlignment','bottom');
% end

Acc_9 = [0.9650,0.9733; 0.9802,0.9848; 0.9742,0.9733];
figure(2);
b1 =bar(Acc_9);
ylim([0.90,1]);
grid on;
ch = get(b1,'children');
set(gca,'XTickLabel',{'M_2','VGG16','ResNet18'},'fontsize',16)
%set(ch,'FaceVertexCData',[1 0 1;0 0 0;])
legend('Direct','RP','Box','off');
xlabel('\bf{Model}','fontsize',20);
ylabel('\bf{Accuracy}','fontsize',20);