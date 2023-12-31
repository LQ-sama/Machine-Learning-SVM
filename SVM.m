%%%%%%%%%%%%%%%%%%% SVM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% 数据生成 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = 100;                % 样本量大小
center1 = [1,1];        % 第一类数据中心
center2 = [6,6];        % 第二类数据中心
%线性可分数据：center2 = [6,6]；线性不可分数据，改为center2 = [3,3]
X = zeros(2*n,2);       % 2n * 2的数据矩阵，每一行表示一个数据点，第一列表示x轴坐标，第二列表示y轴坐标
Y = zeros(2*n,1);       % 类别标签
X(1:n,:) = ones(n,1)*center1 + randn(n,2);
X(n+1:2*n,:) = ones(n,1)*center2 + randn(n,2);       %矩阵X的前n行表示类别1中数据，后n行表示类别2中数据
Y(1:n) = 1; 
Y(n+1:2*n) = -1;        % 第一类数据标签为1，第二类为-1 

figure(1)
set (gcf,'Position',[1,1,700,600], 'color','w')
set(gca,'Fontsize',18)
plot(X(1:n,1),X(1:n,2),'go','LineWidth',1,'MarkerSize',10);            % 画第一类数据点
hold on;
plot(X(n+1:2*n,1),X(n+1:2*n,2),'b*','LineWidth',1,'MarkerSize',10);    % 画第二类数据点
hold on;
xlabel('x axis');
ylabel('y axis');
legend('class 1','class 2');

%%%%%%%%%%%%%%%%%%  SVM模型   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  学生实现,求出SVM的参数(w,b)     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w = zeros(2,1);
b = zeros(1);               % SVM: y = x*w + b
alpha = zeros(2*n,1);       % 对偶问题变量
X1=zeros(2*n,2);
%lamuda=λ
lamuda=0.3;
%sita=η
sita=0.0001;
onne=ones(2*n,1);
%beita=β
beita=0.2;
C=0.5;
for i=1:1:2*n %构造对偶问题
X1(i,1)=X(i,1)*Y(i,1);
X1(i,2)=X(i,2)*Y(i,1);
end

for i=1:1:9999  %设置循环上限
alpha=alpha-sita*(X1*X1'*alpha-onne+lamuda*Y+beita*Y'*alpha*Y);
for j=1:1:2*n   %对alpha进行判断遍历

if  alpha(j,1)>=0&&alpha(j,1)<=C
    alpha(j,1)=alpha(j,1);
end
if alpha(j,1)<0
    alpha(j,1)=0;
end
if alpha(j,1)>C
    alpha(j,1)=C;
end

end  %判断遍历完成

lamuda=lamuda+beita*(Y'*alpha); 
end

w = sum(repmat(alpha .* Y, 1, 2) .* X, 1)';

for j=1:1:2*n
if alpha(j,1)>0&&alpha(j,1)<C
    break
end
end
for i=1:1:2*n
b=b+alpha(i,1)*Y(i,1)*(X(i,:)*X(j,:)');
end

b=Y(j,1)-b;

%%%%%%%% %%%%%%%% 使用线性增广拉格朗日法训练模型


%%%%%%%%%%%%%%%%  分类器可视图  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% 即画出 x*w + b =0 的图像 %%%%%%%%%%%%%%%%%%%%%%%%%%%%

x1 = -2 : 0.00001 : 7;
y1 = ( -b * ones(1,length(x1)) - w(1) * x1 )/w(2);         % 分类界面
                                                           % x1为分类界面横轴，y1为纵轴
y2 = ( ones(1,length(x1)) - b * ones(1,length(x1)) - w(1) * x1 )/w(2);
y3 = ( -ones(1,length(x1)) - b * ones(1,length(x1)) - w(1) * x1 )/w(2);  %画出间隔边界

figure(4)
set (gcf,'Position',[1,1,700,600], 'color','w')
set(gca,'Fontsize',18)
plot(X(1:n,1),X(1:n,2),'go','LineWidth',1,'MarkerSize',10);            % 画第一类数据点
hold on;
plot(X(n+1:2*n,1),X(n+1:2*n,2),'b*','LineWidth',1,'MarkerSize',10);    % 画第二类数据点
hold on;
plot( x1,y1,'k','LineWidth',1,'MarkerSize',10);                         % 画分类界面
hold on;
plot( x1,y2,'k-.','LineWidth',1,'MarkerSize',10);                         % 画分间隔边界
hold on;
plot( x1,y3,'k-.','LineWidth',1,'MarkerSize',10);                         % 画分间隔边界
hold on;
plot(X(alpha>0,1),X(alpha>0,2),'rs','LineWidth',1,'MarkerSize',10);    % 画支持向量
hold on;
plot(X(alpha<C&alpha>0,1),X(alpha<C&alpha>0,2),'rs','MarkerFaceColor','r','LineWidth',1,'MarkerSize',10);    % 画间隔边界上的支持向量
hold on;
xlabel('x axis');
ylabel('y axis');
set(gca,'Fontsize',10)
legend('class 1','class 2','classification surface','boundary','boundary','support vectors','support vectors on boundary');
