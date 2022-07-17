clear all
clc
 
elaxistoMeGammaMetavlhto(-1, -1, 0.1, 1, 0);
elaxistoMeGammaMetavlhto(-1, -1, 0.5, 1.5, 1);
 
 
function elaxistoMeGammaMetavlhto(x0, y0, akro1, akro2, flag)
    
    % 1. ����� �� � ��� �������� ����������� ��� �� 2/1000
    epsilon = 0.002;
    syms x y
    f = x^3 * exp(-x^2-y^4);
    klisi = gradient(f, [x,y]);
    essianos = jacobian(klisi)
    dk = - inv(essianos) * klisi
    DK = matlabFunction(dk);
    
    % 2. ����� ��� ������ ��� �� ���������� �� xi, yi. ��� ������� xList,
    % yList, �� ���� ������ ��� ��� ����� ��� f (fList) ��� ��� ������ ���
    % ������ ��� (normKlisisList) �� ����� 2 ������
    k = 1;
    xList = [];             yList = [];
    xList(1) = x0;          yList(1) = y0;
    fList = [];             normKlisisList = [];        gammaList = [];
    fList(1) = subs(f, {x,y}, {xList(length(xList)), yList(length(yList))});
    normKlisisList(1) = norm(subs(klisi, {x,y}, {xList(length(xList)), yList(length(yList))}));
    gammaList(1) = 0;
    
    while normKlisisList(length(normKlisisList)) > epsilon
        k = k + 1;
        % dk = -subs(klisi, {x,y}, {xList(length(xList)), yList(length(yList))});     % � ����� ����
        % �� dk ����� 2*1 ��������, �� 1� �������� ��� ����� ��� ����������
        % ��� x ��� �� 2� ��� ���������� ��� y
        % ������ �� � ��� �� ������� �� ����� minimize ��� f(xk + �kdk)
        xPrin = xList(k-1);
        yPrin = yList(k-1);
        dkVector = DK(xList(k-1), yList(k-1));          % A 2x1 vector
        
        % ********************************************************************************************
        % ************************** ��������� �������������� ****************************************
        % ********************************************************************************************
        gamma = internalOptimization(f, xPrin, yPrin, dkVector, akro1, akro2);
        
       
        xList(k) = xPrin + gamma * dkVector(1);
        yList(k) = yPrin + gamma * dkVector(2);
        fList(k) = subs(f, {x,y}, {xList(length(xList)), yList(length(yList))});
        normKlisisList(k) = norm(subs(klisi, {x,y}, {xList(length(xList)), yList(length(yList))}));
        gammaList(k) = gamma;
    end
    
    xList
    yList
    fList
    normKlisisList
    k
    gammaList
    % �� ��������� xk, yk ���� ������ �� ������� �� �������� xx ��� yy
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
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
        title('Red for 0.1 <= gamma <= 1, blue for 0.5 <= gamma <= 1.5');
        xlabel('Steps k');
        ylabel('Values of f');
        hold on
    end
    display('**********************************************************')
end
 
 
 
 
 
 
 
 
function gamma = internalOptimization(f, xPrin, yPrin, dk, akro1, akro2)
    syms x y G
    X = xPrin + G * dk(1);
    Y = yPrin + G * dk(2);
    % �����, �� ��� X,Y ����� ��� ���� ������� ��������� �� G = �k
    % � F ��� ���� �������� ����� ���� ��������� ��� G
    F = subs(f, {x,y}, {X, Y});
    DF = diff(F, 'G');
    l = 0.005;
    counter = 0;
    while akro2 - akro1 > l
        counter = counter + 1;
        kentro = (akro1 + akro2) / 2;
        paragwgos = subs(DF, kentro);
        if paragwgos > 0
            akro2 = kentro;
        else
            akro1 = kentro;
        end
     end
     % �� ���������� akra1, akra2 ���� �� ����� ��� ����������� �����
     % ������� ������������� �����. �� ���� ��� ���� ��� ���� ��� �� ������
     % � ��� �� ������� �� ���������
     gamma = (akro2 + akro1) / 2;
end