From Stdlib Require Import Reals List Ring.
Import ListNotations.

From KernelCert.NTK Require Import Core Affine Asymptotic.

Local Open Scope R_scope.

Example affine_ntk_2_3 :
  affine_ntk 2 3 = 7.
Proof.
  rewrite affine_ntk_closed_form.
  ring.
Qed.

Example affine_kernel_quadratic_two_points :
  kernel_quadratic affine_jacobian_feature [2; 3] [1; -1] = 1.
Proof.
  rewrite affine_kernel_quadratic_closed_form.
  simpl.
  ring.
Qed.

Example affine_kernel_quadratic_zero_coeffs :
  kernel_quadratic affine_jacobian_feature [5; -4; 9] [0; 0; 0] = 0.
Proof.
  rewrite affine_kernel_quadratic_closed_form.
  simpl.
  ring.
Qed.

Example jacobian_feature_contraction_identity :
  forall phi x y,
    kernel_of phi x y = dot (phi x) (phi y).
Proof.
  intros phi x y.
  apply kernel_of_is_jacobian_feature_contraction.
Qed.

Example affine_width_limit_at_2_3 :
  forall eps,
    0 < eps ->
    exists N,
      forall n,
        (N <= n)%nat ->
        Rabs (width_kernel affine_width_features n 2 3 - affine_ntk 2 3) < eps.
Proof.
  intros eps Heps.
  unfold affine_ntk.
  eapply affine_ntk_infinite_width_convergence.
  exact Heps.
Qed.

Example affine_ntk_constant_across_time :
  forall theta_t t1 t2,
    ntk_trajectory affine_jacobian_map theta_t t1 2 3 =
    ntk_trajectory affine_jacobian_map theta_t t2 2 3.
Proof.
  intros theta_t t1 t2.
  apply affine_ntk_training_time_constancy.
Qed.


