From Stdlib Require Import Reals List Psatz Ring.
Import ListNotations.

Local Open Scope R_scope.

(** A tiny finite-dimensional kernel model suitable for a demonstrative
    Neural Tangent Kernel proof. We model the NTK as a Jacobian-feature inner
    product via explicit Jacobian contraction. *)

Definition vec2 := (R * R)%type.

Definition vzero : vec2 := (0, 0).

Definition vadd (u v : vec2) : vec2 :=
  (fst u + fst v, snd u + snd v).

Definition smul (a : R) (u : vec2) : vec2 :=
  (a * fst u, a * snd u).

Definition dot (u v : vec2) : R :=
  fst u * fst v + snd u * snd v.

Definition kernel_of (phi : R -> vec2) (x y : R) : R :=
  dot (phi x) (phi y).

Theorem kernel_of_is_jacobian_feature_contraction :
  forall phi x y,
    kernel_of phi x y = dot (phi x) (phi y).
Proof.
  intros phi x y.
  unfold kernel_of.
  reflexivity.
Qed.

Fixpoint feature_sum (phi : R -> vec2) (xs cs : list R) : vec2 :=
  match xs, cs with
  | x :: xs', c :: cs' => vadd (smul c (phi x)) (feature_sum phi xs' cs')
  | _, _ => vzero
  end.

Fixpoint kernel_row_sum
    (phi : R -> vec2) (x : R) (ys ds : list R) : R :=
  match ys, ds with
  | y :: ys', d :: ds' => d * kernel_of phi x y + kernel_row_sum phi x ys' ds'
  | _, _ => 0
  end.

Fixpoint kernel_cross_quadratic
    (phi : R -> vec2) (ys ds xs cs : list R) : R :=
  match xs, cs with
  | x :: xs', c :: cs' =>
      c * kernel_row_sum phi x ys ds +
      kernel_cross_quadratic phi ys ds xs' cs'
  | _, _ => 0
  end.

Definition kernel_quadratic (phi : R -> vec2) (xs cs : list R) : R :=
  kernel_cross_quadratic phi xs cs xs cs.

Lemma dot_comm : forall u v, dot u v = dot v u.
Proof.
  intros [ux uy] [vx vy].
  unfold dot. simpl. ring.
Qed.

Lemma dot_vzero_l : forall u, dot vzero u = 0.
Proof.
  intros [ux uy].
  unfold dot, vzero. simpl. ring.
Qed.

Lemma dot_vzero_r : forall u, dot u vzero = 0.
Proof.
  intros [ux uy].
  unfold dot, vzero. simpl. ring.
Qed.

Lemma dot_vadd_l : forall u v w, dot (vadd u v) w = dot u w + dot v w.
Proof.
  intros [ux uy] [vx vy] [wx wy].
  unfold dot, vadd. simpl. ring.
Qed.

Lemma dot_vadd_r : forall u v w, dot u (vadd v w) = dot u v + dot u w.
Proof.
  intros [ux uy] [vx vy] [wx wy].
  unfold dot, vadd. simpl. ring.
Qed.

Lemma dot_smul_l : forall a u v, dot (smul a u) v = a * dot u v.
Proof.
  intros a [ux uy] [vx vy].
  unfold dot, smul. simpl. ring.
Qed.

Lemma dot_smul_r : forall a u v, dot u (smul a v) = a * dot u v.
Proof.
  intros a [ux uy] [vx vy].
  unfold dot, smul. simpl. ring.
Qed.

Lemma dot_self_nonnegative : forall u, 0 <= dot u u.
Proof.
  intros [ux uy].
  unfold dot. simpl. nra.
Qed.

Theorem kernel_of_symmetric :
  forall phi x y,
    kernel_of phi x y = kernel_of phi y x.
Proof.
  intros phi x y.
  unfold kernel_of.
  apply dot_comm.
Qed.

Theorem kernel_row_sum_as_dot :
  forall phi x ys ds,
    kernel_row_sum phi x ys ds =
    dot (phi x) (feature_sum phi ys ds).
Proof.
  intros phi x ys.
  induction ys as [| y ys IH]; intros ds.
  - destruct ds; simpl; rewrite dot_vzero_r; ring.
  - destruct ds as [| d ds].
    + simpl. rewrite dot_vzero_r. ring.
    + simpl. rewrite IH. unfold kernel_of.
      rewrite dot_vadd_r, dot_smul_r. ring.
Qed.

Theorem kernel_cross_quadratic_as_dot :
  forall phi ys ds xs cs,
    kernel_cross_quadratic phi ys ds xs cs =
    dot (feature_sum phi xs cs) (feature_sum phi ys ds).
Proof.
  intros phi ys ds xs.
  induction xs as [| x xs IH]; intros cs.
  - destruct cs; simpl; rewrite dot_vzero_l; ring.
  - destruct cs as [| c cs].
    + simpl. rewrite dot_vzero_l. ring.
    + simpl. rewrite IH, kernel_row_sum_as_dot.
      rewrite dot_vadd_l, dot_smul_l. ring.
Qed.

Theorem kernel_quadratic_as_dot :
  forall phi xs cs,
    kernel_quadratic phi xs cs =
    dot (feature_sum phi xs cs) (feature_sum phi xs cs).
Proof.
  intros phi xs cs.
  unfold kernel_quadratic.
  apply kernel_cross_quadratic_as_dot.
Qed.

Theorem kernel_quadratic_nonnegative :
  forall phi xs cs,
    0 <= kernel_quadratic phi xs cs.
Proof.
  intros phi xs cs.
  rewrite kernel_quadratic_as_dot.
  apply dot_self_nonnegative.
Qed.


