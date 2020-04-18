function [eta] = eta(A, b, x_hat)

num = norm(b-A*x_hat);
den = norm(A)*norm(x_hat);
eta = num/den;

end