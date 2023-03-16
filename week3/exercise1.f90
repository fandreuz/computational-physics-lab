program main
    implicit none
    integer, parameter :: n=10000000
    real, dimension(n) :: y

    call draw_exponential_rv(y)
    WRITE (unit=1, fmt=*) y
 
 contains
 
    subroutine draw_exponential_rv(x)
        real, dimension(:), intent(inout) :: x

        call random_number(x)
        x = -log(x)
    end subroutine
 
 end program main
 