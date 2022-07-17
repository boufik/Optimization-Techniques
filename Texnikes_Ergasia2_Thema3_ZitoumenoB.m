clear all
clc
 
elaxistoMeGammaMetavlhto(-1, -1, 0.1, 1, 0);
elaxistoMeGammaMetavlhto(-1, -1, 0.5, 1.5, 1);
 
 
function elaxistoMeGammaMetavlhto(x0, y0, akro1, akro2, flag)
    
    % 1. Ορίζω το ε της συνθήκης τερματισμού ίσο με 2/1000
    epsilon = 0.002;
    syms x y
    f = x^3 * exp(-x^2-y^4);
    klisi = gradient(f, [x,y]);
    essianos = jacobian(klisi)
    dk = - inv(essianos) * klisi
    DK = matlabFunction(dk);
    
    % 2. Ορίζω τις λίστες που θα τοποθετήσω τα xi, yi. Τις ονομάζω xList,
    % yList, θα βάζω επίσης και τις τιμές της f (fList) και του μέτρου της
    % κλίσης της (normKlisisList) σε άλλες 2 λίστες
    k = 1;
    xList = [];             yList = [];
    xList(1) = x0;          yList(1) = y0;
    fList = [];             normKlisisList = [];        gammaList = [];
    fList(1) = subs(f, {x,y}, {xList(length(xList)), yList(length(yList))});
    normKlisisList(1) = norm(subs(klisi, {x,y}, {xList(length(xList)), yList(length(yList))}));
    gammaList(1) = 0;
    
    while normKlisisList(length(normKlisisList)) > epsilon
        k = k + 1;
        % dk = -subs(klisi, {x,y}, {xList(length(xList)), yList(length(yList))});     % η κλίση πριν
        % Το dk είναι 2*1 διάνυσμα, το 1ο στοιχείο του αφορά τον υπολογισμό
        % του x και το 2ο τον υπολογισμό του y
        % Πρέπει το γ που θα επιλέξω να κάνει minimize την f(xk + γkdk)
        xPrin = xList(k-1);
        yPrin = yList(k-1);
        dkVector = DK(xList(k-1), yList(k-1));          % A 2x1 vector
        
        % ********************************************************************************************
        % ************************** Εσωτερική Βελτιστοποίηση ****************************************
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
    % Τα τελευταία xk, yk κάθε λίστας τα ονομάζω εν συντομία xx και yy
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
    % Πλέον, τα νέα X,Y έχουν σαν μόνη άγνωστη μεταβλητή το G = γk
    % Η F που έχει προκύψει είναι μόνο συνάρτηση του G
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
     % Οι μεταβλητές akra1, akra2 μετά το τέλος της διαδικασίας έχουν
     % κάποιες διαμορφωμένες τιμές. Θα κάνω τον μέσο όρο τους για το τελικό
     % γ που θα επιλέξω να επιστρέψω
     gamma = (akro2 + akro1) / 2;
end