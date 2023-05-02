!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!c ising.f90
!c
!c Metropolis algorithm to calculate <E>, <M>, in the canonical ensemble
!c (fix T,N,V) with a 2D Ising model
!c
!c Here: K_B = 1
!c       J   = 1
!c
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
module common

   implicit none
   public :: initial, metropolis, DeltaE
   public :: data, output
   integer, public, parameter :: double = selected_real_kind(13)
   real(kind=double), public :: T, E, M
   integer, public, dimension(:, :), allocatable :: spin
   real(kind=double), public, dimension(-8:8) :: w
   integer, public, dimension(8) :: seed
   integer, public :: N, L, nmcs, nequil
   integer, public :: accept
   logical :: pbc
contains

   subroutine initial(cum)
      real(kind=double), dimension(5), intent(out) :: cum
      integer :: x, y, up, right, sums, i, dE
      real :: rnd
      print *, "linear dimension of lattice L ="
      read *, L
      allocate (spin(0:L + 1, 0:L + 1))
      print *, "reduced temperature T ="
      read *, T
      N = L*L
      print *, "# MC steps per spin for equilibrium ="
      read *, nequil
      print *, "# MC steps per spin for averages ="
      read *, nmcs
      !print *, "seed (1:8) ="
      !read *, seed
      !call random_seed(put=seed)
      print *, "# Use PBC ="
      read *, pbc
      M = 0.0_double
      !  random initial configuration
      !  compute initial magnetization
      do y = 1, L
         do x = 1, L
            call random_number(rnd)
            if (rnd < 0.5) then
               spin(x, y) = 1
            else
               spin(x, y) = -1
            end if
            M = M + spin(x, y)
         end do
      end do

      do i = 1, L
         if (pbc) then
            spin(0, i) = spin(L, i)
            spin(L + 1, i) = spin(1, i)

            spin(i, 0) = spin(i, L)
            spin(i, L + 1) = spin(i, 1)
         else
            spin(0, i) = 0
            spin(L + 1, i) = 0

            spin(i, 0) = 0
            spin(i, L + 1) = 0
         end if
      end do

      !  compute initial energy
      E = 0.0_double
      do y = 1, L
         up = y + 1
         do x = 1, L
            right = x + 1
            sums = spin(x, up) + spin(right, y)
! calculate the initial energy summing all over pairs
! (gor a given spin, consider only the up NN and the right NN
! - NOT the down and the left NN - : each interaction is counted once
            E = E - spin(x, y)*sums
         end do
      end do
!
! calculate the transition probability according
! to the Boltzmann distribution (exp(-deltaE/KT).
! Choosing the interaction parameter  J=1, ***IN CASE OF P.B.C.***
! possible energy variations per spin flip are -8,-4,0,+4,+8:
      do dE = -8, 8, 4
         w(dE) = exp(-dE/T)
      end do
      accept = 0
      cum = 0.0_double
   end subroutine initial

   subroutine metropolis()
      !  one Monte Carlo step per spin
      integer :: ispin, x, y, dE
      real :: rnd
      do ispin = 1, N
         !     random x and y coordinates for trial spin
         call random_number(rnd)
         x = int(L*rnd) + 1
         call random_number(rnd)
         y = int(L*rnd) + 1
         dE = DeltaE(x, y)
         call random_number(rnd)
         if (rnd <= w(dE)) then
            spin(x, y) = -spin(x, y)
            accept = accept + 1
            M = M + 2*spin(x, y)  ! factor 2 is to account for the variation:
            E = E + dE           ! (-(-)+(+))

            if (pbc) then
               if (x == 1) spin(L + 1, y) = spin(x, y)
               if (x == L) spin(0, y) = spin(x, y)

               if (y == 1) spin(x, L + 1) = spin(x, y)
               if (y == L) spin(x, 0) = spin(x, y)
            end if
         end if
      end do
   end subroutine metropolis

   function DeltaE(x, y) result(DeltaE_result)
      !  periodic boundary conditions
      integer, intent(in) :: x, y
      integer :: DeltaE_result
      integer :: left
      integer :: right
      integer :: up
      integer :: down
      left = spin(x - 1, y)
      right = spin(x + 1, y)
      up = spin(x, y + 1)
      down = spin(x, y - 1)
      DeltaE_result = 2*spin(x, y)*(left + right + up + down)
! also here the factor 2 is to account for the variation
   end function DeltaE

   subroutine data(cum)
      !  accumulate data after every Monte Carlo step per spin
      real(kind=double), dimension(5), intent(inout) :: cum
      cum(1) = cum(1) + E
      cum(2) = cum(2) + E*E
      cum(3) = cum(3) + M
      cum(4) = cum(4) + M*M
      cum(5) = cum(5) + abs(M)
   end subroutine data

   subroutine output(cum)
      real(kind=double), dimension(5), intent(inout) :: cum
      real(kind=double) :: eave, e2ave, mave, m2ave, abs_mave, c, xi
      real :: acceptance_prob
      acceptance_prob = real(accept)/real(N)/real(nmcs + nequil)
      eave = cum(1)/real(N)/real(nmcs)    ! to avoid interger overflow
      e2ave = cum(2)/real(N*N)/real(nmcs)
      mave = cum(3)/real(N)/real(nmcs)
      m2ave = cum(4)/real(N*N)/real(nmcs)
      abs_mave = cum(5)/real(N)/real(nmcs)
      print *, "temperature                =", T
      print *, "acceptance probability     =", acceptance_prob
      print *, "mean energy per spin                =", eave
      print *, "mean squared energy per spin        =", e2ave
      print *, "mean magnetization  per spin        =", mave
      print *, "mean squared magnetization per spin =", m2ave
      print *, "mean |magnetization| per spin       =", abs_mave

      c = (cum(2)/real(nmcs) - (cum(1)/real(nmcs))**2)/(T*T)/real(N)
      xi = (cum(4)/real(nmcs) - (cum(3)/real(nmcs))**2)/T/real(N)
      print *, "Heat capacity                =", c
      print *, "Magnetic susceptibility              =", xi
   end subroutine output

end module common

program ising
   !  metropolis algorithm for the ising model on a square lattice
   use common
   integer :: imcs, ispin, jspin
   real(kind=double), dimension(5) :: cum
   call initial(cum)
   !  equilibrate system
   do imcs = 1, nequil
      call metropolis()
   end do

   open (unit=7, file='energy_magnetization.dat', status='replace')
   !  accumulate data while updating spins
   do imcs = 1, nmcs
      call metropolis()
      call data(cum)

      write (7, *) E/real(N), M/real(N)
   end do
   call output(cum)

   close (7)

! write the coordinates of spins up and down on files for plotting
   open (unit=8, file='ising-up.dat', status='replace')
   open (unit=9, file='ising-down.dat', status='replace')
   do jspin = 0, L + 1
      do ispin = 0, L + 1
         if (spin(ispin, jspin) == 1) write (8, *) ispin, jspin
         if (spin(ispin, jspin) == -1) write (9, *) ispin, jspin
      end do
   end do
   close (8)
   close (9)

   deallocate (spin)
end program ising
