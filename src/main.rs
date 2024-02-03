use crate::io::{read_binary, write_binary};
use crate::bsm::{call_value, call_vega};
use crate::metrics::mean_squared_error;
mod io;
mod bsm;
mod metrics;

fn main() {
    // Constants.
    let max_iteration = 10;

    // Initialization.
    let mut s = Vec::new();
    let mut k = Vec::new();
    let mut t = Vec::new();
    let mut r = 0.0;
    let mut c = Vec::new();

    // Load data.
    match read_binary("data/call_options") {
        Ok((_s, _k, _t, _r, _c)) => {s = _s; k = _k; t = _t; r = _r; c = _c;},
        Err(e) => { eprintln!("Failed to read binary file: {}", e); },
    }

    let n = s.len();
    assert_eq!(n, k.len());
    assert_eq!(n, t.len());
    assert_eq!(n, c.len());

    let mut vega = vec![vec![0.0; n]; max_iteration];
    let mut sigma = vec![vec![0.0; n]; max_iteration + 1];
    let mut c_hat = vec![vec![0.0; n]; max_iteration + 1];
    for j in 0..n {
        sigma[0][j] = (((s[j] / k[j]).ln() + r * t[j]).abs() * 2.0 / t[j]).sqrt();
        c_hat[0][j] = call_value(s[j], k[j], t[j], r, sigma[0][j]);
    }

    for i in 0..max_iteration {
        for j in 0..n {
            vega[i][j] = call_vega(s[j], k[j], t[j], r, sigma[i][j]);
            sigma[i+1][j] = sigma[i][j] - (c_hat[i][j] - c[j]) / vega[i][j];
            c_hat[i+1][j] = call_value(s[j], k[j], t[j], r, sigma[i+1][j]);
        }
        let mse = mean_squared_error(&c, &c_hat[i]);
        let i_1 = i + 1;
        println!("Iteration: {i_1}, MSE: {mse}.");
    }

    let _ = write_binary(&sigma[max_iteration], "results/volatility");
}
