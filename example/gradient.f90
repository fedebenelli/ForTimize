module my_foos
    use iso_fortran_env, only: real64
    implicit none

    real(real64) :: data_x(3) = [1.3, 2.6, 3.3]
    real(real64) :: data_y(3) = [2.3, 5.6, 9.3]

contains

    function f(x) result(y)
        real(real64), intent(in) :: x(:)
        real(real64) :: y

        real(real64) :: yhat(size(data_x))

        associate(a => x(1), b => x(2), c => x(3))
            yhat = a * data_x **2 + b * data_x + c
        end associate

        y = sum((yhat - data_y)**2)
    end function
    
    function df(x) result(dy)
        real(real64), intent(in) :: x(:)
        real(real64) :: dy(size(x))

        real(real64) :: dx(3)
        integer :: i

        do i=1,3
            dx = 0
            dx(i) = 1e-10
            dy(i) = (f(x + dx) - f(x - dx))/(2.0*dx(i))
        end do

    end function

end module

program grad_descent
    use my_foos, only: f, df
    use ForTimize, only: GradientDescent, minimize

    type(GradientDescent) :: optimizer
    real(8) :: y, x(3), x0(3)

    optimizer%df => df
    x0 = [0.3, 0.5, 0.1]
    call minimize(f, x0, x, y, optimizer)
end program
