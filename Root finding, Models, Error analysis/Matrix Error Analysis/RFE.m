function [RFE] = RFE(x_hat, x)
    diff = norm(x_hat-x);
    RFE = diff/(norm(x));
end