"""
Newton-Raphson method:
x_(k+1) = x_k - f(x_k)/f'(x_k)
"""
import pickle
import numpy as np
from sklearn.metrics import mean_squared_error
from bsm import call_value, call_vega

max_iteration = 10

with open('data/call_options.pkl', 'rb') as f:
    s, k, t, r, c = pickle.load(f)

n = s.shape[0]
vega = np.zeros((n, max_iteration))
sigma = np.zeros((n, max_iteration + 1))
sigma[:, 0] = np.sqrt(2 / t * np.abs(np.log(s / k) + r * t))
for i in range(max_iteration):
    vega[:, i] = call_vega(s, k, t, r, sigma[:, i])
    sigma[:, i + 1] = sigma[:, i] - (call_value(s, k, t, r, sigma[:, i]) - c) / vega[:, i]
    c_hat = call_value(s, k, t, r, sigma[:, i])
    print('Iteration:', i + 1, 'MSE:', mean_squared_error(c, c_hat))

with open('results/volatility_newton.pkl', 'wb') as f:
    pickle.dump(sigma[:, max_iteration], f)
