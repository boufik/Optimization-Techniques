clear all
clc

% Ο πίνακας μου θα περιέχει διάφορα l ξεκινώντας από 0.001 ως 0.05 με βήμα
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
ylabel("Number of derivative calcutaions needed");

function calculations = numOfCalculations(l)
    syms x
    f1 = (x-2)^2-sin(x+3);
    df1 = diff(f1, 'x'); 
    akro1 = 2;      akro2 = 5;
    akra1 = [];     akra2 = [];
    counter = 0;
    calculations = 0;
    
    while akro2 - akro1 > l
        counter = counter + 1;
        akra1(counter) = akro1;
        akra2(counter) = akro2;
        
        kentro = (akro1 + akro2) / 2;
        paragwgos = subs(df1, kentro);
        calculations = calculations + 1;
        if paragwgos > 0
            % Το ελάχιστο εμφανίζεται αριστερότερα του xk = kentro
            % Επομένως, το αριστερό άκρο παραμ΄νει και στο νέο διάστημα
            % όμως αλλάζει το δεξιό άκρο και γίνεται ίσο με xk = kentro
            akro2 = kentro;
        else
            % Ελάχιστο δεξιότερα του κέντρο, αλλάζω το άκρο 1
            akro1 = kentro;
        end
    end
    akra1
    akra2
    calculations
end


