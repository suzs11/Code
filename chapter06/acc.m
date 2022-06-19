Acc_D = [0.913783,0.969380; 0.982499,0.971580; 0.972030,0.970579];
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

Acc_25 = [0.9810,0.9888; 0.9823,0.9962; 0.9887,0.9882];
figure(2);
b1 =bar(Acc_25);
grid on;
ylim([0.95,1]);
ch = get(b1,'children');
set(gca,'XTickLabel',{'M_2','VGG16','ResNet18'},'fontsize',16)
%set(ch,'FaceVertexCData',[1 0 1;0 0 0;])
legend('Direct','RP','Box','off');
xlabel('\bf{Model}','fontsize',20);
ylabel('\bf{Accuracy}','fontsize',20);