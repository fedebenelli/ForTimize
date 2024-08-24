module ForTimize__base
   use ForTimize__constants, only: pr
   implicit none

   type, abstract :: Optimizer
   contains
      procedure(optimize), deferred :: optimize
   end type Optimizer

   abstract interface
      subroutine objective_function(X, F, dF, data)
         import pr
         real(pr), intent(in) :: X(:)
         real(pr), intent(out) :: F
         real(pr), optional, intent(out) :: dF(:)
         class(*), optional, intent(in out) :: data
      end subroutine objective_function
   end interface

   abstract interface
      subroutine optimize(self, foo, X, F, data)
         import pr, objective_function, Optimizer
         class(Optimizer), intent(in out) :: self
         procedure(objective_function) :: foo
         real(pr), intent(in out) :: X(:)
         real(pr), intent(out) :: F
         class(*), optional, target, intent(in out) :: data
      end subroutine optimize
   end interface
end module ForTimize__base
