%%%%%%%%%%%%%%%%%%% SVM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% �������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = 100;                % ��������С
center1 = [1,1];        % ��һ����������
center2 = [6,6];        % �ڶ�����������
%���Կɷ����ݣ�center2 = [6,6]�����Բ��ɷ����ݣ���Ϊcenter2 = [3,3]
X = zeros(2*n,2);       % 2n * 2�����ݾ���ÿһ�б�ʾһ�����ݵ㣬��һ�б�ʾx�����꣬�ڶ��б�ʾy������
Y = zeros(2*n,1);       % ����ǩ
X(1:n,:) = ones(n,1)*center1 + randn(n,2);
X(n+1:2*n,:) = ones(n,1)*center2 + randn(n,2);       %����X��ǰn�б�ʾ���1�����ݣ���n�б�ʾ���2������
Y(1:n) = 1; 
Y(n+1:2*n) = -1;        % ��һ�����ݱ�ǩΪ1���ڶ���Ϊ-1 

figure(1)
set (gcf,'Position',[1,1,700,600], 'color','w')
set(gca,'Fontsize',18)
plot(X(1:n,1),X(1:n,2),'go','LineWidth',1,'MarkerSize',10);            % ����һ�����ݵ�
hold on;
plot(X(n+1:2*n,1),X(n+1:2*n,2),'b*','LineWidth',1,'MarkerSize',10);    % ���ڶ������ݵ�
hold on;
xlabel('x axis');
ylabel('y axis');
legend('class 1','class 2');

%%%%%%%%%%%%%%%%%%  SVMģ��   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  ѧ��ʵ��,���SVM�Ĳ���(w,b)     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w = zeros(2,1);
b = zeros(1);               % SVM: y = x*w + b
alpha = zeros(2*n,1);       % ��ż�������
X1=zeros(2*n,2);
%lamuda=��
lamuda=0.3;
%sita=��
sita=0.0001;
onne=ones(2*n,1);
%beita=��
beita=0.2;
C=0.5;
for i=1:1:2*n %�����ż����
X1(i,1)=X(i,1)*Y(i,1);
X1(i,2)=X(i,2)*Y(i,1);
end

for i=1:1:9999  %����ѭ������
alpha=alpha-sita*(X1*X1'*alpha-onne+lamuda*Y+beita*Y'*alpha*Y);
for j=1:1:2*n   %��alpha�����жϱ���

if  alpha(j,1)>=0&&alpha(j,1)<=C
    alpha(j,1)=alpha(j,1);
end
if alpha(j,1)<0
    alpha(j,1)=0;
end
if alpha(j,1)>C
    alpha(j,1)=C;
end

end  %�жϱ������

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

%%%%%%%% %%%%%%%% ʹ�����������������շ�ѵ��ģ��


%%%%%%%%%%%%%%%%  ����������ͼ  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% ������ x*w + b =0 ��ͼ�� %%%%%%%%%%%%%%%%%%%%%%%%%%%%

x1 = -2 : 0.00001 : 7;
y1 = ( -b * ones(1,length(x1)) - w(1) * x1 )/w(2);         % �������
                                                           % x1Ϊ���������ᣬy1Ϊ����
y2 = ( ones(1,length(x1)) - b * ones(1,length(x1)) - w(1) * x1 )/w(2);
y3 = ( -ones(1,length(x1)) - b * ones(1,length(x1)) - w(1) * x1 )/w(2);  %��������߽�

figure(4)
set (gcf,'Position',[1,1,700,600], 'color','w')
set(gca,'Fontsize',18)
plot(X(1:n,1),X(1:n,2),'go','LineWidth',1,'MarkerSize',10);            % ����һ�����ݵ�
hold on;
plot(X(n+1:2*n,1),X(n+1:2*n,2),'b*','LineWidth',1,'MarkerSize',10);    % ���ڶ������ݵ�
hold on;
plot( x1,y1,'k','LineWidth',1,'MarkerSize',10);                         % ���������
hold on;
plot( x1,y2,'k-.','LineWidth',1,'MarkerSize',10);                         % ���ּ���߽�
hold on;
plot( x1,y3,'k-.','LineWidth',1,'MarkerSize',10);                         % ���ּ���߽�
hold on;
plot(X(alpha>0,1),X(alpha>0,2),'rs','LineWidth',1,'MarkerSize',10);    % ��֧������
hold on;
plot(X(alpha<C&alpha>0,1),X(alpha<C&alpha>0,2),'rs','MarkerFaceColor','r','LineWidth',1,'MarkerSize',10);    % ������߽��ϵ�֧������
hold on;
xlabel('x axis');
ylabel('y axis');
set(gca,'Fontsize',10)
legend('class 1','class 2','classification surface','boundary','boundary','support vectors','support vectors on boundary');
