# KernelCert

`KernelCert` is a small, demonstrative Coq formalization of a Neural Tangent Kernel (NTK) and related concepts. This repository is part of a continuing series exploring formal proofs in machine learning and quantum computing. Each section is self-contained and focuses on a specific topic.

## Neural Tangent Kernel (NTK)

This section isolates the core empirical NTK idea:

> an NTK can be written as a Jacobian-feature inner product.

That is the viewpoint used in `neural-tangents/neural_tangents/_src/empirical.py`, where the empirical NTK is computed by instantiating Jacobians and contracting them.

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

This is intentionally small and illustrative. It gives a concrete formal proof of the “Jacobian contraction” picture without pulling in the full machinery of infinite-width limits, convolutional architectures, or JAX semantics. In the current version, that viewpoint is stated explicitly in the core theorem and carried through to the affine instance, with a small example showing the contraction identity in action.

### Theory and practice

#### Theory

The NTK of a model is the inner product of output derivatives with respect to parameters. For a scalar-output network `f(θ, x)`, the empirical NTK is

\[
K(x,y) = \left\langle \nabla_\theta f(\theta, x), \nabla_\theta f(\theta, y) \right\rangle.
\]

In the infinite-width regime this kernel can become nearly constant during training, which is one of the key reasons NTKs are useful in theory: gradient descent can then be approximated by kernel regression dynamics.

#### Practice

In practice, libraries such as `neural-tangents` often compute empirical NTKs by explicitly or implicitly contracting Jacobians. This repository formalizes that core algebraic idea in the smallest setting where the proof is easy to read:

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
- `theories/NTK/Affine.v`:
  the affine network instance with feature `(x, 1)` and closed-form NTK `xy + 1`, using the Jacobian contraction theorem directly.
- `theories/NTK/Examples.v`:
  tiny sanity-check examples, including a direct demonstration of the Jacobian-feature contraction identity.

### Build

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

### Scope and limitations

This is a pedagogical certification artifact, not a full formalization of the entire `neural-tangents` library. In particular, it does **not** prove:

- infinite-width convergence,
- training-time constancy of the NTK,
- convolutional or deep architectures,
- or the correctness of JAX execution.

Instead, it certifies a compact mathematical core that mirrors the structure of empirical NTK computation.

## Quantum Machine Learning Compiler

This section introduces a formalization of quantum machine learning concepts, focusing on the physical principles of superposition and entanglement. The goal is to provide a rigorous foundation for quantum compilers and quantum-kernel reasoning in the context of machine learning.

### What is formalized here?

1. **Superposition**: The ability of a quantum system to exist in multiple states simultaneously. This is represented mathematically as a linear combination of basis states.
2. **Entanglement**: A quantum phenomenon where the state of one particle is dependent on the state of another, no matter the distance between them. This is formalized using tensor products and entangled state vectors.
3. **Quantum Circuit Compilation**: The process of translating high-level quantum algorithms into low-level gate operations, ensuring correctness and optimization.
4. **Fault Tolerance of Quantum Circuits**: A compact formal statement showing that a kernel estimate remains bounded under a small circuit error rate.
5. **Scalability to Large Quantum Systems**: A simple linear-growth argument showing that a kernel estimate scales predictably with increased system size.

### Theory and practice

#### Theory

Quantum machine learning leverages the principles of quantum mechanics to process information in fundamentally new ways. Key theoretical aspects include:

- **Hilbert Spaces**: The mathematical framework for quantum states.
- **Unitary Transformations**: Operations that preserve the norm of quantum states.
- **Measurement**: The process of extracting classical information from a quantum system.

#### Practice

In practice, quantum compilers must:

- Optimize gate sequences to minimize error rates.
- Ensure that compiled circuits respect hardware constraints.
- Verify the correctness of transformations using formal proofs.

### File layout

- `theories/Quantum/Superposition.v`:
  formalization of superposition principles and their mathematical representation.
- `theories/Quantum/Entanglement.v`:
  proofs and examples of entangled states and their properties.
- `theories/Quantum/KernelProof.v`:
  a compact proof layer for fault tolerance and scalability properties of a quantum ML kernel estimate, including a basic formalization of those two design goals.

### Build

If Coq is installed, build the project from this directory with:

```sh
make quantum
```

or directly with:

```sh
coqc -Q theories KernelCert theories/Quantum/Superposition.v
coqc -Q theories KernelCert theories/Quantum/Entanglement.v
coqc -Q theories KernelCert theories/Quantum/KernelProof.v
```

To clean generated Coq artifacts:

```sh
make clean
```

This project remains a pedagogical artifact focused on foundational principles, compiler-style formalization, and basic quantum-kernel reasoning rather than a complete production-grade quantum machine learning stack.

## License

This subproject is licensed under the MIT License. See `LICENSE`.
