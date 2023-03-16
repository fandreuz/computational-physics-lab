program main
   implicit none
   integer, parameter :: n = 1000000, n_bins = 20
   real, dimension(n) :: x
   real :: mn, mx, db
   integer, dimension(n_bins) :: b1, b2
   character(len=20), dimension(n_bins) :: ls

   call clt(x)
   mn = minval(x)
   mx = maxval(x)
   db = (mx - mn)/real(n_bins)
   ls = generate_labels(mn, db, n_bins)

   !WRITE (unit=*, fmt=*) "FLOOR -----"

   !b1 = histogram(x, 0, n_bins)
   !WRITE (unit=*, fmt=*) b1
   !call make_histogram(b1, ls)

   !WRITE (unit=*, fmt=*) "NINT -----"
!
   !b2 = histogram(x, 1, n_bins)
   !call make_histogram(b2, ls)

   WRITE (unit=*, fmt=*) "mu: ", compute_mu(x), "sigma2: ", compute_sigma2(x)

contains

   subroutine clt(x)
      real, dimension(:), intent(inout) :: x
      integer, parameter :: n = 10000
      real, dimension(n) :: temp
      integer :: i

      do i = 1, size(x)
         call random_number(temp)
         temp = (temp - 0.5)*2
         x(i) = sum(temp)/n
      end do
   end subroutine

   function histogram(x, mode, n_bins) result(bins)
      real, dimension(:) :: x
      integer :: mode, n_bins, i, idx
      integer, dimension(size(x)) :: idxes
      real :: mn, mx, db
      integer, dimension(n_bins) :: bins

      mn = minval(x)
      mx = maxval(x)
      db = (mx - mn)/real(n_bins)

      select case (mode)
      case (0)
         idxes = floor((x - mn)/db)
      case (1)
         idxes = nint((x - mn)/db)
      end select
      idxes = idxes + 1

      bins = 0
      do i = 1, n
         idx = min(n_bins, idxes(i))
         bins(idx) = bins(idx) + 1
      end do
   end function

   function generate_labels(mn, db, n) result(ls)
      real :: mn, db
      integer :: n, i
      character(len=20), dimension(n) :: ls

      do i = 1, n
         write (ls(i), "(f10.3)") mn + db*(i - 1)
      end do
   end function

   subroutine make_histogram(bins, labels)
      integer, dimension(:), intent(in) :: bins
      character(len=20), dimension(size(bins)), intent(in) :: labels
      integer :: i
      character, allocatable, dimension(:) :: histogram_line

      do i = 1, size(bins)
         allocate (histogram_line(bins(i)))
         histogram_line = '*'
         print *, labels(i), histogram_line
         deallocate (histogram_line)
      end do
   end subroutine

   function compute_mu(x) result(mu)
      real, dimension(:) :: x
      real :: mu

      mu = sum(x)/real(size(x))
   end function

   function compute_sigma2(x) result(sigma2)
      real, dimension(:) :: x
      real :: sigma2, mu

      mu = compute_mu(x)
      sigma2 = sum((mu - x)**2)/real(size(x))
   end function

end program main
