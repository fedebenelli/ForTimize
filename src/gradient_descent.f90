module ForTimize_gradient_descent
  use iso_fortran_env, only: real64
  use ForTimize_base, only: NonLinearOptimizer, grad, objective
  implicit none

  type, extends(NonLinearOptimizer) :: GradientDescent
    real(real64) :: convergence_tolerance=1e-5
    integer :: max_iters = 10000
    real(real64) :: step=1e-3
    procedure(grad), nopass, pointer :: df
  contains
    procedure :: optimize => optimize
  end type

  abstract interface
    function step(x)
      import real64
      real(real64), intent(in) :: x(:)
      real(real64) :: step
    end function
  end interface

contains

  subroutine optimize(self, f, x0, x, y)
    class(GradientDescent), intent(in) :: self
    procedure(objective) :: f
    real(real64), intent(in) :: x0(:)
    real(real64), intent(out) :: x(:)
    real(real64), intent(out) :: y

    integer :: iters

    x = x0
    do iters = 1,self%max_iters
      x = x - self%step * self%df(x)
    end do
    y = f(x)

  contains
    function numdiff(xx)
      real(real64), intent(in) :: xx(:)
      real(real64) :: numdiff(size(xx))
      numdiff = df(f, xx)
    end function
  end subroutine

  function df(f, x)
    procedure(objective) :: f
    real(real64), intent(in) :: x(:)
    real(real64) :: df(size(x))

    integer :: i
    real(real64) :: dx=1e-5, xdx(size(x))

    do i=1, size(x)
      xdx = x
      xdx(i) = xdx(i) + dx
      df(i) = (f(xdx) - f(x))/dx
    end do
  end function
end module
