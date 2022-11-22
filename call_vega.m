function vega = call_vega(s, k, t, r, sigma)
d1 = (log(s./k) + (r+0.5*sigma.^2).*t) ./ ...
    (sigma.*sqrt(t));
vega = exp(-r.*t) .* s .* sqrt(t) .* normpdf(d1);
end