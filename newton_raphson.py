"""
Newton-Raphson method:
x_(k+1) = x_k - f(x_k)/f'(x_k)
"""
import pickle
import numpy as np
from sklearn.metrics import mean_squared_error
from bsm import call_value, call_vega

max_iteration = 10

with open('call_options.pkl', 'rb') as f:
    s, k, t, r, c = pickle.load(f)
# Assumptions:
# *Observations that do not satisfy assumptions are picked out in pre-processing.*
# 1. All values (s, k, t, r, c) are positive.
# 2. There is a root, i.e. call_value(..., sigma=0) < 0

n = s.shape[0]
vega = np.zeros((n, max_iteration))
sigma = np.zeros((n, max_iteration + 1))
c_hat = np.zeros((n, max_iteration + 1))
sigma[:, 0] = np.sqrt(2 / t * np.abs(np.log(s / k) + r * t))
c_hat[:, 0] = call_value(s, k, t, r, sigma[:, 0])
for i in range(max_iteration):
    vega[:, i] = call_vega(s, k, t, r, sigma[:, i])
    sigma[:, i + 1] = sigma[:, i] - (c_hat[:, i] - c) / vega[:, i]
    c_hat[:, i + 1] = call_value(s, k, t, r, sigma[:, i + 1])
    print('Iteration:', i + 1, 'MSE:', mean_squared_error(c, c_hat[:, i + 1]))  # MSE of the call option value

with open('volatility.pkl', 'wb') as f:
    pickle.dump(sigma[:, max_iteration], f)
