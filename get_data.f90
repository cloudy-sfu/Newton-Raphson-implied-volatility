module get_data_mod
    implicit none
    
contains
    ! function doesn't support multiple returned values, so it must be subroutine
    subroutine get_data(n, r, c, k, s, t)
        integer :: n, ierr
        real(8) :: r
        real(8), allocatable :: c(:), k(:), s(:), t(:)
        integer :: f
    
        f = 0  ! Token of "data/call_options
        open(unit=f, file="data/call_options", form="unformatted", access="stream", &
             status="old", iostat=ierr)
        if (ierr /= 0) then
           print *, "Error opening file."
           stop
        end if
      
        read(f) n, r
        allocate(c(n), k(n), s(n), t(n))
        read(f) c, k, s, t
      
        close(f)
    end subroutine
end module get_data_mod
