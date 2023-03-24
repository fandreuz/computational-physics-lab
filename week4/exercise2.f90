program main
   implicit none
   integer, parameter :: l = 1, N = 100, runs = 10000
   real, parameter :: p_right = 0.5
   real, dimension(N) :: moves, l_vec
   real, dimension(N) :: x, avg_position, avg_sq_position
   integer :: i, run

   OPEN (unit=1, file="position.dat", status="replace", action="write")
   OPEN (unit=2, file="avg.dat", status="replace", action="write")
   OPEN (unit=3, file="info.dat", status="replace", action="write")

   WRITE (unit=3, fmt=*) p_right, 1 - p_right, l

   l_vec(:) = real(l)
   avg_position(:) = 0.
   avg_sq_position(:) = 0.

   do run = 1, runs
      call random_number(moves)
      x(:) = sign(l_vec, p_right - moves)
      do i = 2, n
         x(i) = x(i) + x(i - 1)
         avg_position(i) = avg_position(i) + x(i)
         avg_sq_position(i) = avg_sq_position(i) + x(i)*x(i)
      end do
      
      WRITE (unit=1, fmt=*) x
   end do

   WRITE (unit=2, fmt=*) avg_position / runs
   WRITE (unit=2, fmt=*) avg_sq_position / runs

contains

end program main
