# Off-catalogue project: a performance engine scored against published external yardsticks

The B-PRO-500 catalogue offers six projects, all clones of existing end-user applications
(Kodi, Trello, AirConsole, GIMP, Flipboard, a Covid dashboard). The local pedagogical team has
already granted permission to build something off-catalogue instead. The catalogue's real
function is *spec removal*: the reference application is the yardstick the jury measures against.
An invented project must replace that yardstick or it becomes unreviewable.

**Decision:** build a project whose correctness and progress are measured against a *published
external specification with public, machine-checkable test data*. The fortnightly defence then
has an unarguable progress metric that is not the author's own opinion — a count of conformance
cases passing, not a claim about effort spent.

**The project is `my_gzip`**: a gzip-compatible compression tool — a DEFLATE decoder first, then
an encoder, then sustained work on compression ratio and throughput. It is scoped as the Unix
*utility*, not merely a codec library, so it is checked on two levels at once: streams it emits
must be decodable by the reference tool, and streams the reference tool emits must be decodable
by it. The yardstick is therefore free and unarguable, because `gzip` is already installed on
every machine a jury owns.

It also carries two independent axes of improvement — **compression ratio** and **throughput** —
so a fortnight that fails to move one can still move the other. That matters for a module graded
on steady pace rather than completion.

*Territory confirmed clear.* A sweep of 82 Epitech subject PDFs plus the author's actual repo
record found no coverage of Huffman, LZ77/LZ78, DEFLATE, entropy or arithmetic coding anywhere in
the first three years. `ImageCompressor` is K-means colour clustering over a text file of
`(x,y) (r,g,b)` lines — it never touches an image format, never produces a smaller file, and
contains no entropy coder. The two adjacent projects that do exist, `Antman` (Tek1, lossless
compression with no prescribed algorithm) and `R-Type`'s optional payload-compression track, were
both not taken.

*Framing constraint.* "Byte-compatible reimplementation of a Unix tool" is the most heavily worn
genre at this school — `my_printf`, `my_ls`, `my_top`, `my_sudo`, Minishell, 42sh, `my_nm`,
`strace`, MiniLibC — and the author has done most of them. The pitch therefore leads with the
algorithmic substance, not the imitation: the goal is to emit gzip-readable files *smaller than
gzip can make them*, which is not something any of those projects did.

*Fallback territory.* B-PSU-400 (`malloc`, `my_nm`/`my_objdump`, `strace`, `ftrace`) is the one
unit with no repos in the author's record — all four are individual projects, so the absence is
conclusive. ELF parsing, ptrace, x86-64 instruction decoding and custom allocators are unburnt,
and that is where to look if this project has to be replaced.

## Constraints that shaped this

- **Solo**, ~2 working days/week, ~30 usable person-days across 9 fortnightly defences
  (25/09/2026 → 17/01/2027, straddling Christmas).
- **No screen required.** The jury is technical; terminal output, a clear API/ABI, spec sheets
  and documentation satisfy them. It must compress to 2–3 slides.
- **Not required to be finishable** — the bar is steady, demonstrable pace, not completion.
  Milestones are therefore sequential and each is finished before the next begins.
- **Language is a free variable** (the subject grants technology choice unconditionally), with a
  stated preference for Odin or Zig.
- **SIMD and GPU are nice-to-have, not requirements.** GPU on this machine means Metal; CUDA is
  impossible (NVIDIA's last macOS toolkit was CUDA 10.2, and Apple's own docs require an Intel
  Mac for eGPU).

## Excluded territory

Work already delivered, and therefore not available:

- **GLaDOS** (Epitech, Haskell): own language design, lexer, parser, AST, compiler, bytecode
  format, and a virtual machine with its own instruction set. Bonus tracks (native codegen,
  LLVM, type inference) were *not* reached. Burns: interpreters, WASM runtimes, regex engines,
  emulators with instruction sets.
- **my_torch** (Epitech): neural networks implemented from scratch — generation, save/load,
  training, backpropagation, gradient descent, overfitting mitigation, hyperparameter
  optimisation — applied to chessboard evaluation from FEN notation. Burns: all machine
  learning, *and* chess.
- **A-maze-d** (Epitech, C): pathfinding and graph theory, multi-agent maze routing.
**Not excluded:** TermOxide, the signal-based declarative TUI framework in Rust that was the
two-year project of the previous year, does not constrain this work — TUI, terminal rendering and
reactive architectures remain available. Toolchain-*adjacent* work (linkers, debuggers,
profilers) is likewise not excluded by GLaDOS. Rust is avoided by preference, not collision: the
stated appeal of Odin and Zig is that they are unfamiliar, and this module grades the
justification of technical choices.

## Considered and rejected

Recorded because approval is not yet confirmed — if the pedagogical team rejects the selected
project, these are the fallbacks and the reasons they lost.

- **A chess engine** scored by published `perft` node counts and SPRT-measured Elo. Pursued at
  length before being withdrawn: `my_torch` already delivered a neural network evaluating chess
  positions from FEN, which is precisely the NNUE evaluation that would have been this project's
  centrepiece. The domain and the technique are both spent. Worth recording that the *yardstick*
  was excellent — exact published integers, `fastchess --compliance` for UCI, SPRT against
  rated opponents — and that this is the standard the replacement must meet.

- **Conformance-driven protocol implementation** (HTTP/2 server scored by `h2spec`, DNS
  resolver, MQTT broker, 9P server, BitTorrent client). Excellent yardstick — `h2spec` alone is
  ~146 scored cases. Rejected because the author has no interest in networking, and because a
  networking-heavy project in Zig walks directly into the one dated risk identified: Zig 0.17 is
  ~4 months overdue and its churn is concentrated in `std.Io` and the build system.

- **Systems tool filling a real gap** (a debugger or profiler for Odin/Zig binaries: DWARF
  parsing plus ptrace/mach). Rejected as too risky: on Apple Silicon it demands codesigning
  entitlements and mach-port work before the first useful feature exists, which is a poor shape
  for a cadence that must show progress from D02 onward.

- **Format and storage implementation** (SQLite file-format reader with a B-tree engine, a Git
  implementation, a FUSE filesystem). Rejected as uncomfortably close to GLaDOS: binary format
  parsing and tree-walking are the parts of that project already delivered.

- **Seeding the two-year project.** Moot: the EIP already exists and is TermOxide.
