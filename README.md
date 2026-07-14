# KernelCert

`KernelCert` is a small, demonstrative Coq formalization of a Neural Tangent
Kernel (NTK). Rather than attempting to certify the full `neural-tangents`
codebase, this directory isolates the core empirical NTK idea used there:

> an NTK can be written as a Jacobian-feature inner product.

That is the viewpoint used in
`neural-tangents/neural_tangents/_src/empirical.py`, where the empirical NTK is
computed by instantiating Jacobians and contracting them.

## What is formalized here?

This Coq project proves a tiny but useful slice of NTK theory:

1. A finite-dimensional feature-map kernel
   \[
   K_\phi(x, y) = \langle \phi(x), \phi(y) \rangle
   \]
   is symmetric.
2. Its finite Gram quadratic form is nonnegative, i.e. it is positive
   semidefinite in the standard kernel sense.
3. For a scalar affine network
   \[
   f_{(w,b)}(x) = wx + b,
   \]
   the parameter-Jacobian feature is
   \[
   \phi(x) = (x, 1),
   \]
   so the induced NTK is
   \[
   K(x,y) = xy + 1.
   \]

This is intentionally small and illustrative. It gives a concrete formal proof
of the “Jacobian contraction” picture without pulling in the full machinery of
infinite-width limits, convolutional architectures, or JAX semantics.

## Theory and practice

### Theory

The NTK of a model is the inner product of output derivatives with respect to
parameters. For a scalar-output network `f(θ, x)`, the empirical NTK is

\[
K(x,y) = \left\langle \nabla_\theta f(\theta, x), \nabla_\theta f(\theta, y) \right\rangle.
\]

In the infinite-width regime this kernel can become nearly constant during
training, which is one of the key reasons NTKs are useful in theory: gradient
descent can then be approximated by kernel regression dynamics.

### Practice

In practice, libraries such as `neural-tangents` often compute empirical NTKs
by explicitly or implicitly contracting Jacobians. This repository formalizes
that core algebraic idea in the smallest setting where the proof is easy to
read:

- a 2-dimensional parameter space,
- a scalar affine model,
- an exact closed-form kernel,
- and a proof that every finite Gram quadratic form is nonnegative.

## File layout

- `theories/NTK/Core.v`:
  general finite-feature kernel machinery over 2D real features, including:
  - symmetry of `kernel_of`,
  - a Gram/quadratic-form identity,
  - nonnegativity of the induced quadratic form.
- `theories/NTK/Affine.v`:
  the affine network instance with feature `(x, 1)` and closed-form NTK
  `xy + 1`.
- `theories/NTK/Examples.v`:
  tiny sanity-check examples.

## Build

If Coq is installed, build the project from this directory with:

```sh
make
```

or directly with:

```sh
coqc -Q theories KernelCert theories/NTK/Core.v
coqc -Q theories KernelCert theories/NTK/Affine.v
coqc -Q theories KernelCert theories/NTK/Examples.v
```

To clean generated Coq artifacts:

```sh
make clean
```

## Scope and limitations

This is a pedagogical certification artifact, not a full formalization of the
entire `neural-tangents` library. In particular, it does **not** prove:

- infinite-width convergence,
- training-time constancy of the NTK,
- convolutional or deep architectures,
- or the correctness of JAX execution.

Instead, it certifies a compact mathematical core that mirrors the structure of
empirical NTK computation.

## License

This subproject is licensed under the MIT License. See `LICENSE`.

