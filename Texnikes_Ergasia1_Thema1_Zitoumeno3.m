clear all
clc

% ������� �� �� ������� l
l = [0.005, 0.01, 0.02];
epsilon = 0.001;
styles = ['o', '*', 'x'];
for index = 1:length(l)
    plotAkrwn(l(index), epsilon, styles(index))
end

function result = plotAkrwn(l, epsilon, style)
    syms x
    f1 = (x-2)^2 - sin(x+3);
    akro1 = 2;  akro2 = 5;
    % ����� ������ � < l
    epsilon = 0.001;    counter = 0;
    akra1 = [];    akra2 = [];      
    while (akro2 - akro1 > l)
        counter = counter + 1;
        akra1(counter) = akro1;
        akra2(counter) = akro2;
        % ���� 1
        x1k = (akro1 + akro2) / 2 - epsilon;
        x2k = (akro1 + akro2) / 2 + epsilon;
        % ���� 2
        if subs(f1, x1k) < subs(f1, x2k)
            % ��+1 = �� (��� �������) ��� ��+1 = �2�
            akro2 = x2k;
        else
            % ��+1 = �1� ��� ��+1 = �� (��� �������)
            akro1 = x1k;
        end
    end

    % ���, ������ ���� �� ������ �������� ���� ������� �� x* = ���� ���������
    % ����� ������ ��� ������������ l,� ��� ������� ��� �������.
    counter = counter + 1;
    akra1(counter) = akro1;
    akra2(counter) = akro2;
    akra1
    akra2
    display(' '); display(' '); display(' '); display(' ');
    result = [];
    result(1) = akra1(length(akra1));
    result(2) = akra2(length(akra2));
    display(strcat('x* between ', num2str(result(1)), ' and ', num2str(result(2))));
    plot(akra1, style)
    xlabel('Steps k')
    ylabel('The two edges: ak and bk')
    title('f1 = (x-2)^2 - sin(x+3),  l = {5,10,20}/1000 and epsilon = 1/1000')
    hold on
    plot(akra2, style)
    hold on
    display('*******************************************************')
end


