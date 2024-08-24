module ForTimize__minimize
   use ForTimize__constants, only: pr
   use ForTimize__base, only: Optimizer, objective_function
   use ForTimize__gradient_free_nelder_mead, only: NelderMead
   implicit none
contains
   subroutine minimize(f, x, y, optim, data)
      !! Minimize the objective function f.
      !! If no optimizer is provided, the Nelder-Mead algorithm will be used
      !! as default.
      procedure(objective_function) :: f !! Objective function
      real(pr), intent(in out) :: x(:) !! Vector of parameters
      real(pr), intent(out) :: y !! Function value after optimization
      class(Optimizer), optional :: optim !! Optimizing algorithm
      class(*), optional, target, intent(in out) :: data !! Optional data to be passed to the objective function

      type(NelderMead) :: nmopt

      if (present(optim)) then
         call optim%optimize(f, X, Y, data)
      else
         call nmopt%optimize(f, X, Y, data)
      end if
   end subroutine minimize
end module ForTimize__minimize
