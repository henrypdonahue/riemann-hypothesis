import Formalism.JacobiWeightFamilies.Statement

open Finset ArithmeticFunction

noncomputable section

namespace Formalism.WeightedSieveThreeParameter

def Par3 (C0 x z D : ℝ) : Prop :=
  0 < D ∧ x ^ 3 ≤ z ∧ C0 * Real.log z * Real.log x ≤ Real.log D ∧ Real.log D ≤ x ^ ((1 : ℝ) / 10)

def gavg {n : ℕ} (w y : Fin n → ℝ) (f : ℝ → ℝ) : ℝ := ∑ j, w j * f (y j)

def AvgCondition {n : ℕ} (w y : Fin n → ℝ) (z : ℝ) : Prop :=
  (∀ j, 0 ≤ w j) ∧ (∑ j, w j) ≤ 1 ∧ ∀ j, 1 ≤ y j ∧ y j ≤ z

end Formalism.WeightedSieveThreeParameter
