x = 0:0.05:1; % ������ �� 0 �� 1 � ����� 0.05
y = exp(-x).*sin(10*x); % �����������
plot(x, y); % � ��������

disp(myfunction(2))

function f = myfunction(x)
  f = x*x;
end



