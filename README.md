# ForTimize
General API for optimizing routines

```fortran
program grad_descent
    use my_foos, only: f, df
    use ForTimize, only: GradientDescent, minimize
    use iso_fortran_env, only: real64

    type(GradientDescent) :: optimizer
    real(real64) :: y, x(3), x0(3)

    optimizer%df => df

    x0 = [0.3, 0.5, 0.1]
    call minimize(f, x0, x, y, optimizer)

    print *, x
end program

```
