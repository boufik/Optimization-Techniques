clear all
clc

% Πίνακας με τα διάφορα l
l = [];
epsilon = 0.001;
counter = 0;
for i = 3/1000 : 0.15/1000 : 15/1000
    counter = counter + 1;
    l(counter) = i;
end

counter2 = 0;
calculationsList = [];
for index = 1:length(l)
    counter2 = counter2 + 1;
    calcs = numOfCalculations(l(index), epsilon);
    calculationsList(counter2) = calcs;
end

plot(calculationsList, '*');
title("f1 = (x-2)^2-sin(x+3), l = {3,..,15}/1000, epsilon = 1/1000");
xlabel("Value of l");
ylabel("Number of calculations needed");

function calculations = numOfCalculations(l, epsilon)
    syms x
    f1 = (x-2)^2-sin(x+3);
    akro1 = 2;  akro2 = 5;
    % Πάντα πρέπει ε < l
    counter = 0;
    akra1 = [];    akra2 = [];      
    calculations = 0;
    
    while (akro2 - akro1 > l)
        counter = counter + 1;
        akra1(counter) = akro1;
        akra2(counter) = akro2;
        % Βήμα 1
        x1k = (akro1 + akro2) / 2 - epsilon;
        x2k = (akro1 + akro2) / 2 + epsilon;
        % Βήμα 2
        value1 = subs(f1, x1k);
        value2 = subs(f1, x2k);
        calculations = calculations + 2;
        if value1 < value2
            % ακ+1 = ακ (δεν αλλάζει) και βκ+1 = χ2κ
            akro2 = x2k;
        else
            % ακ+1 = χ1κ και βκ+1 = βκ (δεν αλλάζει)
            akro1 = x1k;
        end
    end

    % Εδώ, έχουμε βρει το τελικό διάστημα οπού υπάρχει το x* = θέση ελαχίστου
    % Πάντα μιλάμε για συγκεκριμένα l,ε που επιλέγω εγώ απαρχής.
    counter = counter + 1;
    akra1(counter) = akro1;
    akra2(counter) = akro2;
    % akra1
    % akra2
    display(' '); display(' '); display(' '); display(' ');
    result = [];
    result(1) = akra1(length(akra1));
    result(2) = akra2(length(akra2));
    display(strcat('x* between ', num2str(result(1)), ' and ', num2str(result(2))));
    calculations
    display('*******************************************************')
end

