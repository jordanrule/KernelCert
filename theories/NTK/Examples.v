From Stdlib Require Import Reals List Ring.
Import ListNotations.

From KernelCert.NTK Require Import Core Affine Asymptotic JacobianMap.

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

Example jacobian_map_first_preimage_hits_100 :
  jc_map jc_p1 = (1, 0, 0).
Proof.
  apply jc_map_p1_to_100.
Qed.

Example jacobian_map_fourth_preimage_hits_100 :
  jc_map jc_p4 = (1, 0, 0).
Proof.
  apply jc_map_p4_to_100.
Qed.

Example jacobian_map_ntk_symmetric_at_fixed_context :
  forall x1 x2,
    jc_ntk (11 / 3) (-475 / 9) x1 x2 = jc_ntk (11 / 3) (-475 / 9) x2 x1.
Proof.
  intros x1 x2.
  apply jc_ntk_symmetric.
Qed.
