# Compiled with OxCaml, evaluated on Linux x86-64

MAXWELL is compiled with **OxCaml**, Jane Street's branch of OCaml. The author's internship will use
it, and [ADR 0005](./0005-ocaml-not-zig.md) chose OCaml for that internship in the first place, so
this takes the same reasoning one step further. OxCaml's extensions — static freedom from data
races, control over memory layout and allocation, SIMD — are aimed at exactly the kind of hot loops
a compressor has, and learning them there is the point.

Every valid OCaml program is a valid OxCaml program, and the extensions carry no promise of
stability. So MAXWELL is plain OCaml by default, and reaches for an extension only where it pays.
That keeps the decision reversible: everything outside those places still builds with the stock
compiler.

## What it changes in ADR 0005

- **Linux x86-64 is the platform that counts.** Epitech evaluates nothing else. macOS on arm64 is
  where MAXWELL is developed. Native Windows is dropped — OxCaml does not support it, and it had
  only been added because it was possible and convenient — and so are static Linux binaries, since
  OxCaml needs glibc rather than musl.
- **Nix is the root, and every version is pinned.** OxCaml publishes its own flake, which builds the
  compiler along with merlin and ppxlib, and its own opam repository, which releases a compiler
  based on OCaml 5.4 (`5.4.0+ox`). Either route satisfies the rule, and sprint 2 picks one inside
  its timebox. Libraries are pinned as well, identically on every machine.
- **Unless a binary cache covers the pinned revision, the compiler builds from source.** The first
  CI run is long, so the toolchain is cached from sprint 2 onward.
- **SIMD comes back.** On x86-64 it has existed since mid-2023, starting with 128-bit vector types
  and SSE instruction selection; AVX-512 followed in mid-2026. On arm64, SIMD intrinsics were
  implemented and their tests enabled in June 2025, and Jane Street's released SIMD library is
  marked available there. OxCaml's installation page still says ARM is unsupported — on the same
  page that still installs the older 5.2-based compiler — so it is to be confirmed on the
  development machine.
- **Completions drop to four shells**: bash, zsh, fish and nushell. PowerShell was only there for
  Windows.

Everything else in ADR 0005 stands: the oracles, camlzip for reproducing what a server sends,
cmdliner and the exit codes it needs remapped, grace.
