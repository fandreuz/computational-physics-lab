program main
   implicit none
   integer, parameter :: l = 1, l2 = l*l
   real, parameter :: p_right = 0.5, p_left = 1 - p_right, pi = 3.14159265359
   real :: xi2
   real, allocatable :: moves(:), l_vec(:), x(:), avg_position(:), avg_sq_position(:), msd(:), PN(:), x_slices(:), xp(:), xm(:)
   integer :: i, run, runs, N, n_slices, idx
   character(len=32) :: arg_runs, arg_N

   call get_command_argument(1, arg_runs)
   read (unit=arg_runs, fmt=*) runs

   call get_command_argument(2, arg_N)
   read (unit=arg_N, fmt=*) N

   n_slices = l*N*2 + 1

   allocate (moves(N))
   allocate (l_vec(N))
   allocate (x(N))
   allocate (avg_position(N))
   allocate (avg_sq_position(N))
   allocate (msd(N))

   allocate (PN(n_slices))
   allocate (x_slices(n_slices))
   allocate (xp(n_slices))
   allocate (xm(n_slices))

   OPEN (unit=1, file="position.dat", status="replace", action="write")
   OPEN (unit=2, file="avg.dat", status="replace", action="write")
   OPEN (unit=3, file="info.dat", status="replace", action="write")
   OPEN (unit=4, file="P.dat", status="replace", action="write")

   WRITE (unit=3, fmt=*) p_right, 1 - p_right, l

   l_vec(:) = real(l)
   avg_position(:) = 0.
   avg_sq_position(:) = 0.
   PN(:) = 0

   do run = 1, runs
      call random_number(moves)
      x(:) = sign(l_vec, p_right - moves)
      avg_position(1) = avg_position(1) + x(1)
      avg_sq_position(1) = avg_sq_position(1) + l2

      do i = 2, n
         x(i) = x(i) + x(i - 1)
         xi2 = x(i)*x(i)

         ! sum across different particles to perform an ensemble average
         avg_position(i) = avg_position(i) + x(i)
         avg_sq_position(i) = avg_sq_position(i) + xi2
      end do
      idx = nint(x(N) + N + 1)
      PN(idx) = PN(idx) + 1

      WRITE (unit=1, fmt=*) x
   end do

   avg_position(:) = avg_position/runs
   avg_sq_position(:) = avg_sq_position/runs
   msd(:) = avg_sq_position - avg_position**2

   WRITE (unit=2, fmt=*) avg_position
   WRITE (unit=2, fmt=*) avg_sq_position
   WRITE (unit=2, fmt=*) msd

   ! empirical distribution
   WRITE (unit=4, fmt=*) PN/runs

   ! compute theoretical distribution
   x_slices(1) = -l*N
   do i = 2, n_slices
      x_slices(i) = x_slices(i - 1) + l
   end do
   xm = (N - x_slices)/2.
   xp = (N + x_slices)/2.
   WRITE (unit=4, fmt=*) Gamma(real(N) + 1.)/(Gamma(xp + 1.)*Gamma(xm + 1.))*p_right**xp*p_left**xm

   ! compute theoretical limit distribution
   WRITE (unit=4, fmt=*) exp(-(x_slices(:) - avg_position(N))**2/(2*msd(N)))*sqrt(2/(pi*msd(N)))

   deallocate (moves)
   deallocate (l_vec)
   deallocate (x)
   deallocate (avg_position)
   deallocate (avg_sq_position)
   deallocate (msd)

   deallocate (xm)
   deallocate (xp)
   deallocate (x_slices)
   deallocate (PN)

contains

end program main
