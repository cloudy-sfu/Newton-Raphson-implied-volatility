module call_vega_mod
    implicit none
    
contains
    function call_vega(s, k, t, r, sigma) result(vega)
        use normcdf_mod
        real(8), intent(in) :: s(:), k(:), t(:), r, sigma(:)
        real(8) :: vega(size(s)), d1(size(s))
        d1 = (log(s / k) + (r + 0.5 * sigma ** 2) * t) / (sigma * sqrt(t))
        vega = exp(-r * t) * s * sqrt(t) * normcdf(d1)
    end function
end module call_vega_mod
