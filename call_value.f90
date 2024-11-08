module call_value_mod
    implicit none
    
contains
    function call_value(s, k, t, r, sigma) result(c)
        use normcdf_mod
        implicit none
        real(8), intent(in) :: s(:), k(:), t(:), r, sigma(:)
        real(8) :: c(size(s)), d1(size(s)), d2(size(s))
        d1 = (log(s / k) + (r + 0.5 * sigma ** 2) * t) / (sigma * sqrt(t))
        d2 = d1 - sigma * sqrt(t)
        c = s * normcdf(d1) - k * exp(-r * t) * normcdf(d2)
    end function

end module call_value_mod
