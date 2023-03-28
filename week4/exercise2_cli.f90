program main
   implicit none
   integer, parameter :: l = 1
   real, parameter :: p_right = 0.5
   real :: xi2
   real, allocatable :: moves(:), l_vec(:), x(:), avg_position(:), avg_sq_position(:)
   integer :: i, run, runs, N
   character(len=32)           :: arg_runs, arg_N

   call get_command_argument(1, arg_runs)
   read (unit=arg_runs,fmt=*) runs

   call get_command_argument(2, arg_N)
   read (unit=arg_N,fmt=*) N

   allocate(moves(N))
   allocate(l_vec(N))
   allocate(x(N))
   allocate(avg_position(N))
   allocate(avg_sq_position(N))

   OPEN (unit=1, file="position.dat", status="replace", action="write")
   OPEN (unit=2, file="avg.dat", status="replace", action="write")
   OPEN (unit=3, file="info.dat", status="replace", action="write")
   OPEN (unit=3, file="P.dat", status="replace", action="write")

   WRITE (unit=3, fmt=*) p_right, 1 - p_right, l

   l_vec(:) = real(l)
   avg_position(:) = 0.
   avg_sq_position(:) = 0.

   do run = 1, runs
      call random_number(moves)
      x(:) = sign(l_vec, p_right - moves)
      do i = 2, n
         x(i) = x(i) + x(i - 1)
         xi2 = x(i)*x(i)

         ! sum across different particles to perform an ensemble average
         avg_position(i) = avg_position(i) + x(i)
         avg_sq_position(i) = avg_sq_position(i) + xi2
      end do

      WRITE (unit=1, fmt=*) x
   end do

   avg_position(:) = avg_position/runs
   avg_sq_position(:) = avg_sq_position/runs
   WRITE (unit=2, fmt=*) avg_position
   WRITE (unit=2, fmt=*) avg_sq_position
   WRITE (unit=2, fmt=*) avg_sq_position - avg_position**2

   deallocate(moves)
   deallocate(l_vec)
   deallocate(x)
   deallocate(avg_position)
   deallocate(avg_sq_position)

contains

end program main
