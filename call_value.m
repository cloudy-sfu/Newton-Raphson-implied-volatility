% Black-Scholes Equations
% s: spot price
% k: strike price
% t: expiry time in years
% r: annualized risk-free interest rate
% sig: volatility
% c: call option price
function c = call_value(s, k, t, r, sigma)
d1 = (log(s./k) + (r+0.5*sigma.^2).*t) ./ ...
    (sigma.*sqrt(t));
d2 = d1 - sigma .* sqrt(t);
c = s .* normcdf(d1) - k .* exp(-r.*t) .* normcdf(d2);
end
