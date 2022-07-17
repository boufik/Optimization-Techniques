clc
clear all
syms x y

f = x^2 + y^2 - 4*x - 4*y;
g1 = x^2 - y;
g2 = x + y - 2;

figure
fsurf(f,[-5 5 -5 5], 'green');
zlim([-8 5]);
title('f = x^2 + y^2 - 4*x - 4*y, g1 = x^2 - y, g2 = x + y -2')
hold on

fsurf(g1, [-5 5 -5 5], 'red');
zlim([-8 0 ]);
hold on

fsurf(g2, [-5 5 -5 5], 'blue');
zlim([-8 0]);
