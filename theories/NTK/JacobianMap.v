From Stdlib Require Import Reals List Psatz Ring Field.
Import ListNotations.

From KernelCert.NTK Require Import Core Asymptotic.

Local Open Scope R_scope.

(** A polynomial map over [R^3] supplied by the user as a Jacobian-map case
    study. We integrate it as a feature source for the NTK machinery while
    keeping the statements algebraic and fully checkable in Coq. *)

Definition triple := (R * R * R)%type.

Definition x_of (u : triple) : R := let '(x, _, _) := u in x.
Definition y_of (u : triple) : R := let '(_, y, _) := u in y.
Definition z_of (u : triple) : R := let '(_, _, z) := u in z.

Definition jc_t (u : triple) : R :=
  1 + x_of u * y_of u.

Definition jc_q (u : triple) : R :=
  (jc_t u) ^ 2 * z_of u + (y_of u) ^ 2 * (1 + 3 * jc_t u).

Definition jc_f1 (u : triple) : R :=
  jc_t u * jc_q u.

Definition jc_f2 (u : triple) : R :=
  3 * y_of u - 11 * jc_f1 u + 9 * x_of u * jc_q u -
  2 * (jc_t u) ^ 2 * (x_of u) ^ 2 * (jc_q u) ^ 4.

Definition jc_f3 (u : triple) : R :=
  6 * x_of u - 9 * (x_of u) ^ 2 * y_of u - 3 * (x_of u) ^ 3 * z_of u +
  (x_of u) ^ 4 * (jc_q u) ^ 4.

Definition jc_map (u : triple) : triple :=
  (jc_f1 u, jc_f2 u, jc_f3 u).

Definition jc_p1 : triple := (0, 11 / 3, -475 / 9).
Definition jc_p2 : triple := (-3, 4 / 3, 125 / 81).
Definition jc_p3 : triple := (6, 1 / 3, -7 / 81).
Definition jc_p4 : triple := (-3, 2 / 3, -1 / 9).

Lemma jc_t_p1 : jc_t jc_p1 = 1.
Proof.
  unfold jc_t, jc_p1, x_of, y_of. simpl. ring.
Qed.

Lemma jc_q_p1 : jc_q jc_p1 = 1.
Proof.
  unfold jc_q, jc_p1, jc_t, x_of, y_of, z_of. simpl. field.
Qed.

Lemma jc_t_p2 : jc_t jc_p2 = -3.
Proof.
  unfold jc_t, jc_p2, x_of, y_of. simpl. field.
Qed.

Lemma jc_q_p2 : jc_q jc_p2 = -1 / 3.
Proof.
  unfold jc_q, jc_p2, jc_t, x_of, y_of, z_of. simpl. field.
Qed.

Lemma jc_t_p3 : jc_t jc_p3 = 3.
Proof.
  unfold jc_t, jc_p3, x_of, y_of. simpl. field.
Qed.

Lemma jc_q_p3 : jc_q jc_p3 = 1 / 3.
Proof.
  unfold jc_q, jc_p3, jc_t, x_of, y_of, z_of. simpl. field.
Qed.

Lemma jc_t_p4 : jc_t jc_p4 = -1.
Proof.
  unfold jc_t, jc_p4, x_of, y_of. simpl. field.
Qed.

Lemma jc_q_p4 : jc_q jc_p4 = -1.
Proof.
  unfold jc_q, jc_p4, jc_t, x_of, y_of, z_of. simpl. field.
Qed.

Lemma jc_f1_p1 : jc_f1 jc_p1 = 1.
Proof.
  unfold jc_f1. rewrite jc_t_p1, jc_q_p1. ring.
Qed.

Lemma jc_f2_p1 : jc_f2 jc_p1 = 0.
Proof.
  unfold jc_f2.
  rewrite jc_f1_p1, jc_t_p1, jc_q_p1.
  unfold jc_p1, x_of, y_of, z_of.
  simpl. field.
Qed.

Lemma jc_f3_p1 : jc_f3 jc_p1 = 0.
Proof.
  unfold jc_f3.
  rewrite jc_q_p1.
  unfold jc_p1, x_of, y_of, z_of.
  simpl. field.
Qed.

Lemma jc_f1_p2 : jc_f1 jc_p2 = 1.
Proof.
  unfold jc_f1. rewrite jc_t_p2, jc_q_p2. field.
Qed.

Lemma jc_f2_p2 : jc_f2 jc_p2 = 0.
Proof.
  unfold jc_f2.
  rewrite jc_f1_p2, jc_t_p2, jc_q_p2.
  unfold jc_p2, x_of, y_of, z_of.
  simpl. field.
Qed.

Lemma jc_f3_p2 : jc_f3 jc_p2 = 0.
Proof.
  unfold jc_f3.
  rewrite jc_q_p2.
  unfold jc_p2, x_of, y_of, z_of.
  simpl. field.
