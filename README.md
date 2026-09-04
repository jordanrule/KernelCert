# KernelCert

`KernelCert` is a small, demonstrative Coq formalization of three kernel-oriented proof tracks: an NTK, a quantum neural tangent kernel surrogate, and a zeta-kernel scaffold linked to the Riemann program. The common thread is formal verification of kernel structure together with an explicit asymptotic property: infinite-width convergence, large-system scaling, or harmonic decay. The repository is intentionally small, but its layout leaves room for more kernel families in the future.

At a glance:

- **NTK**: a finite-feature kernel with an infinite-width convergence theorem and a training-time constancy theorem.
- **Quantum**: a QNTK surrogate with scalable and fault-tolerant large-system behavior.
- **Riemann/Zeta Kernel**: a harmonic kernel scaffold with symmetry, positive semidefiniteness, and decaying zeta-style features.

## Neural Tangent Kernel (NTK)

This section isolates the core empirical NTK idea:

> an NTK can be written as a Jacobian-feature inner product.

### What is formalized here?

This Coq project proves a tiny but useful slice of NTK theory:

1. A finite-dimensional feature-map kernel
   \[
   K_\phi(x, y) = \langle \phi(x), \phi(y) \rangle
   \]
   is symmetric.
2. Its finite Gram quadratic form is nonnegative, i.e. it is positive semidefinite in the standard kernel sense.
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
4. A width-indexed NTK family converges pointwise to a limiting kernel under eventual feature stability (formalized in `pointwise_limit_of_width_kernels`).
5. If the Jacobian feature is parameter-independent, the NTK is constant across training time indices.
6. A polynomial Jacobian-map case study is embedded as an NTK feature source: the map is defined in Coq, the listed four preimages are proved to share the image `(1,0,0)`, and the induced projected NTK inherits symmetry/PSD/convergence/constancy results from the core theory.

This is intentionally small and illustrative. It gives a concrete formal proof of the Jacobian-contraction picture, extends it with an explicit infinite-width convergence layer, and captures a training-time constancy theorem for parameter-independent Jacobians.

### Theory and practice

#### Theory

The NTK of a model is the inner product of output derivatives with respect to parameters. For a scalar-output network `f(θ, x)`, the empirical NTK is

\[
K(x,y) = \left\langle \nabla_\theta f(\theta, x), \nabla_\theta f(\theta, y) \right\rangle.
\]

In the infinite-width regime this kernel can become nearly constant during training, which is one of the key reasons NTKs are useful in theory: gradient descent can then be approximated by kernel regression dynamics. This repository includes a formal pointwise convergence theorem for width-indexed NTKs under eventual feature stability assumptions.

#### Practice

In practice, empirical NTKs are often computed by contracting Jacobians. This repository formalizes that core algebraic idea in the smallest setting where the proof is easy to read:

- a 2-dimensional parameter space,
- a scalar affine model,
- an exact closed-form kernel,
- and a proof that every finite Gram quadratic form is nonnegative.

### File layout

- `theories/NTK/Core.v`:
  general finite-feature kernel machinery over 2D real features, including:
  - symmetry of `kernel_of`,
  - an explicit Jacobian-feature contraction theorem,
  - a Gram/quadratic-form identity,
  - nonnegativity of the induced quadratic form.
- `theories/NTK/Asymptotic.v`:
  asymptotic NTK statements, including:
  - an infinite-width convergence theorem from eventual feature stability,
  - a training-time NTK constancy theorem from parameter-independent Jacobians.
- `theories/NTK/Affine.v`:
  the affine network instance with feature `(x, 1)` and closed-form NTK `xy + 1`, plus concrete instantiations of the convergence and constancy theorems.
- `theories/NTK/JacobianMap.v`:
  a polynomial Jacobian-map case study that:
  - defines `t = 1 + xy`, `q = t^2 z + y^2 (1 + 3t)`, and the 3D polynomial map,
  - proves the four stated points map to `(1,0,0)`,
  - projects map components into a 2D NTK feature and reuses core symmetry/PSD/asymptotic theorems.
