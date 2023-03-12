program main
   implicit none
   !
   ! declaration of variables
   integer, parameter :: number = 20
   integer, dimension(number) :: random_numbers
   integer :: i, seed, a, m, c, period
   !
   ! supply initial values of some variables:
   ! seed: to start;
   ! number: how many numbers we want to generate
   print *, "seed, a ,m , c>"
   read (*, *) seed, a, m, c
   random_numbers = lcm(number, a, m, c, seed)
   print *, random_numbers
   print *, "All values appear? ", check_all_values_appear(random_numbers, m)
   period = find_period(a, m, c, seed)
   print *, "Period: ", period

   stop

contains

   function lcm(number, a, m, c, seed) result(rnd)
      integer, intent(in) :: number, seed, a, m, c
      integer :: old
      integer, dimension(number) :: rnd

      old = seed
      do i = 1, number
         rnd(i) = mod((a*old + c), m)
         old = rnd(i)
      end do
   end function

   function check_all_values_appear(nums, m) result(check)
      integer, dimension(:), intent(in) :: nums
      integer, intent(in) :: m
      logical, allocatable, dimension(:) :: check_nums
      logical :: check

      allocate (check_nums(m))
      do i = 1, SIZE(nums)
         check_nums(nums(i) + 1) = .TRUE.
      end do

      check = .TRUE.
      do i = 1, m
         check = check .and. check_nums(i)
      end do
   end function

   function find_period(a, m, c, seed) result(period)
      integer, intent(in) :: seed, a, m, c
      integer :: period, la
      integer, dimension(m) :: last_appearance
      integer, dimension(m + 1) :: random_numbers

      ! initialize last_appearance
      last_appearance = -1

      period = -1
      random_numbers = lcm(m + 1, a, m, c, seed)
      do i = 1, SIZE(random_numbers)
         print *, i, random_numbers(i)
         la = last_appearance(random_numbers(i) + 1)
         if (la .ne. -1) then
            period = i - la
            exit
         end if
         last_appearance(random_numbers(i) + 1) = i
      end do
   end function
end program main
