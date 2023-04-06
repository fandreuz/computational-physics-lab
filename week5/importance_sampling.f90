program main
    implicit none
    integer, parameter :: N=1000, a=0, b=1
    real, dimension(N) :: x

    call random_number(x)
    x = integrand(x)
    WRITE (unit=*, fmt=*) (b - a) * sum(x) / N
 
 contains

 function integrand(input) result(output)
    real, dimension(:) :: input
    real, dimension(SIZE(x)) :: output

    output = exp(-(input ** 2))
 end function
 
 end program main
 