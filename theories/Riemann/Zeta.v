(*
  Zeta Kernel scaffold for the Riemann track.

  This compact Coq development formalizes a countably indexed kernel with
  harmonic decay. The goal here is not to prove the Riemann Hypothesis
  outright, but to provide a clean kernel object that mirrors the kind of
  asymptotic structure used in RH-oriented analytic arguments: a symmetric
  kernel, a decaying feature map, and a finite Gram form that is provably
  nonnegative.
*)

From Stdlib Require Import Reals List Ring.
Import ListNotations.

Local Open Scope R_scope.

Module ZetaKernel.

Definition feature := nat -> R.

(* Harmonic feature map: large indices contribute less. *)
Definition zeta_feature (n : nat) : R := / INR (S n).

Definition kernel_of (phi : feature) (m n : nat) : R :=
  phi m * phi n.

Definition zeta_kernel : nat -> nat -> R := kernel_of zeta_feature.

Theorem zeta_feature_positive :
  forall n, 0 < zeta_feature n.
Proof.
  intros n.
  unfold zeta_feature.
  apply Rinv_0_lt_compat.
  apply lt_0_INR.
  apply Nat.lt_0_succ.
Qed.

Theorem zeta_feature_decay :
  forall n, zeta_feature (S n) <= zeta_feature n.
Proof.
  intros n.
  unfold zeta_feature.
  apply Rinv_le_contravar.
  - apply lt_0_INR.
    apply Nat.lt_0_succ.
  - apply le_INR.
    apply Nat.le_succ_diag_r.
Qed.

Theorem zeta_kernel_symmetric :
  forall m n, zeta_kernel m n = zeta_kernel n m.
Proof.
  intros m n.
  unfold zeta_kernel, kernel_of.
  ring.
Qed.

Fixpoint feature_sum (phi : feature) (xs : list nat) (cs : list R) : R :=
  match xs, cs with
  | x :: xs', c :: cs' => c * phi x + feature_sum phi xs' cs'
  | _, _ => 0
  end.

Fixpoint kernel_row_sum
    (phi : feature) (x : nat) (ys : list nat) (ds : list R) : R :=
  match ys, ds with
  | y :: ys', d :: ds' => d * kernel_of phi x y + kernel_row_sum phi x ys' ds'
  | _, _ => 0
  end.

Fixpoint kernel_cross_quadratic
    (phi : feature) (ys : list nat) (ds : list R)
    (xs : list nat) (cs : list R) : R :=
  match xs, cs with
  | x :: xs', c :: cs' =>
      c * kernel_row_sum phi x ys ds +
      kernel_cross_quadratic phi ys ds xs' cs'
  | _, _ => 0
  end.

Definition kernel_quadratic (phi : feature) (xs : list nat) (cs : list R) : R :=
  kernel_cross_quadratic phi xs cs xs cs.

Theorem kernel_row_sum_as_feature_product :
  forall phi x ys ds,
    kernel_row_sum phi x ys ds = phi x * feature_sum phi ys ds.
Proof.
  intros phi x ys.
  induction ys as [| y ys IH]; intros ds.
  - destruct ds; simpl; ring.
  - destruct ds as [| d ds].
    + simpl. ring.
    + simpl. rewrite IH. unfold kernel_of. ring.
Qed.

Theorem kernel_cross_quadratic_as_product :
  forall (phi : feature) (ys : list nat) (ds : list R)
    (xs : list nat) (cs : list R),
    kernel_cross_quadratic phi ys ds xs cs =
    feature_sum phi xs cs * feature_sum phi ys ds.
Proof.
  intros phi ys ds xs.
  induction xs as [| x xs IH]; intros cs.
  - destruct cs; simpl; ring.
  - destruct cs as [| c cs].
    + simpl. ring.
    + simpl.
      rewrite kernel_row_sum_as_feature_product.
      rewrite IH.
      unfold kernel_of.
      ring.
Qed.

Theorem kernel_quadratic_as_square :
  forall (phi : feature) (xs : list nat) (cs : list R),
    kernel_quadratic phi xs cs =
    feature_sum phi xs cs * feature_sum phi xs cs.
Proof.
  intros phi xs cs.
  unfold kernel_quadratic.
  apply kernel_cross_quadratic_as_product.
Qed.

Theorem kernel_quadratic_nonnegative :
  forall (phi : feature) (xs : list nat) (cs : list R),
    0 <= kernel_quadratic phi xs cs.
Proof.
  intros phi xs cs.
  rewrite kernel_quadratic_as_square.
  apply Rle_0_sqr.
Qed.

Definition zeta_kernel_quadratic (xs : list nat) (cs : list R) : R :=
  kernel_quadratic zeta_feature xs cs.

Theorem zeta_kernel_quadratic_nonnegative :
  forall (xs : list nat) (cs : list R), 0 <= zeta_kernel_quadratic xs cs.
Proof.
  intros xs cs.
  unfold zeta_kernel_quadratic.
  apply kernel_quadratic_nonnegative.
Qed.

End ZetaKernel.
