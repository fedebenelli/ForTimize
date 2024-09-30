!! Example where we use the gradient descent method to fit the parameters of a
!! quadratic function to a set of data points. The function to be minimized is
!! the sum of the squared differences between the data points and the function
!! values at the same x coordinates.
!!
!! As an alternative method we also use the Nelder-Mead method to minimize the
!! same function.
module fixture_problem
   use ForTimize, only: pr
   implicit none

   real(pr) :: data_x(3) = [1.3, 2.6, 3.3]
   real(pr) :: data_y(3) = [2.3, 5.6, 9.3]

contains

   elemental subroutine quadratric(x, a, b, c, F, dF)
      real(pr), intent(in) :: x
      real(pr), intent(out) :: F
      real(pr), optional, intent(out) :: dF
      real(pr), intent(in) :: a, b, c
      F = a * x**2 + b * x + c
      if (present(dF)) dF = 2.0 * a * x + b
   end subroutine quadratric

   subroutine foo(X, F, dF, data)
      real(pr), intent(in) :: x(:)
      real(pr), intent(out) :: F
      real(pr), optional, intent(out) :: dF(:)
      class(*), optional, intent(in out) :: data

      real(pr) :: yhat(3), dyhat(3), dx(3), xin(3)

      integer :: i

      call quadratric(data_x, x(1), x(2), x(3), yhat, dyhat)
      F = sum((yhat - data_y)**2)

      if (present(dF)) then
         dF = 2 * sum(yhat - data_y) * dyhat
      end if
   end subroutine foo
end module fixture_problem

program test
   use ForTimize, only: GradientDescent, minimize, NelderMead
   use fixture_problem, only: foo

   type(GradientDescent) :: optimizer
   type(NelderMead) :: nmopt
   real(8) :: yold, y, x(3), x0(3)

   x0 = [1.3, -2.5,  1.]
   optimizer%step = 0.001
   optimizer%max_iters = 1000

   call foo(x0, yold)

   call minimize(foo, x0, y, optimizer)
   if (yold < y) error stop 1

   call minimize(foo, x0, y, nmopt)
   if (yold < y) error stop 1
end program test
