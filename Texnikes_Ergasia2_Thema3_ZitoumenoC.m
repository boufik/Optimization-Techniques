clear all
clc
 
elaxistoMeGammaMetavlhto(1, 1, 0.8, 0);
elaxistoMeGammaMetavlhto(1, 1, 1, 1);
 
 
function elaxistoMeGammaMetavlhto(x0, y0, s, flag)
    
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
    
    % Armijo Constants
    a = 1/1000;             b = 0.3;         
    gammaList(1) = s;
    
    while normKlisisList(length(normKlisisList)) > epsilon
        k = k + 1;
        % dk = -subs(klisi, {x,y}, {xList(length(xList)), yList(length(yList))});     % η κλίση πριν
        % Το dk είναι 2*1 διάνυσμα, το 1ο στοιχείο του αφορά τον υπολογισμό
        % του x και το 2ο τον υπολογισμό του y
        % Πρέπει το γ που θα επιλέξω να κάνει minimize την f(xk + γkdk)
        xPrin = xList(k-1);
        yPrin = yList(k-1);
        dkVector = DK(xList(k-1), yList(k-1));      % A 2x1 vector
        
        % ********************************************************************************************
        % ******************************* Κανόνας Armijo *********************************************
        % ********************************************************************************************
        % Δοκιμάζω τιμές ακέραιες 0,1,2,... στο mk και φτιάχνω το βήμα γk
        % και κατ' επέκταση και το xk+1
        for mk = 0:10
            k
            mk
            gk = s * b^mk;
            xNew = xPrin + gk * dkVector(1);
            yNew = yPrin + gk * dkVector(2);
            F = matlabFunction(f);
            DF = matlabFunction(klisi);
            % Ήρθε η ώρα να τσεκάρουμε την ανίσωση
            aristeroMelos = F(xPrin, yPrin) - F(xNew, yNew);
            grad = DF(xPrin, yPrin);
            dexioMelos = a * b^mk * s * grad' * grad;
            if aristeroMelos > dexioMelos
                gammaList(k) = gk;
                xList(k) = xNew;
                yList(k) = yNew;
                fList(k) = F(xNew, yNew);
                normKlisisList(k) = norm(subs(klisi, {x,y}, {xList(length(xList)), yList(length(yList))}));
                display('Success for this step k with mk in value of:')
                mk
                break;
            end
        end
            
            
    end
    
    xList
    yList
    fList
    normKlisisList
    k
    gammaList
    % Τα τελευταία xk, yk κάθε λίστας τα ονομάζω εν συντομία xx και yy
    display('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    display('~~~~~~~~ About the last found xk (xx) and yk (yy) ~~~~~~~~')
    display('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    xx = xList(length(xList))
    yy = yList(length(yList))
    F_xx_yy = fList(length(fList))
    NORM_KLISIS = normKlisisList(length(normKlisisList))
    if flag == 0
        plot(fList, 'ro');
        title('Red for s = 0.8, blue for s = 1');
        xlabel('Steps k');
        ylabel('Values of f');
        hold on
    else
        plot(fList, 'bx');
        title('Red for s = 0.8, blue for s = 1');
        xlabel('Steps k');
        ylabel('Values of f');
        hold on
    end
    display('**********************************************************')
end