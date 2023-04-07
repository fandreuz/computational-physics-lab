program main
   implicit none
   ! 0: mean sampling
   ! 1: importance sampling
   integer, parameter :: mode = 1
   integer :: N = 10000
   real, parameter :: lambda = 1., A = lambda/(1.-exp(-lambda)), truth = 0.74682
   real, dimension(:), allocatable :: x
   real :: f, f2
   character(len=32) :: arg_N

   call get_command_argument(1, arg_N)
   read (unit=arg_N, fmt=*) N

   allocate (x(N))

   call random_number(x)
   select case (mode)
   case (0)
      x = integrand(x)
   case (1)
      x = integrand_importance_sampling(x)
   end select

   f = sum(x)/N
   f2 = sum(x**2)/N

   open (2, file='error.txt', action='write', position='append')
   WRITE (unit=2, fmt=*) N, abs(truth - f), f2, f2 - f**2, (f2 - f**2)/sqrt(real(N))

contains

   function integrand(input) result(output)
      real, dimension(:) :: input
      real, dimension(size(input)) :: output

      output = exp(-(input**2))
   end function

   ! integrand divided by the chosen distribution for the importance sampling
   function integrand_importance_sampling(input) result(output)
      real, dimension(:) :: input
      real, dimension(size(input)) :: output, xi

      xi = generate_wrapped_exponential_distribution(input)
      WRITE (unit=1, fmt=*) xi
      output = integrand(xi)/(A*exp(-lambda*xi))
   end function

   function generate_wrapped_exponential_distribution(input) result(output)
      real, dimension(:) :: input
      real, dimension(size(input)) :: output

      output = inverse_exponential_cumulative(input)
   end function

   function inverse_exponential_cumulative(input) result(output)
      real, dimension(:) :: input
      real, dimension(size(input)) :: output

      output = -1./lambda*log(1.-input*lambda/A)
   end function

end program main
