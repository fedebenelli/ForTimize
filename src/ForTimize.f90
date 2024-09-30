module ForTimize
  !! # ForTimize: A Fortran optimization library
  !!
  !! ## Description
  !! ForTimize focuses on providing a simple and easy-to-use interface for
  !! optimization algorithms in Fortran. It is designed to be modular and
  !! extensible, allowing users to easily add new optimization algorithms.
  !!
  !! ## Usage
  !! To use ForTimize, simply include the `ForTimize` module in your program.
  !! 
  !! ### Objective Function
  !! The function that you want to minimize should have the following signature:
  !! ```fortran
  !! subroutine foo(X, F, dF, data)
  !!  real(pr), intent(in) :: x(:)
  !!  real(pr), intent(out) :: F
  !!  real(pr), optional, intent(out) :: dF(:)
  !!  class(*), optional, intent(in out) :: data
  !! end subroutine foo
  !! ```
  !! ### Basic calling
  !! ```fortran
  !! use ForTimize, only: minimize
  !! call minimize(foo, x, y)
  !! ```
  use ForTimize__constants, only: pr
  use ForTimize__base
  use ForTimize__minimize, only: minimize
  use ForTimize__with_derivatives
  use ForTimize__gradient_free
  implicit none
end module
