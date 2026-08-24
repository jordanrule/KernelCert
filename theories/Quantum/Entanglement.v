(* theories/Quantum/Entanglement.v *)

(** Lightweight formal primitives for entanglement-side reasoning. *)

From Stdlib Require Import Reals.
From Stdlib Require Import Arith.
From Stdlib Require Import micromega.Lra.

Module Entanglement.

Definition QuantumState := nat -> R.

(* A separable two-register surrogate as pointwise product. *)
Definition separable_pair (psiA psiB : QuantumState) : QuantumState :=
  fun i => (psiA i * psiB i)%R.

(* Interaction strength surrogate used by QNTK scaling arguments. *)
Definition entanglement_correlation_strength (system_size : nat) (pair_corr : R) : R :=
  INR system_size * pair_corr.

Lemma entanglement_strength_nonnegative :
  forall (system_size : nat) (pair_corr : R),
    (0 <= pair_corr)%R ->
    (0 <= entanglement_correlation_strength system_size pair_corr)%R.
Proof.
  intros system_size pair_corr hcorr.
  unfold entanglement_correlation_strength.
  apply Rmult_le_pos; [apply pos_INR | exact hcorr].
Qed.

End Entanglement.



