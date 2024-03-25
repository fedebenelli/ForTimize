module ForTimize_base
  use iso_fortran_env, only: real64
  implicit none

  type, abstract :: NonLinearOptimizer
  contains
    procedure(optimize), deferred :: optimize
  end type

  abstract interface
    function objective(x) result(y)
      import real64
      real(real64), intent(in) :: x(:)
      real(real64) :: y
    end function

    subroutine optimize(self, f, x0, x, y)
      import real64, NonLinearOptimizer
      class(NonLinearOptimizer), intent(in) :: self
      procedure(objective) :: f
      real(real64), intent(in) :: x0(:)
      real(real64), intent(out) :: x(:)
      real(real64), intent(out) :: y
    end subroutine

    function grad(x) result(dy)
      import real64
      real(real64), intent(in) :: x(:)
      real(real64) :: dy(size(x))
    end function
  end interface

contains

  subroutine minimize(f, x0, x, y, optimizer)
    procedure(objective) :: f
    real(real64), intent(in) :: x0(:)
    real(real64), intent(out) :: x(:)
    real(real64), intent(out) :: y
    class(NonLinearOptimizer) :: optimizer
    call optimizer%optimize(f, x0, x, y)
  end subroutine
end module ForTimize_base
