module nanmse_mod
    implicit none
    
contains
function nanmse(y_true, y_pred) result(mse_val)
    use, intrinsic :: ieee_arithmetic
    real(8), intent(in) :: y_true(:), y_pred(:)
    logical(4) :: is_valid(size(y_true))
    real(8), allocatable :: y_pred_valid(:), y_true_valid(:)
    real(8) :: mse_val
    integer :: n_valid

    is_valid = .not. ieee_is_nan(y_pred)
    n_valid = count(is_valid)
    allocate(y_pred_valid(n_valid), y_true_valid(n_valid))
    y_true_valid = pack(y_true, is_valid)
    y_pred_valid = pack(y_pred, is_valid)
    mse_val = sum((y_true_valid - y_pred_valid) ** 2) / n_valid
end function

function convergent_ratio(x) result(y)
    use, intrinsic :: ieee_arithmetic
    real(8), intent(in) :: x(:)
    real(8) :: y
    y = real(count(.not. ieee_is_nan(x)), 8) / size(x)
end function
end module nanmse_mod
