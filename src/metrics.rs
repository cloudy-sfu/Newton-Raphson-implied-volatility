pub fn mean_squared_error(actual: &[f64], predicted: &Vec<f64>) -> f64 {
    if actual.len() != predicted.len() {
        panic!("The lengths of actual and predicted values must be the same");
    }

    let sum_of_squared_diffs: f64 = actual.iter()
        .zip(predicted.iter())
        .map(|(&a, &p)| (a - p).powi(2))
        .sum();

    sum_of_squared_diffs / actual.len() as f64
}
