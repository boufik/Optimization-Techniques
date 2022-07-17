syms x y
f = x^3 * exp(-x^2-y^4);
fsurf(f, 'red');
xlabel('x');
ylabel('y');
zlabel('f(x,y)');
title('Plot of function: f = x^3 * exp(-x^2-y^4)');