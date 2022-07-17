clear all
clc

syms x y
f = x^3 * exp(-x^2-y^4);
klisi = gradient(f, [x,y]);
KLISI = matlabFunction(klisi);
a = 1/1000;
b = 0.3;
s = 1;              % Initial Step


xList = [-1.0000   -1.1351   -1.2619   -1.2053   -1.2372   -1.2170 -1.2297   -1.2216   -1.2267   -1.2235   -1.2255   -1.2242 -1.2251   -1.2245   -1.2249   -1.2247   -1.2248   -1.2247 -1.2248   -1.2247   -1.2248   -1.2247   -1.2247  -1.2247 -1.2247   -1.2247];
     
yList = [-1.0000   -0.4596   -0.3275   -0.2732   -0.2400   -0.2175 -0.2007   -0.1875   -0.1767   -0.1677   -0.1600   -0.1533 -0.1474   -0.1421   -0.1374   -0.1332   -0.1293   -0.1258 -0.1225   -0.1195   -0.1167   -0.1141   -0.1117  -0.1094 -0.1073   -0.1053];
 
fList = [-0.1353   -0.3856   -0.4041   -0.4073   -0.4084   -0.409 -0.4092   -0.4094   -0.4095   -0.4096   -0.4096   -0.4097 -0.4097   -0.4097   -0.4098   -0.4098   -0.4098   -0.4098 -0.4098   -0.4098   -0.4098   -0.4098   -0.4099   -0.4099 -0.4099   -0.4099];

klasmaList = [];        oria = [];

% Υπάρχει η ανίσωση εύρεσης του mk:
% f(xk) - f(xk+1) >= a * b^mk * s * (gradf(xk)) ' * gradf(xk)

for k = 1:25
    N = subs(f, {x,y}, {xList(k), yList(k)}) - subs(f, {x,y}, {xList(k+1), yList(k+1)});
    grad = KLISI(xList(k), yList(k));
    D = a * s * grad' * grad;
    klasma = N / D;
    klasmaList(k) = klasma;
end

for i = 1:length(klasmaList)
    orio = log(klasmaList(i)) / log(b);
    oria(i) = orio;
end

oria

MK = 0;
for mk = 0:10
    % For a given value of mk
    hits = 0;
    for k = 1:25
        aristero = subs(f, {x,y}, {xList(k), yList(k)}) - subs(f, {x,y}, {xList(k+1), yList(k+1)});
        grad = KLISI(xList(k), yList(k));
        dexio = - a * b^mk * s * grad' * grad;
        if aristero > dexio
            hits = hits + 1;
        end
    end
    if hits == 25
        MK = mk;
        break
    end
    mk
    k
    hits
end
MK

