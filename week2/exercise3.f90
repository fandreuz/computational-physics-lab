program main
   implicit none
   integer, parameter :: K = 10, N = 10000, dn = 10
   real, dimension(dn) :: rnd
   real, dimension(N, K) :: moments
   real, dimension(N) :: expected_diff
   real, dimension(K) :: sm = 0.
   integer :: i, j

   do i = 1, N
      expected_diff(i) = 1./SQRT(REAL(i*dn))
   end do

   do i = 1, N
      call random_number(rnd)
      do j = 1, K
         sm(j) = sm(j) + SUM(rnd**j)
         moments(i, j) = sm(j)/REAL(i*dn)
      end do
   end do

   OPEN (unit=1, file="moments.dat", status="replace", action="write")
   do j = 1, K
      WRITE (unit=1, fmt=*) abs(moments(:, j) - compute_expected_moment(j))
      WRITE (unit=1, fmt=*) expected_diff
   end do

contains

   function compute_expected_moment(k) result(moment)
      integer, intent(in) :: k
      real :: moment

      moment = 1./(k + 1)
   end function

end program main
