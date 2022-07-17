clear all
clc
 
x10 = 11;        x1min = -20;        x1max = 10;
x20 = 3;        x2min = -12;        x2max = 15;
gamma = 0.01;
sk = 0.1;
maxKathodos(x10, x20, gamma, sk, x1min, x1max, x2min, x2max);
 
function maxKathodos(x10, x20, gamma, sk, x1min, x1max, x2min, x2max)
    
    % 1. Ορίζω το ε της συνθήκης τερματισμού ίσο με 0.01
    epsilon = 0.01;
    syms x1 x2
    f = (x1^2 + x2^2) / 2;
    F = matlabFunction(f);
    klisi = gradient(f, [x1,x2]);
    KLISI = matlabFunction(klisi);
    
    % 2. Ορίζω τις λίστες που θα τοποθετήσω τα x1i, x2i. Τις ονομάζω x1List,
    % x2List, θα βάζω επίσης και τις τιμές της f και του μέτρου της κλίσης
    % της σε άλλες 2 λίστες
    k = 1
    x1List = [];             x2List = [];
    x1List(1) = x10;          x2List(1) = x20;
    fList = [];             normKlisisList = [];
    fList(1) = subs(f, {x1,x2}, {x1List(length(x1List)), x2List(length(x2List))});
    normKlisisList(1) = norm(subs(klisi, {x1,x2}, {x1List(length(x1List)), x2List(length(x2List))}));
 
    
    while normKlisisList(length(normKlisisList)) > epsilon && k <= 2000
        k = k + 1
        % Ο τύπος είναι: xk+1 = xk + gamma * (xkBAR - xk), άρα πρέπει να βρω
        % το xkBAR. Όμως, για να υπολογίσω κάτι τέτοιο, θέλω να βρω την
        % προβολή του διανύσματος xk - sk * KLISI_f(xk) στον χώρο που μας
        % ενδιαφέρει και που ορίζεται στις παραμέτρους της function αυτής
        grad = KLISI(x1List(k-1), x2List(k-1))
        v1 = x1List(k-1) - sk * grad(1);
        v2 = x2List(k-1) - sk * grad(2);
        v = [v1;v2]
        xkBAR = provoli(v, x1min, x1max, x2min, x2max)      % Επιστρέφει 2x1 vector
        % xk+1 = xk + gamma * (xkBAR - xk)
        x1List(k) = x1List(k-1) + gamma * (xkBAR(1) - x1List(k-1));
        x2List(k) = x2List(k-1) + gamma * (xkBAR(2) - x2List(k-1));
        fList(k) = F(x1List(length(x1List)), x2List(length(x2List)));
        normKlisisList(k) = norm(subs(klisi, {x1,x2}, {x1List(length(x1List)), x2List(length(x2List))}));
    end
    
    
    x1List
    x2List
    fList
    normKlisisList
    k
    % Τα τελευταία xk, yk κάθε λίστας τα ονομάζω εν συντομία xx και yy
    display('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    display('~~~~~~~~ About the last found x1k (x1x1) and x2k (x2x2) ~~~~~~~~')
    display('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    x1x1 = x1List(length(x1List))
    x2x2 = x2List(length(x2List))
    F_xx_yy = fList(length(fList))
    NORM_KLISIS = normKlisisList(length(normKlisisList))
    % Plots
    figure(1);
    plot(fList, 'x');
    title("Values of f for every step k");
    xlabel('Step k');
    ylabel("f(x1k, x2k)");
    figure(2);
    plot(x1List, 'ro');
    title("Spots x1 (red), x2 (blue)");
    xlabel("Steps k");
    ylabel("x1(k), x2(k)");
    hold on
    plot(x2List, 'bo');
    title("Spots x1 (red), x2 (blue)");
    xlabel("Steps k");
    ylabel("x1(k), x2(k)");
    display('**********************************************************')
end



function xkBAR = provoli(v, x1min, x1max, x2min, x2max)
    % Η αρχικοποίηση των 2 παρακάτω συνιστωσών του xkBAR θα γίνει σαν να είναι οι συνιστώσες του
    % διανύσματος v εντός του εύρους τιμών [min, max]. Διαφορετικά,
    % ακολουθούν if-cases, που διορθώνουν αυτήν την τιμή
    synistwsa1 = v(1);
    synistwsa2 = v(2);
    if v(1) < x1min
        synistwsa1 = x1min;
    elseif v(1) > x1max
        synistwsa1 = x1max;
    end
    if v(2) < x2min
        synistwsa2 = x2min;
    elseif v(2) > x2max
        synistwsa2 = x2max;
    end
    xkBAR = [synistwsa1;synistwsa2];
end