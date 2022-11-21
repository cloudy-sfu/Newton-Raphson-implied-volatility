"""
Black-Scholes Equations
s: spot price
k: strike price
t: expiry time in years
r: annualized risk-free interest rate
sig: volatility
c: call option price
"""
import numpy as np
from scipy.stats import norm


def call_value(s, k, t, r, sigma):
    d1 = (np.log(s / k) + (r + .5 * sigma ** 2) * t) / (sigma * t ** .5)
    d2 = d1 - sigma * t ** .5
    c = s * norm.cdf(d1) - k * np.exp(-r * t) * norm.cdf(d2)
    return c


def call_vega(s, k, t, r, sigma):
    d1 = (np.log(s / k) + (r + .5 * sigma ** 2) * t) / (sigma * t ** .5)
    vega = np.exp(-r*t) * s * t ** .5 * norm.pdf(d1)
    return vega
