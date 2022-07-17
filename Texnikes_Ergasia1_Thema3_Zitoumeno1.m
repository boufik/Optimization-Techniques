clear all
clc

% Θα φτιάξω έναν πίνακα με διάφορες τιμές l από 0.001 ως 0.05,με βήμα 0.001
% Φυσικά και για κάθε l, θα έχω ένα n ---> n-2 "βήματα"/επαναλήψεις για να
% είναι θετικό και το όρισμα της F(n-k-1). Επίσης, θα έχω n-1 υπολογ. της f
l = [];
calculationsList = [];
akro1 = 2;
akro2 = 5;
for i=1:1:50
    l(i) = i/1000;
    calcs = numOfCalculations(l(i), akro1, akro2);
    calculationsList(i) = calcs;
end

plot([1:1:50], calculationsList, 'o');
title("f1: Number of calculations needed");
xlabel("Precision l (*1/1000)");
ylabel("Calculations for this l");



% ********************************************
% ************** Main Function ***************
% ********************************************
function calculations = numOfCalculations(l, akro1, akro2)
    l
    n = findN(l, akro1, akro2)
    syms x
    f = (x-2)^2-sin(x+3);
    a = [];         b = [];             % Οι λίστες με τα άκρα ak, bk
    x1 = [];            x2 = [];
    calculations = 0;
    bima2 = -1000;      bima3 = -1000;
    
    for k = 1:1:n-2
        a(k) = akro1;
        b(k) = akro2;
        x1(k) = a(k) + F(n-k-1)/F(n-k+1) * (b(k)-a(k));
        x2(k) = a(k) + F(n-k)/F(n-k+1) * (b(k)-a(k));
        
        if k == 1
            value1 = subs(f, x1(k));
            value2 = subs(f, x2(k));
            calculations = calculations + 2;
            if value1 > value2
                bima2 = 1;
                bima3 = 0;
            else
                bima3 = 1;
                bima2 = 0;
            end
            
        elseif k > 1
            if bima2 == 1
                % Σημαίνει ότι akro1,neo = x1,prin, .....
                a(k) = x1(k-1);
                b(k) = b(k-1);
                x1(k) = x2(k-1);
                x2(k) = a(k) + F(n-k)/F(n-k+1) * (b(k)-a(k));
                calculations = calculations + 1;
                value1 = subs(f, x1(k));
                value2 = subs(f, x2(k));
                if value1 > value2
                    bima2 = 1;
                    bima3 = 0;
                else
                    bima3 = 1;
                    bima2 = 0;
                end
            elseif bima3 == 1
                a(k) = a(k-1);
                b(k) = x2(k-1);
                x1(k) = a(k) + F(n-k-1)/F(n-k+1) * (b(k)-a(k));
                x2(k) = x1(k-1);
                calculations = calculations + 1;
                value1 = subs(f, x1(k));
                value2 = subs(f, x2(k));
                if value1 > value2
                    bima2 = 1;
                    bima3 = 0;
                else
                    bima3 = 1;
                    bima2 = 0;
                end
            end
        end
        % k
        % a(k)
        % b(k)
        % x1(k)
        % x2(k)
        
    end         % End of for-loop (k=1,2,3,....,n-2)
    a
    b
    x1
    x2
    calculations
    display('***********************************************');
    display(' ');
end




% ********************************************
% **************** Function 1 ****************
% ********************************************
function answer = F(n)
    if n == 0
        answer = 1;
    elseif n == 1
        answer = 1;
    elseif n == 2
        answer = 2;
    else
        Fibo(1) = 1;
        Fibo(2) = 2;
        for i = 3:1:n
            Fibo(i) = Fibo(i-1) + Fibo(i-2);
        end
        answer = Fibo(n);
    end    
end


% ********************************************
% **************** Function 2 ****************
% ********************************************
function result = findN(l, akro1, akro2)
    orio = (akro2 - akro1) / l;
    n = 2;
    while F(n) <= orio
        n = n+1;
    end
    result = n;
end