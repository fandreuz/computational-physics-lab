program main
   implicit none
   real, parameter :: pi = 3.1415926535
   integer, parameter :: n_runs = 10
   integer :: N, i, subset_size
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
   WRITE (unit=2, fmt=*) N, f, f2, abs(pi - f), f2 - f**2, sqrt(f2 - f**2), sqrt((f2 - f**2)/real(N))

   ! average of the averages
   m_sum = f
   m2_sum = f**2
   do i = 2, n_runs
      call random_number(x)
      x = integrand(x)
      f = sum(x)/N

      m_sum = m_sum + f
      m2_sum = m2_sum + f**2
   end do
   m_sum = m_sum/n_runs
   m2_sum = m2_sum/n_runs

   open (3, file='error2.txt', action='write', position='append')
   WRITE (unit=3, fmt=*) N, m_sum, m2_sum, m2_sum - m_sum**2, sqrt(m2_sum - m_sum**2)

   ! block average
   m_sum = 0
   m2_sum = 0
   subset_size = N/n_runs
   do i = 1, n_runs
      f = sum(x((i - 1)*subset_size + 1:i*subset_size))/subset_size
      m_sum = m_sum + f
      m2_sum = m2_sum + f**2
   end do
   m_sum = m_sum/n_runs
   m2_sum = m2_sum/n_runs

   WRITE (unit=3, fmt=*) N, m_sum, m2_sum, m2_sum - m_sum**2, sqrt((m2_sum - m_sum**2)/real(n_runs))

contains

   function integrand(input) result(output)
      real, dimension(:) :: input
      real, dimension(size(input)) :: output

      output = 4*sqrt(1 - input**2)
   end function

end program main
