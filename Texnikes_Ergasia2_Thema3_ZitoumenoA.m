clear all
clc

%{
syms x y
f = x^3 * exp(-x^2-y^4)
klisi = gradient(f, [x,y])
essianos = jacobian(klisi)
dk = - inv(essianos) * klisi
DK = matlabFunction(dk);
%}

elaxistoMeGammaStathero(-1, -1, 0.2, 0);
elaxistoMeGammaStathero(-1, -1, 0.5, 1);
 
function elaxistoMeGammaStathero(x0, y0, gamma, flag)
    
    % 1. ����� �� � ��� �������� ����������� �� �� 1/100 ��� ����������
    % ��� ����� ��� ���� ��� �� = ������� ���
    epsilon = gamma / 100;
    syms x y
    f = x^3 * exp(-x^2-y^4);
    klisi = gradient(f, [x,y]);
    essianos = jacobian(klisi)
    dk = - inv(essianos) * klisi
    DK = matlabFunction(dk);
    
    % 2. ����� ��� ������ ��� �� ���������� �� xi, yi. ��� ������� xList,
    % yList, �� ���� ������ ��� ��� ����� ��� f ��� ��� ������ ��� ������
    % ��� �� ����� 2 ������
    k = 1;
    xList = [];             yList = [];
    xList(1) = x0;          yList(1) = y0;
    fList = [];             normKlisisList = [];
    fList(1) = subs(f, {x,y}, {xList(length(xList)), yList(length(yList))});
    normKlisisList(1) = norm(subs(klisi, {x,y}, {xList(length(xList)), yList(length(yList))}));
 
    
    while normKlisisList(length(normKlisisList)) > epsilon
        k = k + 1;
        % dk = -subs(klisi, {x,y}, {xList(length(xList)), yList(length(yList))});
        % �� dk ����� 2*1 ��������, �� 1� �������� ��� ����� ��� ����������
        % ��� x ��� �� 2� ��� ���������� ��� y
        % xk+1 = xk + �k*dk = xk - �k * grad(f(xk))
        dkVector = DK(xList(k-1), yList(k-1));          % A 2x1 vector
        xList(k) = xList(k-1) + gamma * dkVector(1);
        yList(k) = yList(k-1) + gamma * dkVector(2);
        fList(k) = subs(f, {x,y}, {xList(length(xList)), yList(length(yList))});
        normKlisisList(k) = norm(subs(klisi, {x,y}, {xList(length(xList)), yList(length(yList))}));
    end
    
    
    xList
    yList
    fList
    normKlisisList
    k
    % �� ��������� xk, yk ���� ������ �� ������� �� �������� xx ��� yy
    display('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    display('~~~~~~~~ About the last found xk (xx) and yk (yy) ~~~~~~~~')
    display('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    xx = xList(length(xList))
    yy = yList(length(yList))
    F_xx_yy = fList(length(fList))
    NORM_KLISIS = normKlisisList(length(normKlisisList))
    if flag == 0
        plot(fList, 'ro');
        title('Red for gamma = 0.2, blue for gamma = 0.5');
        xlabel('Steps k');
        ylabel('Values of f');
        hold on
    else
        plot(fList, 'bx');
        title('Red for gamma = 0.2, blue for gamma = 0.5');
        xlabel('Steps k');
        ylabel('Values of f');
        hold on
    end
    display('**********************************************************')
end