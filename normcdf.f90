module normcdf_mod
    implicit none
    
contains
function normcdf(x) result(y)
    real(8), intent(in) :: x(:)
    real(8) :: y(size(x))
    real(8) :: t(size(x)), sign_x(size(x))
    real(8), parameter :: a1 = 0.254829592, a2 = -0.284496736
    real(8), parameter :: a3 = 1.421413741, a4 = -1.453152027
    real(8), parameter :: a5 = 1.061405429, p = 0.3275911

    sign_x = sign(real(1.0, 8), x)
    t = 1.0 / (1.0 + p * abs(x))
    y = 0.5 * (1.0 + sign_x * (1.0 - &
        (a1 * t + a2 * t**2 + a3 * t**3 + a4 * t**4 + a5 * t**5) * exp(-x**2 / 2.0)))
end function

end module normcdf_mod
