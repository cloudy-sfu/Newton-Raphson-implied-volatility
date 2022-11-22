load call_options.mat;
% Assumptions:
% *Observations that do not satisfy assumptions are picked out in pre-processing.*
% 1. All values (s, k, t, r, c) are positive.
% 2. There is a root, i.e. call_value(..., sigma=0) < 0

max_iteration = 10;
n = length(s);
vega = zeros(n, max_iteration);
sigma = zeros(n, max_iteration + 1);
c_hat = zeros(n, max_iteration + 1);
sigma(:, 1) = sqrt(2./t.*abs(log(s./k) + r.*t));
c_hat(:, 1) = call_value(s,k,t,r,sigma(:, 1));
for i=1:max_iteration
    vega(:,i) = call_vega(s,k,t,r,sigma(:, i));
    sigma(:, i+1) = sigma(:, i) - (c_hat(:, i) - c) ./ vega(:, i);
    c_hat(:, i+1) = call_value(s,k,t,r,sigma(:, i+1));
    mse = mean((c - c_hat(:, i+1)).^2);  % MSE of the call option value
    fprintf("Iteration: %d, MSE: %e\n", i, mse);
end
volatility = sigma(:,end);
save("volatility.mat", "volatility");