program main
   implicit none
   real, parameter :: pi = 3.1415926535, truth = 4*pi
   integer :: N
   real, dimension(:), allocatable :: x
   real :: f, f2
   character(len=32) :: arg_N

   call get_command_argument(1, arg_N)
   read (unit=arg_N, fmt=*) N

   allocate (x(N))

   call random_number(x)
   x = integrand(x)/N
   f = sum(x)/N
   f2 = sum(x**2)/N

   open (2, file='error.txt', action='write', position='append')
   WRITE (unit=2, fmt=*) N, abs(truth - f), f2, f2 - f**2, (f2 - f**2)/sqrt(real(N))

contains

   function integrand(input) result(output)
      real, dimension(:) :: input
      real, dimension(size(input)) :: output

      output = sqrt(1 - input**2)
   end function

end program main
