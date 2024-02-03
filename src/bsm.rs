use statrs::distribution::{Normal, ContinuousCDF};

fn norm_cdf(x: f64) -> f64 {
    let norm: Normal = Normal::new(0.0, 1.0).unwrap();
    norm.cdf(x)
}

pub fn call_value(s: f64, k:f64, t:f64, r:f64, sigma:f64) -> f64 {
    let d1 = ((s / k).ln() + (r + 0.5 * sigma.powf(2.0)) * t) / (sigma * t.sqrt());
    let d2 = d1 - sigma * t.sqrt();
    let c = s * norm_cdf(d1) - k * (- r * t).exp() * norm_cdf(d2);
    c
}

pub fn call_vega(s: f64, k:f64, t:f64, r:f64, sigma:f64) -> f64 {
    let d1 = ((s / k).ln() + (r + 0.5 * sigma.powf(2.0)) * t) / (sigma * t.sqrt());
    let vega = (- r * t).exp() * s * t.sqrt() * norm_cdf(d1);
    vega
}
