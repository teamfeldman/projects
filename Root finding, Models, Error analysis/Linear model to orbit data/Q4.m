% Decomposes a dataset of planet orbits into a singular matrix using 
% SVD() function.  We then solve the linear model using the \ operator one
% way, and then very slight random deviation into the dataset and solve 
% again using \.  Essentially what occurs is due the to the structure of 
% the A matrix - we have an ill conditioned matrix and a small 
% perturbation in the data causes wildly fluctuating estimates of the 
% linear parameters.  Please see comments doc for more information.

function [output] = Q4() %#ok<STOUT,INUSD>

x = [1.02; 0.95; 0.87; 0.77; 0.67; 0.56; 0.44; 0.30; 0.16; 0.01];
y = [0.39; 0.32; 0.27; 0.22; 0.18; 0.15; 0.13; 0.12; 0.13; 0.15];
x2 = x.^2;
A = [y.^2, x.*y, x, y, ones(10,1)];
[U,S,V] = svd(A);
K = S(1,1)/S(5,5);

para = A\x2;
disp(para);
[X1, Y1] = meshgrid(-1:0.01:1.5, -1:0.01:1.5);
Z = -1*(X1.^2) + para(2,1)*X1.*Y1 + para(1,1)*(Y1.^2) + para(3,1)*X1 + para(4,1)*Y1 + para(5,1);

contour(X1,Y1,Z,[0 0], 'blue')
hold on;
scatter(x,y);
hold on;
%%% part b

rx = -0.005 + (0.010).*rand(10,1);
ry = -0.005 + (0.010).*rand(10,1);

x_pert = x + rx;
y_pert = y + rx;

A2 = [y_pert.^2, x_pert.*y_pert, x_pert, y_pert, ones(10,1)];
x2_pert = x_pert.^2;

para2 = A2\x2_pert;
disp(para2);
Z2 = -1*(X1.^2) + para2(2,1)*X1.*Y1 + para2(1,1)*(Y1.^2) + para2(3,1)*X1 + para2(4,1)*Y1 + para2(5,1);
contour(X1,Y1,Z2,[0 0], 'red');
hold on;
%scatter(x_pert,y_pert);


end