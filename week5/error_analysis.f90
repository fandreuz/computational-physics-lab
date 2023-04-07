program main
   implicit none
   real, parameter :: pi = 3.1415926535
   integer, parameter :: n_runs = 10
   integer :: N, i
   real, dimension(:), allocatable :: x
   real :: f, f2, m_sum, m2_sum
   character(len=32) :: arg_N

   call get_command_argument(1, arg_N)
   read (unit=arg_N, fmt=*) N

   allocate (x(N))

   call random_number(x)
   x = integrand(x)
   f = sum(x)/N
   f2 = sum(x**2)/N

   open (2, file='error.txt', action='write', position='append')
   WRITE (unit=2, fmt=*) N, f, f2, abs(pi - f), f2 - f**2, (f2 - f**2)/sqrt(real(N))

   ! average of the averages
   m_sum = f
   m2_sum = f2
   do i = 2, n_runs
      call random_number(x)
      x = integrand(x)
      f = sum(x)/N
      f2 = sum(x**2)/N

      m_sum = m_sum + f
      m2_sum = m2_sum + f2
   end do
   m_sum = m_sum/n_runs
   m2_sum = m2_sum/n_runs

   open (3, file='error2.txt', action='write', position='append')
   WRITE (unit=3, fmt=*) N, m_sum, m2_sum, m2_sum - m_sum**2, sqrt(m2_sum - m_sum**2)/sqrt(real(N))

contains

   function integrand(input) result(output)
      real, dimension(:) :: input
      real, dimension(size(input)) :: output

      output = 4*sqrt(1 - input**2)
   end function

end program main
