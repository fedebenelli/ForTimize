# ForTimize
General API for optimizing routines

## Motivation
Fortran has a huge ecosystem in optimization libraries, but they are dispersed
with different APIs and different ways to define objective functions. This
library aims to standarize the way to call optimization functions to ease the
process of selecting algorithms to optimize problems.

## Disclaimer
This is still a prototype project so big changes can happen

## Examples
For examples of usage check the `examples` directory.

## Objective function definition.
The objective function that should be minimized must have the following
interface

```fortran
module my_objective
    use ForTimize, only: pr

contains

    subroutine foo(X, F, dF, data)
        real(pr), intent(in) :: x(:)
            !! Vector of parameters to optimize
        real(pr), intent(out) :: F 
            !! Value of the objetive function after optimization.
        real(pr), optional, intent(out) :: dF(:) !!
            !! Optional gradient.
        class(*), optional, intent(in out) :: data
            !! Special data that the function could use.

        F = sum(x+2)**2
    end subroutine
end module
```

Then the objective function can be optimized with:

```fortran
program main
    use ForTimize, only: pr, minimize
    use my_objective, only: foo

    real(pr) :: x(3), F

    ! Initial guess
    x = [1, 2, 5]

    ! Minimize uses the Nelder-Mead algorithm as a default    
    call minimize(foo, x, F)
    
    ! Print results
    print *, x
    print *, F
end program

```

## How to include new algorithms
All the optimization algorithms should `extend` the Abstract type `Optimizer`

```fortran
type, extends(Optimizer) :: MyNewAlgorithm
contains
    procedure :: optimize => optimizer_implementation
end type
```


