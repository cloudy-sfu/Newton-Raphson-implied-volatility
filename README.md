# Newton Raphson Implied Volatility
 Computing implied volatility by Newton-Raphson method



The numerical approximation of implied volatility from Black-Scholes formula is to find the root of

$$g(\sigma) = s\Phi(d_1) - ke^{-rt}\Phi(d_2) - c = 0$$

where 

$$d_1 = \frac{\ln{\frac{s}{k}} + (r + \frac{1}{2}\sigma^2)t}{\sigma\sqrt{t}}$$

and $d_2 = d_1 - \sigma\sqrt{t}$.

$\sigma$ is the volatility, $s$ is the corresponding spot price, $k$ is the strike price, $r$ is the risk-free interest rate, $c$ is the price of the call option, $t$ is the time of maturity, and $\Phi(\cdot)$ is the cumulative distribution function of standard normal distribution up to $x$ i.e.

$$\Phi(x) = \frac{1}{\sqrt{2\pi}}\int_{-\infty}^{x}e^{-\frac{\tau^2}{2}}\mathrm{d}\tau$$

From $g(\sigma)$, there is

$$g'(\sigma) = s\sqrt{\frac{t}{2\pi}}e^{-\frac{d_1^2}{2}} > 0$$

$$g''(\sigma) = s\sqrt{\frac{t}{2\pi}}e^{-\frac{d_1^2}{2}}\frac{d_1 d_2}{\sigma}$$

Denote $\lambda = \sqrt{\frac{2}{t}\lvert{\ln\frac{s}{k}}+rt}\rvert$, $g''(\sigma) > 0$ in $[0, \lambda]$ and $g''(\sigma) < 0$ in $[\lambda, +\infty)$.

According to the Newton-Raphson method, a sequence $\sigma_0, \sigma_1, ...$ is defined as

$$\sigma_{i+1} = \sigma_i - \frac{g(\sigma_i)}{g'(\sigma_i)}$$

The beginning point is $\sigma_0 = \lambda$.
