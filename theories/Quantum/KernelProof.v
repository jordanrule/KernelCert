(* theories/Quantum/KernelProof.v *)

(** Minimal, assumption-explicit QNTK scaffold aligned with common literature structure:
    (i) ideal kernel model, (ii) noise-perturbed estimate, (iii) size scaling,
    and (iv) compositional gains from superposition/entanglement effects. *)

From Stdlib Require Import Reals.
From Stdlib Require Import Arith.
From Stdlib Require Import micromega.Lra.

Module QuantumNeuralTangentKernel.

Local Open Scope R_scope.

(* Noise-aware estimate: multiplicative first-order attenuation model. *)
Definition fault_tolerant_qntk_estimate (ideal_kernel error_rate : R) : R :=
  ideal_kernel * (1 - error_rate).

Lemma fault_tolerance_bound :
  forall (ideal_kernel error_rate : R),
    0 <= ideal_kernel ->
    0 <= error_rate <= 1 ->
    0 <= fault_tolerant_qntk_estimate ideal_kernel error_rate <= ideal_kernel.
Proof.
  intros ideal_kernel error_rate hideal [hnoise0 hnoise1].
  unfold fault_tolerant_qntk_estimate.
  split.
  - apply Rmult_le_pos; lra.
  - eapply Rle_trans with (r2 := ideal_kernel * 1).
    + apply Rmult_le_compat_l; lra.
    + right. ring.
Qed.

(* Linear-in-system-size surrogate used in many QNTK scaling discussions. *)
Definition scalable_qntk_estimate (system_size : nat) (per_qubit_kernel : R) : R :=
  INR system_size * per_qubit_kernel.

Lemma scalability_is_nonnegative :
  forall (system_size : nat) (per_qubit_kernel : R),
    0 <= per_qubit_kernel ->
    0 <= scalable_qntk_estimate system_size per_qubit_kernel.
Proof.
  intros system_size per_qubit_kernel hbase.
  unfold scalable_qntk_estimate.
  apply Rmult_le_pos; [apply pos_INR | exact hbase].
Qed.

Lemma scalability_grows_linearly :
  forall (n m : nat) (per_qubit_kernel : R),
    (n <= m)%nat ->
    0 <= per_qubit_kernel ->
    scalable_qntk_estimate n per_qubit_kernel <=
    scalable_qntk_estimate m per_qubit_kernel.
Proof.
  intros n m per_qubit_kernel hnm hbase.
  unfold scalable_qntk_estimate.
  apply Rmult_le_compat_r.
  - exact hbase.
  - apply le_INR. exact hnm.
Qed.

Lemma scalability_increment :
  forall (n : nat) (per_qubit_kernel : R),
    scalable_qntk_estimate (S n) per_qubit_kernel =
    scalable_qntk_estimate n per_qubit_kernel + per_qubit_kernel.
Proof.
  intros n per_qubit_kernel.
  unfold scalable_qntk_estimate.
  rewrite S_INR.
  lra.
Qed.

(* Aggregate error envelope under independent per-component error surrogates. *)
Definition aggregate_error_bound (system_size : nat) (error_rate : R) : R :=
  INR system_size * error_rate.

Lemma error_accumulation_bound_nonnegative :
  forall (system_size : nat) (error_rate : R),
    0 <= error_rate ->
    0 <= aggregate_error_bound system_size error_rate.
Proof.
  intros system_size error_rate herr.
  unfold aggregate_error_bound.
  apply Rmult_le_pos; [apply pos_INR | exact herr].
Qed.

(* Compositional gains are explicit, assumption-driven inputs. *)

Definition effective_qntk_estimate
  (system_size : nat)
  (base_kernel superposition_gain entanglement_gain error_rate : R) : R :=
  fault_tolerant_qntk_estimate
    (scalable_qntk_estimate system_size
      (base_kernel + superposition_gain + entanglement_gain))
    error_rate.

Lemma effective_qntk_nonnegative :
  forall
    (system_size : nat)
    (base_kernel superposition_gain entanglement_gain error_rate : R),
    0 <= base_kernel ->
    0 <= superposition_gain ->
    0 <= entanglement_gain ->
    0 <= error_rate <= 1 ->
    0 <= effective_qntk_estimate
      system_size base_kernel superposition_gain entanglement_gain error_rate.
Proof.
  intros system_size base_kernel superposition_gain entanglement_gain error_rate.
  intros hbase hsup hent hnoise.
  unfold effective_qntk_estimate.
  pose proof (fault_tolerance_bound
    (scalable_qntk_estimate system_size
      (base_kernel + superposition_gain + entanglement_gain))
    error_rate) as hbound.
  assert (0 <= scalable_qntk_estimate system_size
      (base_kernel + superposition_gain + entanglement_gain)) as hscaled.
  { apply scalability_is_nonnegative. lra. }
  specialize (hbound hscaled hnoise).
  exact (proj1 hbound).
Qed.

End QuantumNeuralTangentKernel.
