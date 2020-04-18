% This is a simulation of the classic buffons needle scenario.  If you 
% have a table with horizontal lines on it, a space d apart.  With a
% needle of length l.  Assume d >= l.  Once you take the integral (see
% scanned questions pdf for math working out) - we get the probability of 
% a crossover is (2*l/d*pi).  This works for any d and l, s.t. d >= l.

% We also calculate the standard error using the proportion method, and 
% calculate confidence intervals based on our estimate of p_hat.

% We can see that running the driver() function we get that for a 95% CI
% our [lower, upper] bounds contain the true value of (1/pi) approximately
% 95% of the time.  The random component is the fluctuating bounds, and
% we are testin that the true value (that we are trying to estimate) is 
% actually within those fluctuating random bounds around 95% of the time.

function [in_interval] = buffon()

d = 2; l = 1; crack_cross = 0; n = 100000;
p_hat = 0; p_true = (1/pi);
in_interval = 0;

Func = @(x) (l/2).*sin(x);
Area = integral(Func, 0, pi);
Prob = Area/((d*pi)/2);

for (i = 1:n)
    Y = rand(1)*(d/2);
    X = rand(1)*pi;
    
    if (Y < (l/2)*sin(X))
        crack_cross = crack_cross + 1;
    end
end

p_hat = crack_cross/n;
std_error = sqrt(((p_hat*(1-p_hat))/n));
lower = p_hat - (1.96*std_error);
upper = p_hat + (1.96*std_error);

if ((p_true >= lower) && (p_true <= upper))
    in_interval = 1;
end

% uncomment if you want to see p_hat %
%disp(p_hat);
end