clear all
clc

xArxiko = -1;       yArxiko = -1;
elaxistoMeGammaMetavlhto(xArxiko, yArxiko, 0.1, 0.3, 0);
elaxistoMeGammaMetavlhto(xArxiko, yArxiko, 0.3, 0.5, 1);
 
 
function elaxistoMeGammaMetavlhto(x0, y0, akro1, akro2, flag)
    
    % 1. Ορίζω το ε της συνθήκης τερματισμού ίσο με 2/1000
    epsilon = 0.002;
    syms x y
    f = x^3 * exp(-x^2-y^4);
    klisi = gradient(f, [x,y]);
    KLISI = matlabFunction(klisi);
    essianos = jacobian(klisi)
    ESSIANOS = matlabFunction(essianos);        % Δίνει έναν 2x2 πίνακα
    
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
        % *********************************************************************************
        % ************************ Levenberg - Marquardt **********************************
        % *********************************************************************************
        % Πρέπει να βρω αν ο εσσιανός στο xk είναι θετικά ορισμένος, θα
        % γίνει μέσω ιδιοτιμών
        ESS = ESSIANOS(xList(k-1), yList(k-1))
        EIG = eig(ESS);
        MIN = min(EIG);
        dk = [0;0];                 % A 2x1 vector
        
        if MIN > 0
            % Τότε, η ελάχιστη ιδιοτιμή του εσσιανού στο σημείο xk είναι
            % θετική και άρα ο εσσιανός είναι θετικά ορισμένος
            disp('Thetika orismenos');
            inv_essianos = inv(ESS)
            dk = - inv_essianos * KLISI(xList(k-1), yList(k-1));        % A 2x1 vector
        else
            % Αν η ελάχιστη ιδιοτιμή του είναι -4 π.χ. πρέπει να προσθε΄σω
            % 4 + (κάτι) και όλο αυτό επί τον μοναδιαίο, π.χ. 4,4Ι
            disp('Oxi thetika orismenos');
            mk = - MIN * 1.1
            A = ESS + mk * eye(2);
            inv_A = inv(A)
            % Τώρα, ο Α είναι σίγουρα θετικά ορισμένος και αντιστρέφεται
            dk = - inv_A * KLISI(xList(k-1), yList(k-1));
        end
        
        % ********************************************************************************************
        % ************************** Εσωτερική Βελτιστοποίηση ****************************************
        % ********************************************************************************************
        gamma = internalOptimization(f, xList(k-1), yList(k-1), dk, akro1, akro2);
        
       
        xList(k) = xList(k-1) + gamma * dk(1);
        yList(k) = yList(k-1) + gamma * dk(2);
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
        title('Red for 0.1 <= gamma <= 0.3, blue for 0.3 <= gamma <= 0.5');
        xlabel('Steps k');
        ylabel('Values of f');
        hold on
    else
        plot(fList, 'bx');
        title('Red for 0.1 <= gamma <= 0.3, blue for 0.3 <= gamma <= 0.5');
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