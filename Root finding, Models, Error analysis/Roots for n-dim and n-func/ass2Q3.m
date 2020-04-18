% This is a root solver for two functions in two dimensions.
% So we are finding the x1,x2 points where both functions are at roots.
% Theoretically this can be abstracted to n-dimensions.
% The functions that were used are in example2.m file.
% func would be the example2.m file passed, x0 an initial guess, and tol
% a normwise tolerance level.

% It works by iterating through and solving the least squares problem
% for the derivative matrix J_xn and the new function matrix f_xn.
% It will stop when the tolerance is reached.

% Functions are provided in example2.m
function [roots, count, resids, history] = ass2Q3(func, x0, tol)

if (nargin < 3) 
    tol = 10^(-10)
end

count = 0;
xn = x0;
sn = zeros(2,1);
%history = zeros(1,1); history(1,1) = xn(1,1); history(2,1) = xn(2,1);

[f_xn, J_xn] = func(xn);
%resids = zeros(1,1); resids(1,1) = norm(f_xn, Inf);

while ((norm(f_xn, Inf) >= tol) && (count <= 50))
    count = count + 1;
    
    [f_xn, J_xn] = func(xn);
    resids(1,count) = norm(f_xn, Inf);
    history(1, count) = xn(1,1);
    history(2, count) = xn(2,1);
    
    sn = J_xn\f_xn;
    xn = xn - sn;
    [f_xn, J_xn] = func(xn);
end
roots = xn;
end