# OCaml, not Zig

MAXWELL is written in **OCaml 5.5**. The author starts an internship in OCaml later this year, and a
sizeable project in the language is worth more to that than one in Zig. This supersedes
[ADR 0002](./0002-zig-pinned-to-0-16.md), which chose Zig while MAXWELL was a pure codec and kept it
once MAXWELL became a tool for web developers.

The switch also suits the half of the project that [ADR 0003](./0003-a-tool-for-web-developers.md)
put at the centre. cmdliner generates `--help`, the man page and shell completions from one CLI
definition — the single source [ADR 0004](./0004-documentation-leads-implementation.md) generates
the reference from — and grace renders labelled diagnostics.

## What changes

- **The oracle gets stronger.** `decompress` is a complete, independent DEFLATE, zlib and gzip
  implementation in pure OCaml, usable in both directions for differential testing, alongside zlib
  and the system `gzip`.
- **Compressing on the user's behalf needs real zlib.** To reproduce what a zlib-based server such
  as nginx sends, MAXWELL must call zlib itself, through camlzip; any other implementation,
  `decompress` included, emits different bytes. nginx compresses at level 1 by default
  ([`gzip_comp_level`](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_comp_level)),
  which gives the estimated-savings line something real to report before MAXWELL has an encoder of
  its own.
- **Two shells are hand-written.** cmdliner generates completions for bash, zsh and PowerShell, but
  not for fish or nushell. Those two are written by hand, so ADR 0004's documentation check has to
  cover them another way — for instance, by testing that they list every flag.
- **Exit codes are remapped.** cmdliner exits with 123, 124 or 125 by default; the subject requires
  84 on any error.
- **SIMD is gone.** Stock OCaml has no vector types. Throughput work becomes profiling, controlling
  allocation, and compressing independent chunks in parallel across OCaml 5 domains.
- **Releases come from a CI matrix.** OCaml does not cross-compile from macOS the way Zig does, so
  static Linux (through musl), macOS and Windows binaries are each built on their own runner. OCaml
  5.5 builds natively on Windows with MinGW-w64 or MSVC, and `setup-ocaml` supports Windows runners,
  so Windows stays in scope.
- **The toolchain comes from Nix, the libraries from opam.** nixpkgs lags upstream on three of the
  four libraries (camlzip 1.11 against 1.14, decompress 1.5.3 against 1.6.0, grace 0.3.0 against
  0.4.1), and the Windows runner builds through opam whatever is chosen. So Nix pins the compiler,
  dune, the language server and opam itself, while one opam lock file pins every library —
  identically on macOS, Linux and Windows. Taking the libraries from nixpkgs as well was rejected:
  Windows would still resolve them through opam, leaving two sources of truth that could disagree.

## What was given up

Zig's bit-level types — a packed struct *is* a DEFLATE block header — its `@Vector` SIMD, and
cross-compiling every release from one machine. Those were the reasons ADR 0002 kept Zig. They are
real; they lost to a better one.
