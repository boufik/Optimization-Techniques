clear all
clc

x10 = 4;
x20 = -1;
gamma = 0.1;
maxKathodos(x10, x20, gamma);
 
function maxKathodos(x10, x20, gamma)
    
    % 1. ����� �� � ��� �������� ����������� ��� �� 0.01
    epsilon = 0.01;
    syms x1 x2
    f = (x1^2 + x2^2) / 2;
    F = matlabFunction(f);
    klisi = gradient(f, [x1,x2]);
    KLISI = matlabFunction(klisi);
    
    % 2. ����� ��� ������ ��� �� ���������� �� x1i, x2i. ��� ������� x1List,
    % x2List, �� ���� ������ ��� ��� ����� ��� f ��� ��� ������ ��� ������
    % ��� �� ����� 2 ������
    k = 1;
    x1List = [];             x2List = [];
    x1List(1) = x10;          x2List(1) = x20;
    fList = [];             normKlisisList = [];
    fList(1) = subs(f, {x1,x2}, {x1List(length(x1List)), x2List(length(x2List))});
    normKlisisList(1) = norm(subs(klisi, {x1,x2}, {x1List(length(x1List)), x2List(length(x2List))}));
 
    
    while normKlisisList(length(normKlisisList)) > epsilon
        k = k + 1;
        dk = -KLISI(x1List(length(x1List)), x2List(length(x2List)))
        % �� dk ����� 2*1 ��������, �� 1� �������� ��� ����� ��� ����������
        % ��� x1 ��� �� 2� ��� ���������� ��� x2
        % xk+1 = xk + �k*dk = xk - �k * grad(f(xk))
        x1List(k) = x1List(k-1) + gamma * dk(1);
        x2List(k) = x2List(k-1) + gamma * dk(2);
        fList(k) = F(x1List(length(x1List)), x2List(length(x2List)));
        normKlisisList(k) = norm(subs(klisi, {x1,x2}, {x1List(length(x1List)), x2List(length(x2List))}));
    end
    
    
    x1List
    x2List
    fList
    normKlisisList
    k
    % �� ��������� xk, yk ���� ������ �� ������� �� �������� xx ��� yy
    display('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    display('~~~~~~~~ About the last found x1k (x1x1) and x2k (x2x2) ~~~~~~~~')
    display('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    x1x1 = x1List(length(x1List))
    x2x2 = x2List(length(x2List))
    F_xx_yy = fList(length(fList))
    NORM_KLISIS = normKlisisList(length(normKlisisList))
    % Plots
    figure(1);
    plot(fList, 'x');
    title("Values of f for every step k")
    xlabel('Step k');
    ylabel("f(x1k, x2k)");
    figure(2);
    plot(x1List, 'ro');
    title("Spots x1 (red), x2 (blue)");
    xlabel("Steps k");
    ylabel("x1(k), x2(k)");
    hold on
    plot(x2List, 'bo')
    title("Spots x1 (red), x2 (blue)");
    xlabel("Steps k");
    ylabel("x1(k), x2(k)");
    display('**********************************************************')
end