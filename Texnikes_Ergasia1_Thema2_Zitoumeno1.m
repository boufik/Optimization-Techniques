clear all
clc

% � ������� ��� �� �������� ������� l ���������� ��� 0.001 �� 0.05 �� ����
% 0.001 = 1/1000
for index = 1:1:50
    l(index) = index / 1000;
end

calculationsList = [];
for index = 1:length(l)
    calculationsList(index) = numOfCalculations(l(index));
end

plot([1:1:50], calculationsList, 'o');
title("f1 = (x-2)^2-sin(x+3), l = {1,..,50}/1000");
xlabel("l / 1000");
ylabel("Number of calculations needed");


function calculations = numOfCalculations(l)
    l
    syms x
    f1 = (x-2)^2-sin(x+3); 
    akro1 = 2;      akro2 = 5;      gamma = 0.618;
    x1 = akro1;     x2 = akro2;    
    % �� �������� ����� flag ��� ��� ���� ���� ���� ���� �� ��� x1, x2
    % ����� ���� ������������
    egineAkroToX1 = -1000;     egineAkroToX2 = -1000;
    akra1 = [];     akra2 = [];
    counter = 0;
    calculations = 0;
    
    while akro2 - akro1 > l
        
        counter = counter + 1;      % ������� �� steps k
        % ���� 1� ��� ���� ��������� ���������� � ����������� 2 ����� ���
        % ��������� ����������, ����� ���� �� ��� �� ��� 2 xk ������� ����
        % ��� ���� ����������� ��� �������� ������� ���� ��� ����������
        % **************** COUNTER = 1 ****************
        if counter == 1
            x1 = akro1 + (1-gamma) * (akro2 - akro1);
            x2 = akro1 + gamma * (akro2 - akro1);
            value1 = subs(f1, x1);
            value2 = subs(f1, x2);
            calculations = calculations + 2;
            if value1 < value2
                ThaGineiAkroToX2 = 1;
                ThaGineiAkroToX1 = 0;
                % ak+1 = ak ��� bk+1 = x2k, ������� �� ����� ���� ����
                % ������ ��� ��� ������� ���������, ���� ���
                % x2,k+1 = x1,k (�� ��� x2 ������� �� �� ���� x1 ��� ������� x1,
                % ����� �� x2 "���� �������������� �� ��� ����)
                % � ���� ��� ���� x1 �� ���������� ����
            else
                % ��� �������� ----> [x1k, bk]
                ThaGineiAkroToX1 = 1;
                ThaGineiAkroToX2 = 0;
            end
        
        % **************** COUNTER > 1 ****************
        elseif counter > 1
            % ���������� ��� ��� �� step k > 1, �� ��� ���� ��� ����������
            % ��� ���������� ���
            if ThaGineiAkroToX2 == 1
                % �� x1 ������� ��� ���������
                akro2 = x2;
                x2 = x1;
                x1 = akro1 + (1-gamma)*(akro2-akro1);
                calculations = calculations + 1;
                value1 = subs(f1, x1);
                value2 = subs(f1, x2);
                if value1 < value2 
                    ThaGineiAkroToX2 = 1;
                    ThaGineiAkroToX1 = 0;
                else
                    ThaGineiAkroToX1 = 1;
                    ThaGineiAkroToX2 = 0;
                end
                
            elseif ThaGineiAkroToX1 == 1
                akro1 = x1;
                x1 = x2;
                x2 = akro1 + gamma*(akro2-akro1);
                calculations = calculations + 1;
                value1 = subs(f1, x1);
                value2 = subs(f1, x2);
                if value1 < value2 
                    ThaGineiAkroToX2 = 1;
                    ThaGineiAkroToX1 = 0;
                else
                    ThaGineiAkroToX1 = 1;
                    ThaGineiAkroToX2 = 0;
                end
            end
            
        end
        akra1(counter) = akro1;
        akra2(counter) = akro2;
        % akro1
        % akro2
        % x1
        % x2
        
        
    end      % End of while-loop
    akra1
    akra2
    calculations
    display('*************************************************');
    display(' ');
end


