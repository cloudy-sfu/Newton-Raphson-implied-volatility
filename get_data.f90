module get_data
    implicit none
    integer :: f = 0
    
contains
    ! function doesn't support multiple returned values, so it must be subroutine
    subroutine from_bin(n, r, c, k, s, t)
        integer :: n, ierr
        real(8) :: r
        real(8), allocatable :: c(:), k(:), s(:), t(:)

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
        f = f + 1
    end subroutine

    subroutine to_csv_2d(mat, filepath)
        use, intrinsic :: iso_fortran_env, only: iostat_end
        real(8), intent(in) :: mat(:, :)
        integer :: n, m, i, j
        character(len=*) :: filepath
        open(unit=f, file=filepath, status='unknown')
        n = size(mat, 1)
        m = size(mat, 2)
        do i = 1, n
            do j = 1, m-1
                write(f, '(F12.5, ",")', advance='no') mat(i, j)
            end do
            write(f, '(F12.5)') mat(i, m)
        end do
        close(f)
        f = f + 1
    end subroutine

    subroutine to_csv_1d(mat, filepath)
        use, intrinsic :: iso_fortran_env, only: iostat_end
        real(8), intent(in) :: mat(:)
        integer :: n, i
        character(len=*) :: filepath
        open(unit=f, file=filepath, status='unknown')
        n = size(mat, 1)
        do i = 1, n
            write(f, '(F12.5)') mat(i)
        end do
        close(f)
        f = f + 1
    end subroutine

    subroutine to_bin_2d(mat, filepath)
        real(8), intent(in) :: mat(:, :)
        character(len=*) :: filepath
        open(unit=f, file=filepath, form="unformatted", access="stream")
        write(f) mat
        close(f)
        f = f + 1
    end subroutine

    subroutine to_bin_1d(mat, filepath)
        real(8), intent(in) :: mat(:)
        character(len=*) :: filepath
        open(unit=f, file=filepath, form="unformatted", access="stream")
        write(f) mat
        close(f)
        f = f + 1
    end subroutine
end module get_data
