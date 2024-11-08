program main
    ! Assumptions:
    ! 1. All values (s, k, t, r, c) are positive.
    ! 2. There is a root, i.e. call_value(..., sigma=0) < 0
    ! Observations that do not satisfy assumptions are picked out in pre-processing.
    use get_data_mod
    use call_value_mod
    use call_vega_mod
    use, intrinsic :: ieee_arithmetic
    use nanmse_mod

    ! define constants
    implicit none
    integer, parameter :: max_iteration = 10

    ! define variables (must come before other statements)
    integer :: n
    real(8) :: r  ! "8" means 64-bit
    real(8), allocatable :: c(:), k(:), s(:), t(:)
    real(8), allocatable :: vega(:, :), sigma(:, :), c_hat(:, :)
    integer :: i
    real(8) :: mse_val

    ! get data (modify on input variables)
    ! file token 0 is used.
    call get_data(n, r, c, k, s, t)
    allocate(vega(n, max_iteration), sigma(n, max_iteration + 1), &
      c_hat(n, max_iteration + 1))

    sigma(:, 1) = sqrt(2.0 / t * abs(log(s / k) + r * t))
    c_hat(:, 1) = call_value(s, k, t, r, sigma(:, 1))
    do i = 1, max_iteration
        vega(:, i) = call_vega(s, k, t, r, sigma(:, i))
        sigma(:, i+1) = sigma(:, i) - (c_hat(:, i) - c) / vega(:, i)
        c_hat(:, i+1) = call_value(s, k, t, r, sigma(:, i+1))
        mse_val = nanmse(c, c_hat(:, i+1))
        write(*, "(A, I0, A, F12.5, A, F12.5, F6.5)") "Iteration: ", i, ", MSE: ", mse_val, &
        ", Finite ratio: ", convergent_ratio(c_hat(:, i+1))
    end do

    call to_bin_1d(sigma(:, max_iteration+1), "volatility")
end program main
