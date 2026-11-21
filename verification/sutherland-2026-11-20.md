# Verification files for the Lean proof of the Riemann Hypothesis

Announced at alpo.ge/remark.pdf on 20 November 2026.

Andrew Sutherland (MIT), checks run with Claude Code. Page last updated 2026-11-20 19:45 UTC.
Results below are as of that time and this page will be updated as the remaining checks finish.

> Saved copy of the results page, as of 2026-11-20 19:45 UTC. These results are for the
> unmodified submission (the mirror's `main`), not for any branch that changes `src/`.

## Summary

The published Lean source compiles without errors, the five headline theorems depend only on
the three standard axioms, every module has been replayed through the Lean kernel, and the
independent nanoda kernel accepts the full exported proof. The lake comparator run and the
Lean-kernel replay of the export are still in progress.

| Check | Result | Detail |
|---|---|---|
| All 175,187 modules compile (Lean v4.33.1, Mathlib v4.33.1) | pass | zero errors; finished 16:43:21 UTC |
| `#print axioms` for the five theorems in Main.lean | pass | propext, Classical.choice, Quot.sound only (audit.log) |
| No axioms declared outside Lean core | pass | 15 axioms in the environment, all in Init |
| Mathlib files identical to the official cache | pass | 8,322 Mathlib and 378 dependency .olean files, byte for byte |
| leanchecker kernel replay of every module | pass | 175,187 of 175,187; zero rejections; finished about 18:17 UTC |
| Challenge export equals the one published by Deicyde/riemann-hypothesis CI | match | sha256 bd484ac9…b2b9 |
| nanoda (independent Rust kernel) on the full export | accepts | exit 0 at 19:05:45 UTC; 27 min 42 s on 80 threads (nanoda.log) |
| Lean default kernel and Lean paranoid kernel on the export | running | single-threaded; no verdict yet |
| lake comparator (Lean v4.36.0) end to end | running | statement comparison and axiom check already passed in one run; kernels in progress |
| con-leche, con-ron | declined | exit 2, not a rejection: they do not support the reflexive inductive type `FunctorialResolution.EmbeddedResolution.PrincipalizationCertificate` |
| lean4lean bundled with Lean v4.36.0 | not applicable | cannot read a v4.33 core library (unknown constant `Decidable.intro`) |

## What was verified

The theorem `riemannHypothesis : RiemannHypothesis` in the submission's Main.lean, where
`RiemannHypothesis` is Mathlib's own definition (Mathlib/NumberTheory/LSeries/RiemannZeta.lean):

```lean
def RiemannHypothesis : Prop :=
  ∀ (s : ℂ) (_ : riemannZeta s = 0) (_ : ¬∃ n : ℕ, s = -2 * (n + 1)) (_ : s ≠ 1), s.re = 1 / 2
```

and four further theorems, including the analogous statement for all Dirichlet L-functions.
"GRH" here means Dirichlet L-functions only.

## Downloads

**solution.ndjson.zst** 7.7 GB (7,699,933,588 bytes)
The exported proof: output of lean4export on module Main. Unpacks to 61,570,595,788 bytes.

- compressed sha256 `61a8938ad5f5e57397c1c0e3b954916af546d9004ade01c3555744a681b05381`
- unpacked sha256 `5ea74b912147c5c93cc2b6d70cc727cf908df2f62ac6a20480a3fa02f6be244e`

**challenge.ndjson.zst** 47 MB
The exported challenge: the five statements with sorry proofs, importing only Mathlib.
Unpacks to 350,862,970 bytes.

- unpacked sha256 `bd484ac9886a96f26b1d9a7a59ebd45b7a70d102c015d4f31f9302bbdd6ab2b9`

Smaller files:

- comparator.json: Comparator config naming the checkers that can process this proof
- SHA256SUMS: hashes of everything on this page
- audit.log and Audit.lean: the axiom audit and the file that produced it
- project-oleans.sha256: sha256 of each of the 175,187 compiled files (29 MB)
- nanoda.log: timing and exit status of the nanoda run

## Check it yourself

With Lean v4.36.0 installed, nothing needs to be built. You need roughly 100 GB of RAM and
70 GB of disk.

```bash
zstd -d --long=30 solution.ndjson.zst      # --long=30 is required
zstd -d --long=27 challenge.ndjson.zst
sha256sum solution.ndjson challenge.ndjson  # compare with the hashes above

lake comparator --config comparator.json \
  --challenge-from-export challenge.ndjson --solution-from-export solution.ndjson
```

nanoda alone took about 28 minutes on 80 threads. The Lean kernels are single-threaded and take
much longer.

## Provenance

| Item | Value |
|---|---|
| Source archive | lean.tar.gz, the 14 parts from alpo.ge joined; 239,275,554 bytes; sha256 `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc` |
| Source mirror | Deicyde/riemann-hypothesis, byte-identical to the archive apart from the Comparator files it adds |
| Lean / Mathlib | Lean v4.33.1 (commit 819816b2); Mathlib tag v4.33.1 (0df444a3) |
| Exporter | lean4export tag v4.33.0 (15f6055e), built with Lean v4.33.1; target list as in Deicyde's export-targets.txt |
| Judge and extra kernels | Lean v4.36.0: lake comparator, leanchecker, leanchecker-paranoid, nanoda_bin |
| Main.olean | sha256 `9146dfb4148e24d2252e04c50742f3e49dd126dfcc5006d10bf5f873ddf796ad` |
| Manifest of all compiled files | sha256 `375cbee2fc3fc0f5088ef2e6dc9a5ac5530924310dc62422ec65aac9dc4c1d25` |

## Caveats

- The build ran on cloud machines without a sandbox, and compiled each file by calling lean
  directly with the same inputs lake supplies, not through lake build. A 77-module sample of
  the output is byte-identical to a real lake build; the full set has not been compared
  against one.
- The export therefore has the same unsandboxed provenance. An export from a sandboxed build
  (the Deicyde protocol) should have the same sha256 if exporting is deterministic; that
  comparison has not been made yet.
- A passing check shows that the formal statements, as written in Lean against Mathlib's
  definitions, follow from the three standard axioms according to the kernels used. It relies
  on those kernels and on Mathlib's definitions being what they are intended to be.
- A first build attempt used a wrong module root and was discarded in full; none of it is in
  these results.
