module ForTimize__with_derivatives_gradient_descent
   use ForTimize__base, only: pr, Optimizer, objective_function
   implicit none

   type, extends(Optimizer) :: GradientDescent
      real(pr) :: convergence_tolerance=1e-5
      integer :: max_iters = 10000
      real(pr) :: step=1e-3
   contains
      procedure :: optimize => optimize
   end type GradientDescent

   abstract interface
      function step(x)
         import pr
         real(pr), intent(in) :: x(:)
         real(pr) :: step
      end function step
   end interface

contains

   subroutine optimize(self, foo, X, F, data)
      class(GradientDescent), intent(in out) :: self
      procedure(objective_function) :: foo
      real(pr), intent(in out) :: x(:)
      real(pr), intent(out) :: F
      class(*), optional, target, intent(in out) :: data

      real(pr) :: dF(size(x))

      integer :: iters

      do iters = 1, self%max_iters
         call foo(X, F, dF, Data)
         x = x - self%step * dF
      end do
   end subroutine optimize
end module ForTimize__with_derivatives_gradient_descent
