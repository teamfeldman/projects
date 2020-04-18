% Please see comments documentation for notes.

function [RFE_values, eta_values] = Q2(A, x)
RFE_values = zeros(1,3); eta_values = zeros(1,3);
b = A*x;
[Q, R] = qr(A);

x_hat1 = A\b; 
x_hat2 = inv(A)*b; 
x_hat3 = R\((Q.')*b);

RFE_values(1,1) = RFE(x_hat1, x);
RFE_values(1,2) = RFE(x_hat2, x);
RFE_values(1,3) = RFE(x_hat3, x);

eta_values(1,1) = eta(A, b, x_hat1);
eta_values(1,2) = eta(A, b, x_hat2);
eta_values(1,3) = eta(A, b, x_hat3);

end