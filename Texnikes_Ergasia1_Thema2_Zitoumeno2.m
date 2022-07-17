clear all
clc

% Ο πίνακας μου θα περιέχει τις 3 εξής τιμές για το l
l(1) = 0.0001;
l(2) = 0.001;
l(3) = 0.01;

for index = 1:length(l)
    plotAkrwn(l(index), index);
end


function akra = plotAkrwn(l, index)
    l
    syms x
    f1 = (x-2)^2-sin(x+3); 
    akro1 = 2;      akro2 = 5;      gamma = 0.618;
    x1 = akro1;     x2 = akro2;    
    % Τα παρακάτω είναι flag που μου λένε κάθε φορά ποιο εκ των x1, x2
    % έγινε άκρο προηγουμένως
    egineAkroToX1 = -1000;     egineAkroToX2 = -1000;
    akra1 = [];     akra2 = [];
    counter = 0;
    calculations = 0;
    
    while akro2 - akro1 > l
        
        counter = counter + 1;      % Μετράει τα steps k
        % Στην 1η και μόνο επανάληψη απαιτείται ο υπολογισμός 2 τιμών της
        % δεδομένης συνάρτησης, γιατί μετά το ένα εκ των 2 xk γίνεται άκρο
        % του νέου διαστήματος και επομένως κάνουμε έναν νέο υπολογισμό
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
                % ak+1 = ak και bk+1 = x2k, αλλάζει το δεξιό μόνο άκρο
                % Επίσης για την επόμενη επανάληψη, ξέρω ότι
                % x2,k+1 = x1,k (το νέο x2 ισούται με το πριν x1 και βάζουμε x1,
                % γιατί το x2 "έχει χρησιμοποιηθεί ως νέο άκρο)
                % Η τιμή του νέου x1 θα καθοριστεί μετά
            else
                % Νέο διάστημα ----> [x1k, bk]
                ThaGineiAkroToX1 = 1;
                ThaGineiAkroToX2 = 0;
            end
        
        % **************** COUNTER > 1 ****************
        elseif counter > 1
            % Ουσιαστικά εδώ που το step k > 1, θα έχω έναν νέο υπολογισμό
            % της συνάρτησης μου
            if ThaGineiAkroToX2 == 1
                % Το x1 απαιτεί νέο υπολογιμό
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
    % ΠΛΟΤΑΡΙΣΜΑ
    if index == 1
        plot(akra1, 'ro');
        hold on
        plot(akra2, 'bo');
        hold on
    elseif index == 2
        plot(akra1, 'r^');
        hold on
        plot(akra2, 'b^');
        hold on
    else
        plot(akra1, 'rx');
        hold on
        plot(akra2, 'bx');
        hold on
    end
    title('f1: Edges Ak, Bk for every step k');
    xlabel('Steps k');
    ylabel('Ak (red), Bk (blue)');
    
    display('*************************************************');
    display(' ');
end


