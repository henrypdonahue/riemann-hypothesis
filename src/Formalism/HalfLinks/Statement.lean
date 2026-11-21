import Formalism.ZetaNonvanishingChebyshevWeights
import Formalism.ProductFormula.StatementOCCM

open Finset ArithmeticFunction

noncomputable section

namespace Formalism.CMTypeGaloisData

def Schi4 (χ : ℕ → ℝ) (y : ℝ) : ℝ := ∑ n ∈ Icc 1 ⌊y⌋₊, Λ n * χ n * (y / n - 1)

def Gch (χ : ℕ → ℝ) (ell y : ℝ) : ℝ := Schi4 χ y + y * ell

end Formalism.CMTypeGaloisData
