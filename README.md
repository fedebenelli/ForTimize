# ForTimize

[![Fortran](https://img.shields.io/badge/Fortran-734f96?logo=fortran&style=flat)](https://fortran-lang.org)
[![fpm](https://img.shields.io/badge/fpm-Fortran_package_manager-734f96)](https://fpm.fortran-lang.org)
[![Documentation](https://img.shields.io/badge/ford-Documentation%20-blueviolet.svg)](https://ipqa-research.github.io/yaeos/)
[![License: MPL 2.0](https://img.shields.io/badge/License-MPL_2.0-brightgreen.svg)](https://github.com/fedebenelli/ForTimize/blob/main/LICENSE)
[![CI](https://github.com/fedebenelli/ForTimize/actions/workflows/CI.yml/badge.svg)](https://github.com/fedebenelli/ForTimize/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/fedebenelli/ForTimize/graph/badge.svg?token=IDJYKV8XK6)](https://codecov.io/gh/fedebenelli/ForTimize)


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
All the optimization algorithms should `extend` the Abstract type `Optimizer`, 
which ensures that the `optimize` method is respected.

```fortran
module my_new_optimizer
    use ForTimize__constants, only: pr
    use ForTimize__core, only: Optimizer, objective_function

    type, extends(Optimizer) :: MyNewAlgorithm
    contains
        procedure :: optimize => optimizer_implementation
    end type

contains

    subroutine optimizer_implementation(self, foo, X, F, data)
        class(Optimizer), intent(in out) :: self 
            !! Optimizer object
        procedure(objective_function) :: foo 
            !! Objective function to minimize
        real(pr), intent(in out) :: X(:) 
            !! Vector of parameters
        real(pr), intent(out) :: F 
            !! Function value after optimization
        class(*), optional, target, intent(in out) :: data 
            !! Optional data that could be useful for the function

        ! Optimizer procedures here.
    end subroutine
```


