From Stdlib Require Import Reals Psatz Arith.

From KernelCert.NTK Require Import Core.

Local Open Scope R_scope.

(** Width-indexed Jacobian features and their induced kernels. *)
Definition width_feature := nat -> R -> vec2.

Definition width_kernel (phiN : width_feature) (n : nat) : R -> R -> R :=
  kernel_of (phiN n).

Definition pointwise_limit_of_width_kernels
    (phiN : width_feature) (phi_inf : R -> vec2) : Prop :=
  forall x y eps,
    0 < eps ->
    exists N,
      forall n,
        (N <= n)%nat ->
        Rabs (width_kernel phiN n x y - kernel_of phi_inf x y) < eps.

Theorem ntk_infinite_width_convergence_from_eventual_feature_stability :
  forall phiN phi_inf,
    (forall x,
      exists Nx,
        forall n,
          (Nx <= n)%nat ->
          phiN n x = phi_inf x) ->
    pointwise_limit_of_width_kernels phiN phi_inf.
Proof.
  intros phiN phi_inf Hstable.
  unfold pointwise_limit_of_width_kernels.
  intros x y eps Heps.
  destruct (Hstable x) as [Nx Hx].
  destruct (Hstable y) as [Ny Hy].
  exists (Nat.max Nx Ny).
  intros n Hn.
  assert (Hnx : (Nx <= n)%nat).
  { eapply Nat.le_trans. apply Nat.le_max_l. exact Hn. }
  assert (Hny : (Ny <= n)%nat).
  { eapply Nat.le_trans. apply Nat.le_max_r. exact Hn. }
  specialize (Hx n Hnx).
  specialize (Hy n Hny).
  unfold width_kernel, kernel_of.
  rewrite Hx, Hy.
  replace (dot (phi_inf x) (phi_inf y) - dot (phi_inf x) (phi_inf y)) with 0 by ring.
  rewrite Rabs_R0.
  exact Heps.
Qed.

(** Time-indexed NTK trajectory induced by a Jacobian feature map [J]. *)
Definition ntk_trajectory (J : vec2 -> R -> vec2) (theta_t : nat -> vec2)
    (t : nat) (x y : R) : R :=
  dot (J (theta_t t) x) (J (theta_t t) y).

Theorem ntk_training_time_constancy_from_parameter_independent_jacobian :
  forall J theta_t,
    (forall theta1 theta2 x, J theta1 x = J theta2 x) ->
    forall t1 t2 x y,
      ntk_trajectory J theta_t t1 x y =
      ntk_trajectory J theta_t t2 x y.
Proof.
  intros J theta_t Hindep t1 t2 x y.
  unfold ntk_trajectory.
  assert (Hx : J (theta_t t1) x = J (theta_t t2) x).
  { apply Hindep. }
  assert (Hy : J (theta_t t1) y = J (theta_t t2) y).
  { apply Hindep. }
  rewrite Hx, Hy.
  reflexivity.
Qed.

