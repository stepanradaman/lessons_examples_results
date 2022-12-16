x = 0:0.05:1; % массив от 0 до 1 с шагом 0.05
y = exp(-x).*sin(10*x); % поэлементно
plot(x, y); % с пробелом

disp(myfunction(2))

function f = myfunction(x)
  f = x*x;
end



