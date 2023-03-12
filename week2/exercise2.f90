program main
    implicit none
    real, parameter :: dr=0.01, top=1.
    integer, parameter :: N=10000, n_slices = CEILING(top / dr) + 1
    real, dimension(N) :: rnd
    integer, dimension(n_slices) :: bins

    call random_number(rnd)
    bins = binify(rnd)
    call make_histogram(bins, generate_labels())

    contains

    function binify(values) result(bins)
        real, dimension(N) :: values
        integer, dimension(n_slices) :: bins
        integer :: i, idx

        bins = 0

        values = values / dr
        do i=1, N
            idx = FLOOR(values(i)) + 1
            bins(idx) = bins(idx) + 1
        end do
    end function

    function generate_labels() result(ls)
        character(len=20), dimension(n_slices) :: ls
        integer :: i

        do i=1, n_slices
            write(ls(i), "(f10.3)") dr * (i-1)
        end do
    end function

    subroutine make_histogram(bins, labels)
        integer, dimension(n_slices), intent(in) :: bins
        character(len=20), dimension(n_slices), intent(in) :: labels
        integer :: i
        character, allocatable, dimension(:) :: histogram_line

        do i=1, n_slices
            allocate(histogram_line(bins(i)))
            histogram_line = '*'
            print*, labels(i), histogram_line
            deallocate(histogram_line)
        end do
    end subroutine

end program main