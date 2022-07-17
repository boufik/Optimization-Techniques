clear all
clc

% Ο πίνακας μου θα περιέχει τις εξής τιμές ακρίβειας l ----> 0.0001, 0.001
% και 0.01

l = [0.0001, 0.001, 0.01];
for index = 1:length(l)
    plotAkrwn(l(index), index);
end


function akra = plotAkrwn(l, index)
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
    % Για το πλοτάρισμα των άκρων με συγκεκριμένο στυλ, αξιποιώ το index
    if index == 1
        plot(akra1, 'ro');
        plot(akra2, 'bo');
        title("Edges of f1 for l = 0.0001, 0.001, 0.01");
        xlabel('Steps k');
        ylabel('Edges Ak and Bk');
        hold on
    elseif index == 2
        plot(akra1, 'r^');
        plot(akra2, 'b^');
        title("Edges of f1 for l = 0.0001, 0.001, 0.01");
        xlabel('Steps k');
        ylabel('Edges Ak and Bk');
        hold on
    else
        plot(akra1, 'r*');
        plot(akra2, 'b*');
        title("Edges of f1 for l = 0.0001, 0.001, 0.01");
        xlabel('Steps k');
        ylabel('Edges Ak and Bk');
        hold on
    end
    akra1
    akra2
    display("**********************************")
end