- `theories/NTK/Examples.v`:
  tiny sanity-check examples, including a direct demonstration of the Jacobian-feature contraction identity.

### Build

If Coq is installed, build the project from this directory with:

```sh
make ntk
```

To build both NTK and Quantum proof targets together:

```sh
make all
```

To clean generated Coq artifacts:

```sh
make clean
```


## Quantum Neural Tangent Kernel (QNTK)

This section introduces a compact, assumption-explicit formalization of quantum neural tangent kernel concepts. The structure now mirrors common QNTK literature flow: state primitives (superposition/entanglement), then derived kernel properties (noise robustness and scaling). The large-system scaling lemmas play the same asymptotic role that infinite-width limits play in the classical NTK track.

### What is formalized here?

1. **Fault Tolerance (non-vacuous bound)**: for nonnegative ideal signal and error rate in `[0,1]`, the noisy QNTK estimate is proved to stay between `0` and the ideal value.
2. **Scalability (linear and monotone)**: the size-indexed QNTK surrogate is linear in system size, monotone under nonnegative per-qubit contribution, and has a one-step increment law.
3. **Compositional quantum gains**: superposition and entanglement gains are represented explicitly as abstract nonnegative contributions used in a derived effective QNTK estimate.

### File layout

- `theories/Quantum/KernelProof.v`:
  assumption-explicit QNTK proof layer with:
  - multiplicative noise attenuation model,
  - formal lower/upper noise bound,
  - linear and monotone size scaling lemmas,
  - effective estimate construction from base + superposition + entanglement gains.
- `theories/Quantum/Superposition.v`:
  minimal linear-combination state model used as a superposition-side primitive.
- `theories/Quantum/Entanglement.v`:
  minimal entanglement-side primitives and a nonnegativity result for a size-indexed interaction-strength surrogate.

### Build

If Coq is installed, build the project from this directory with:

```sh
make quantum
```


To clean generated Coq artifacts:

```sh
make clean
```

This project remains a pedagogical artifact focused on foundational principles, compiler-style formalization, and basic quantum-kernel reasoning rather than a complete production-grade quantum machine learning stack.

## Riemann Hypothesis / Zeta Kernel

This section replaces the earlier gap-based scaffold with a zeta-kernel scaffold. It does **not** claim an unconditional proof of RH. Instead, it formalizes a symmetric, positive semidefinite kernel induced by a harmonic feature map `1/(n+1)`. The goal is to make a small but honest step toward RH-oriented formal analysis: a countable kernel family with explicit decay and a finite quadratic form that is machine-checkable in Coq.

### What is formalized here?

1. The zeta feature map is positive and decays with index.
2. The induced zeta kernel is symmetric.
3. Finite Gram quadratic forms for the zeta kernel are nonnegative.
4. The construction is positioned as a scaffold for future RH work rather than an unconditional proof.

### Why does this matter?

A fully formal proof of the Riemann Hypothesis would sharpen a number of estimates in analytic number theory. That could indirectly affect security engineering in places that rely on prime-distribution heuristics, zero-free-region assumptions, or number-theoretic cost models. It would not by itself imply an immediate break of modern public-key cryptography, but it could tighten the analysis around systems that depend on such estimates.

### File layout

- `theories/Riemann/Zeta.v`:
  the Zeta Kernel development, including:
  - the harmonic feature map `zeta_feature`,
  - symmetry of `zeta_kernel`,
  - positive semidefiniteness of the finite quadratic form,
  - decay of the feature map for large indices.

### Build

If Coq is installed, build the Zeta Kernel target with:

```sh
make riemann
```

To build all Coq targets currently wired in the Makefile:

```sh
make all
```

To clean generated Coq artifacts:

```sh
make clean
```

## License

This subproject is licensed under the MIT License. See `LICENSE`.
