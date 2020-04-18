% Using different root finding methods we find the roots of the following
% functions.  See comments doc for more details.

F = @(x) sin(x)-cos(2*(x^2))
G = @(x) (1/(x-pi))
H = @(x) 1 - ((1 + 3*x)*exp(-3*x))

%%% find 1st positive root for F = 0.6708
[f1, f2] = fzerotx(F, [-0.5,2])
%fplot(F, [-1,2])
%%% find 2nd positive root for F = 1.7474 
[f3, f4] = fzerotx(F, [1.5,1.75])


%fplot(G, [0,5])
%%% trying G(x) on interval [0,5]
[g1, g2] = fzerotx(G, [0,5])

fplot(H, [-1,1])
%%% trying H(x) on interval [-1,1]
%[h1, h2] = fzerotx(H, [-1,1])