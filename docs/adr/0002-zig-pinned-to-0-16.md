---
status: superseded by ADR-0005
---

# Zig, pinned to 0.16.0

> **Superseded by [ADR 0005](./0005-ocaml-not-zig.md):** MAXWELL moved to OCaml. This record is kept
> for the reasoning, which ADR 0005 weighs against.

`my_gzip` is written in **Zig 0.16.0**, pinned through Nix (`zig_0_16`, with matching `zls`
0.16.0 — ZLS is version-locked to the compiler and will not work against a mismatched toolchain).

The decisive reason is **`zig cc`**. Zig ships a full C compiler, so zlib can be vendored into
`build.zig` in minutes and used as a differential-testing oracle: fuzz random inputs, compress
with `my_gzip`, decompress with zlib, assert equality — then the reverse. For a codec, "does the
reference implementation agree with me" *is* the definition of correctness, and `zig cc` reduces
that from a project to a build-system detail. Zig's static binaries also give the CD pipeline a
genuinely self-contained release artifact.

## Considered and rejected

**Odin** was the serious alternative and lost narrowly. In its favour: monthly, boring releases
with nothing that can move before January; everything vendored in-tree; and a multi-threaded test
runner with automatic leak detection and stack traces, which is worth real marks in a module that
grades testing policy explicitly. Against it: no `zig cc` equivalent, so benchmarking and
differential-testing against zlib means linking it by hand. Note that Odin's `core:simd/arm`
package currently contains no arithmetic, comparison or load/store intrinsics — that was
disqualifying for an earlier, NNUE-based project idea, but matters little here, since a
compressor's portable `#simd` needs are modest.

**Rust** was excluded by preference, not collision: the module grades the justification of
technical choices, and "I picked the language I already use daily" is a weaker answer than "I
picked a systems language I had to learn". **Haskell** was excluded because GLaDOS already used
it, and because macOS on Apple Silicon is its officially weakest tier — GHCup's own matrix flags
HLS bindists as experimental and Stack as unofficial-binaries-only.

## The 0.16 → 0.17 question

Zig 0.17.0 is roughly four months overdue (announced as "a couple of weeks away" on 2026-05-26;
master still reads `0.17.0-dev` as of 2026-09-21, with four open blockers) and may land inside
the project window or well after it. **This is deliberately not a risk we mitigate by choosing
differently.** Zig has no forced upgrades: the toolchain is pinned, and a 0.17 release becomes a
backlog issue — "evaluate 0.17 portage" — triaged like any other.

Pinning covers libraries too. Their development branches follow Zig master — zig-clap's master
already requires `0.17.0-dev` — while their tagged releases still target 0.16, so every dependency
is pinned to a tag. The portage will not be free: 0.17's churn is concentrated in `std.Io` and the
build system, and `build.zig` is the first thing this project writes. It is bounded, though, and a
dependency upgrade carried out from its release notes, through an issue and a pull request, is
ordinary professional work worth showing at a defence.

Starting directly on a `0.17.0-dev` nightly was considered and rejected. It moves the upgrade
rather than avoiding it — a pinned nightly still has to be bumped to 0.17.0 when that ships, with no
release notes describing that particular jump — and it would mean writing the build system against
exactly the part of Zig that master is reworking.

## Reconsidered after ADR 0003

When the project became a tool for web developers ([ADR 0003](./0003-a-tool-for-web-developers.md)),
the question changed from "which language makes the best codec" to "which language best serves web
developers using a tool whose engine is a codec", and the choice was reopened across Zig, Odin,
Lean 4, OCaml and Haskell. **Zig was kept**, for reasons that now go beyond `zig cc`:

- **It expresses the bit-level layout directly.** A packed struct *is* the DEFLATE block header
  (`packed struct(u3)`), `comptime` bakes the fixed Huffman tables into the binary, and `@Vector`
  gives SIMD without intrinsics. That is exactly where a decoder's difficulty lives.
- **It ships to users from one machine.** Zig cross-compiles every release target from macOS,
  including static Linux binaries through musl.
- **Its C interop covers what its ecosystem lacks.** CLI polish — completions, man pages, rich
  diagnostics — is mostly hand-built in Zig, and building it is visible user-facing work; where a C
  library does the job better, Zig can use it directly. Since 0.16, C headers are translated
  through `b.addTranslateC()` in `build.zig`, and `@cImport` is deprecated.

**OCaml** was the serious alternative: cmdliner generates the man page and shell completions from a
single CLI definition, `grace` renders diagnostics, and `mirage/decompress` is an in-language
reference codec. It lost because its main draws — errors as values, exhaustive pattern matching —
exist in Zig as well, and because the polish cmdliner provides is reproducible by hand. **Odin** is
as good for the codec (`bit_field`) but cannot link when cross-compiling, so every release needs a
build per OS. **Lean 4** has a formally verified reference codec in `lean-zip`, but no completion
or man-page generation, no cross-compilation and no working wasm path. **Haskell** was already used
for GLaDOS, and its diagnostics libraries are stuck on old version bounds. **Bend2** has no test
framework, which Part 0 of the subject requires at every defence.
