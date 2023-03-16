program main
    implicit none
    integer, parameter :: n=10000000
    real, parameter :: pi=3.14159265359
    real, dimension(n) :: y1, y2

    call draw_method_1(y1)
    WRITE (unit=1, fmt=*) y1
    call draw_method_2(y2)
    WRITE (unit=2, fmt=*) y2
 
 contains
 
    subroutine draw_method_1(x)
        real, dimension(:), intent(inout) :: x

        call random_number(x)
        x = cos(pi * x)
    end subroutine

    subroutine draw_method_2(u)
        real, dimension(:), intent(inout) :: u
        real, dimension(size(u)) :: v, u2, v2
        integer :: i

        call random_number(u)
        call random_number(v)
        u2 = u*u
        v2 = v*v

        do i=1,n
            do while (u2(i)+v2(i) > 1)
                call random_number(u(i))
                call random_number(v(i))
                u2(i) = u(i)*u(i)
                v2(i) = v(i)*v(i)
            enddo
        end do

        u = (u2 - v2) / (u2 + v2)
    end subroutine
 
 end program main
 