Qed.

Lemma jc_f1_p3 : jc_f1 jc_p3 = 1.
Proof.
  unfold jc_f1. rewrite jc_t_p3, jc_q_p3. field.
Qed.

Lemma jc_f2_p3 : jc_f2 jc_p3 = 0.
Proof.
  unfold jc_f2.
  rewrite jc_f1_p3, jc_t_p3, jc_q_p3.
  unfold jc_p3, x_of, y_of, z_of.
  simpl. field.
Qed.

Lemma jc_f3_p3 : jc_f3 jc_p3 = 0.
Proof.
  unfold jc_f3.
  rewrite jc_q_p3.
  unfold jc_p3, x_of, y_of, z_of.
  simpl. field.
Qed.

Lemma jc_f1_p4 : jc_f1 jc_p4 = 1.
Proof.
  unfold jc_f1. rewrite jc_t_p4, jc_q_p4. ring.
Qed.

Lemma jc_f2_p4 : jc_f2 jc_p4 = 0.
Proof.
  unfold jc_f2.
  rewrite jc_f1_p4, jc_t_p4, jc_q_p4.
  unfold jc_p4, x_of, y_of, z_of.
  simpl. field.
Qed.

Lemma jc_f3_p4 : jc_f3 jc_p4 = 0.
Proof.
  unfold jc_f3.
  rewrite jc_q_p4.
  unfold jc_p4, x_of, y_of, z_of.
  simpl. field.
Qed.

Theorem jc_map_p1_to_100 :
  jc_map jc_p1 = (1, 0, 0).
Proof.
  unfold jc_map.
  rewrite jc_f1_p1, jc_f2_p1, jc_f3_p1.
  reflexivity.
Qed.

Theorem jc_map_p2_to_100 :
  jc_map jc_p2 = (1, 0, 0).
Proof.
  unfold jc_map.
  rewrite jc_f1_p2, jc_f2_p2, jc_f3_p2.
  reflexivity.
Qed.

Theorem jc_map_p3_to_100 :
  jc_map jc_p3 = (1, 0, 0).
Proof.
  unfold jc_map.
  rewrite jc_f1_p3, jc_f2_p3, jc_f3_p3.
  reflexivity.
Qed.

Theorem jc_map_p4_to_100 :
  jc_map jc_p4 = (1, 0, 0).
Proof.
  unfold jc_map.
  rewrite jc_f1_p4, jc_f2_p4, jc_f3_p4.
  reflexivity.
Qed.

(** NTK integration: use the first two map components as a 2D feature map by
    fixing [y,z] and varying [x]. *)
Definition jc_feature (y z : R) (x : R) : vec2 :=
  let u : triple := (x, y, z) in
  (jc_f1 u, jc_f2 u).

Definition jc_ntk (y z : R) : R -> R -> R :=
  kernel_of (jc_feature y z).

Theorem jc_ntk_is_jacobian_contraction :
  forall y z x1 x2,
    jc_ntk y z x1 x2 = dot (jc_feature y z x1) (jc_feature y z x2).
Proof.
  intros y z x1 x2.
  unfold jc_ntk.
  apply kernel_of_is_jacobian_feature_contraction.
Qed.

Theorem jc_ntk_symmetric :
  forall y z x1 x2,
    jc_ntk y z x1 x2 = jc_ntk y z x2 x1.
Proof.
  intros y z x1 x2.
  unfold jc_ntk.
  apply kernel_of_symmetric.
Qed.

Theorem jc_ntk_quadratic_nonnegative :
  forall y z xs cs,
    0 <= kernel_quadratic (jc_feature y z) xs cs.
Proof.
  intros y z xs cs.
  apply kernel_quadratic_nonnegative.
Qed.

Definition jc_jacobian_map (_ : vec2) (x : R) : vec2 :=
  jc_feature 0 0 x.

Definition jc_width_features (y z : R) (_ : nat) : R -> vec2 :=
  jc_feature y z.

Theorem jc_ntk_infinite_width_convergence :
  forall y z,
    pointwise_limit_of_width_kernels (jc_width_features y z) (jc_feature y z).
Proof.
  intros y z.
  apply ntk_infinite_width_convergence_from_eventual_feature_stability.
  intro x.
  exists 0%nat.
  intros n _.
  reflexivity.
Qed.

Theorem jc_ntk_training_time_constancy :
  forall theta_t t1 t2 x1 x2,
    ntk_trajectory jc_jacobian_map theta_t t1 x1 x2 =
    ntk_trajectory jc_jacobian_map theta_t t2 x1 x2.
Proof.
  intros theta_t t1 t2 x1 x2.
  apply ntk_training_time_constancy_from_parameter_independent_jacobian.
  intros theta1 theta2 x.
  reflexivity.
Qed.




