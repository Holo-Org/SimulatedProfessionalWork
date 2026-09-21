# Zig, pinned to 0.16.0

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
backlog issue — "evaluate 0.17 portage" — triaged like any other. 0.17's known churn is
concentrated in `std.Io` and the build system, and a compression tool touches little beyond files
and memory, so the blast radius is small. Contrast an earlier candidate project built on
networking, where the same churn would have been unavoidable.
