% Driver function for Q3.  Just pass an x0 estimate (column format), and
% a tolerance.  Use tol = 10^(-10).
% An example would be "Driver([1.2;2.5], 10^(-10))"

function [roots, count, resids, history] = Driver(x0, tol)

[roots, count, resids, history] = ass2Q3(@example2, x0, tol);
sprintf("After %d iterations, the roots are [%f , %f]", count, roots(1), roots(2))

subplot(2,1,1); plot(1:count, resids); title('Convergence history')
ylabel('Residual norms');
xlabel('Iterations');

subplot(2,1,2); plot(history(1,1:length(history)), history(2,1:length(history)))
title('Solution trajectory');
ylabel('x2'); xlabel('x1');

end