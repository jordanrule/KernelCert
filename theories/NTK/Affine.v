From Stdlib Require Import Reals List Psatz Ring.
Import ListNotations.

From KernelCert.NTK Require Import Core.

Local Open Scope R_scope.

(** A scalar affine model [f_(w,b)(x) = w x + b].
    Its parameter-Jacobian feature is [(x, 1)], so the corresponding NTK is
    the inner product [(x, 1) · (y, 1) = xy + 1]. *)

Definition params := vec2.

Definition affine_model (theta : params) (x : R) : R :=
  fst theta * x + snd theta.

Definition affine_jacobian_feature (x : R) : vec2 :=
  (x, 1).

Definition affine_ntk : R -> R -> R :=
  kernel_of affine_jacobian_feature.

Fixpoint weighted_input_sum (xs cs : list R) : R :=
  match xs, cs with
  | x :: xs', c :: cs' => c * x + weighted_input_sum xs' cs'
  | _, _ => 0
  end.

Fixpoint coeff_sum (xs cs : list R) : R :=
  match xs, cs with
  | _ :: xs', c :: cs' => c + coeff_sum xs' cs'
  | _, _ => 0
  end.

Theorem affine_model_as_feature_dot :
  forall theta x,
    affine_model theta x = dot theta (affine_jacobian_feature x).
Proof.
  intros [w b] x.
  unfold affine_model, dot, affine_jacobian_feature. simpl. ring.
Qed.

Theorem affine_ntk_is_jacobian_contraction :
  forall x y,
    affine_ntk x y = dot (affine_jacobian_feature x) (affine_jacobian_feature y).
Proof.
  intros x y.
  unfold affine_ntk.
  apply kernel_of_is_jacobian_feature_contraction.
Qed.

Theorem affine_ntk_closed_form :
  forall x y,
    affine_ntk x y = x * y + 1.
Proof.
  intros x y.
  unfold affine_ntk, kernel_of, dot, affine_jacobian_feature. simpl. ring.
Qed.

Theorem affine_ntk_symmetric :
  forall x y,
    affine_ntk x y = affine_ntk y x.
Proof.
  apply kernel_of_symmetric.
Qed.

Lemma fst_feature_sum_affine :
  forall xs cs,
    fst (feature_sum affine_jacobian_feature xs cs) = weighted_input_sum xs cs.
Proof.
  induction xs as [| x xs IH]; intros cs.
  - destruct cs; simpl; reflexivity.
  - destruct cs as [| c cs].
    + simpl. reflexivity.
    + simpl. rewrite IH. ring.
Qed.

Theorem snd_feature_sum_affine_closed_form :
  forall xs cs,
    snd (feature_sum affine_jacobian_feature xs cs) = coeff_sum xs cs.
Proof.
  induction xs as [| x xs IH]; intros cs.
  - destruct cs; simpl; reflexivity.
  - destruct cs as [| c cs].
    + simpl. reflexivity.
    + simpl. rewrite IH. ring.
Qed.

Theorem affine_kernel_quadratic_closed_form :
  forall xs cs,
    kernel_quadratic affine_jacobian_feature xs cs =
    (weighted_input_sum xs cs) ^ 2 + (coeff_sum xs cs) ^ 2.
Proof.
  intros xs cs.
  rewrite kernel_quadratic_as_dot.
  unfold dot.
  rewrite fst_feature_sum_affine, snd_feature_sum_affine_closed_form.
  ring.
Qed.

Theorem affine_kernel_quadratic_nonnegative :
  forall xs cs,
    0 <= kernel_quadratic affine_jacobian_feature xs cs.
Proof.
  intros xs cs.
  rewrite affine_kernel_quadratic_closed_form.
  nra.
Qed.




