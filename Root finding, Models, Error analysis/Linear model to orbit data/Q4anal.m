x = [1.2, -2, -1.2, 2];
y = [2.5, 2.5, -2.5, -2.5];

xlim([-3,3]);
ylim([-3,3]);
scatter(x,y, 'blue');
hold on;

rootx = [1.336355, -0.901266, -3.001625];
rooty = [1.754235, -2.086588, 0.148108];

scatter(rootx, rooty, 'red');