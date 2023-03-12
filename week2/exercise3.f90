program main
   implicit none
   ! perform correlation or uniformity quantitative check
   logical, parameter :: correlation = .TRUE.
   integer, parameter :: K = 10, N = 10000, dn = 10
   real, allocatable, dimension(:) :: rnd
   real, dimension(N, K) :: computed
   real, dimension(N) :: expected_diff
   real, dimension(K) :: sm = 0.
   integer :: i, j

   do i = 1, N
      expected_diff(i) = 1./SQRT(REAL(i*dn))
   end do

   OPEN (unit=1, file="moments.dat", status="replace", action="write")

   if (correlation) then
      do i = 1, N
         allocate (rnd(dn*i))
         call random_number(rnd)
         do j = 1, K
            computed(i, j) = SUM(rnd(1:dn*i - j)*rnd(j:))/REAL(i*dn)
         end do
         deallocate(rnd)
      end do
   else
      allocate (rnd(dn))
      do i = 1, N
         call random_number(rnd)
         do j = 1, K
            sm(j) = sm(j) + SUM(rnd**j)
            computed(i, j) = sm(j)/REAL(i*dn)
         end do
      end do
      deallocate(rnd)
   end if

   do j = 1, K
      WRITE (unit=1, fmt=*) abs(computed(:, j) - compute_expected(j))
      WRITE (unit=1, fmt=*) expected_diff
   end do

contains

   function compute_expected(k) result(expected)
      integer, intent(in) :: k
      real :: expected

      if (correlation) then
         expected = 0.25
      else
         expected = 1./(k + 1)
      end if
   end function

end program main
