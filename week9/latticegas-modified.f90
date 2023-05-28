! with additional lines to calculate other quantities,
! including the variance of the <Delta R^2(t)>
program latticegas

   implicit none

   logical, allocatable :: lattice(:, :)
   integer, allocatable :: x(:), y(:)
   double precision, allocatable :: dx(:), dy(:)

   integer  :: unit_number
   integer  :: istep, isubstep
   integer  :: dir, i, j, nfail, njumps, sizer
   integer, dimension(:), allocatable :: seed

   integer, parameter  ::  MAXINT = 1000000000, Nsteps=1000, Np=13, L=20
   logical, parameter :: FOLLOW_EACH_PARTICLE = .false.

   ! allowed    directions
   integer :: free(4), nfree
   integer :: dxtrial(4), dytrial(4)
   integer :: xnew(4), ynew(4)

   real, dimension(2) :: rnd(2)
   real :: rnd1
   double precision :: dxsum, dysum, dxsqsum, dysqsum, dx4thsum, dy4thsum, vardrsqave
   double precision :: t, deltat, drsqave, D, a, Dave_in_t

   call random_seed(sizer)
   allocate (seed(sizer))
   seed = 0.
   call random_seed(put=seed)

   ! Set average time  between jumps and jump length Units is s and cm
   ! although actually this is not needed for the simulation
   deltat = 1d-9 ! 1 ns
   a = 2e-8      ! 2 Ang

   print *, 'Doing lattice gas walk to', Nsteps
   print *, 'using', Np, ' particles  on a', L, '^2 square lattice'

   if (Np >= L*L) then
      print *, 'Number of particles > number of sites !!!'
      STOP 'Too small lattice'
   end if

   allocate (lattice(0:L - 1, 0:L - 1))
   allocate (x(Np), y(Np))
   allocate (dx(Np), dy(Np))

   ! Mark all positions as empty
   lattice = .false.

   ! enumeration of directions: 1 left 2 right 3 up 4 down
   dxtrial(1) = +1; dytrial(1) = 0; 
   dxtrial(2) = -1; dytrial(2) = 0; 
   dxtrial(3) = 0; dytrial(3) = +1; 
   dxtrial(4) = 0; dytrial(4) = -1; 
   nfail = 0; njumps = 0; 
   ! Generate particles on lattice
   do i = 1, Np
      do ! Loop until empty position found
         call random_number(rnd)
         x(i) = floor(rnd(1)*L); 
         y(i) = floor(rnd(2)*L); 
         if (lattice(x(i), y(i))) then
            ! Position already filled, loop to find new trial
            cycle
         else
            lattice(x(i), y(i)) = .true.
            !  Success, go  to next particle
            exit
         end if
      end do
      dx(i) = 0.0d0; dy(i) = 0.0d0; 
   end do

   write (1, fmt=*) '# Density Np/L^2=', real(Np)/L**2, '; Np=', Np, '; L=', L
   write (1, fmt=*) '#  t, drsqave(t), sqrt(var(drsqave(t))/Np), D(t), <D>_T'

   t = 0.0; Dave_in_t = 0.d0
   do istep = 0, Nsteps - 1 ! Loop over MC steps
      do isubstep = 1, Np ! Do all particles on average once every MC step
         call random_number(rnd1)
         i = int(rnd1*Np) + 1; if (i > Np) i = Np; 
         ! Find possible directions, store it in free()
         nfree = 0
         do j = 1, 4
            xnew(j) = mod(x(i) + dxtrial(j), L); 
            ynew(j) = mod(y(i) + dytrial(j), L); 
            if (.not. lattice(xnew(j), ynew(j))) then
               ! Success: position free
               nfree = nfree + 1
               free(nfree) = j
            end if
         end do

         ! If no possible directions, get new particle
         if (nfree == 0) then
            nfail = nfail + 1
            cycle
         end if
         njumps = njumps + 1

         !  Pick  one of  the  possible directions  randomly
         call random_number(rnd1)
         dir = int(rnd1*nfree) + 1; if (dir > nfree) dir = nfree
         j = free(dir)

         !Empty  old  position  and  fill  new
         lattice(x(i), y(i)) = .false.
         lattice(xnew(j), ynew(j)) = .true.

         x(i) = xnew(j); y(i) = ynew(j); 
         dx(i) = dx(i) + dxtrial(j); dy(i) = dy(i) + dytrial(j); 
         ! Use with caution
         if (FOLLOW_EACH_PARTICLE) then
            unit_number = 10 + i
            write (unit_number, *) dx(i)**2 + dy(i)**2     ! see "part[particle_index]"
         end if
      end do

      if (mod(istep*Np, 1000000) == 0) then
         ! Get total displacement from dx,dy
         dxsum = sum(dx); 
         dysum = sum(dy); 
         dxsqsum = sum(dx*dx); 
         dysqsum = sum(dy*dy); 
         dx4thsum = sum(dx**4); 
         dy4thsum = sum(dy**4); 
         drsqave = (dxsqsum + dysqsum)/Np
         vardrsqave = (dx4thsum + dy4thsum)/Np - ((dxsqsum + dysqsum)/Np)**2

         if (t > 0.0) then
            !  Get  diffusion coefficient  by  proper scaling
            D = drsqave*a*a/(4*t)
            Dave_in_t = Dave_in_t + D
            write (1, fmt='(5(1pe10.2,2x))') t, drsqave, sqrt(vardrsqave/Np), D, Dave_in_t/t
         end if

      end if

      t = t + deltat

   end do

   !  Get   total  displacement   from  dx,dy
   dxsum = sum(dx); 
   dysum = sum(dy); 
   dxsqsum = sum(dx*dx); 
   dysqsum = sum(dy*dy); 
   print *, 'dxsum', dxsum, '   dysum', dysum
   print *, 'dxsqsum', dxsqsum, ' dysqsum', dysqsum

   drsqave = (dxsqsum + dysqsum)/(1.0*Np)
   print *, 'drsqave', drsqave
   print *, 'Number of  failed jumps', nfail, ' number of  successes', njumps
   ! Get diffusion  coefficient  by  proper scaling
   D = drsqave*a*a/(4*t)
   write (*, fmt='(3(a,1pe10.2))') 'Density Np/L^2=', real(Np)/L**2, ' :  t=', t, ';   D=', D

end program latticegas
