# Roadmap

Delivery plan for MAXWELL. The subject in [`docs/subject/maxwell.html`](./subject/maxwell.html)
describes *what* is built and is deliberately undated; this file says *when*, and is the only place
dates belong.

MAXWELL is a tool for web developers: it reports the exact gzip cost of every source in their
bundle, then makes that bundle smaller while every existing decoder can still read it
([ADR 0003](./adr/0003-a-tool-for-web-developers.md)). It is written in OCaml
([ADR 0005](./adr/0005-ocaml-not-zig.md)), compiled with OxCaml and evaluated on Linux x86-64
([ADR 0006](./adr/0006-oxcaml-on-linux.md)), and its documentation leads its implementation
([ADR 0004](./adr/0004-documentation-leads-implementation.md)).

Project window: **14/09/2026 → 31/01/2027**. Ten fortnightly sprints, each ending with its defence
on the Friday of its second week. Working days are **Thursdays and Fridays**, so a sprint holds four
working days, one of which is its own defence — about three and a half days of building. Until D07,
a third day each week, taken from the weekend, brings that to about five and a half.

## Re-baseline of 06/11/2026

The project was delayed by health conditions: sprints 2, 3 and 4 did not run, and only the toolchain
environment was built. A slip is recorded, not absorbed, so everything below this section has been
replanned, and this is what changed.

- **One more sprint.** Sprint 10 and its defence, D10, extend the window by a fortnight.
- **The MVP keeps its full scope and moves from D05 to D07**, the last defence before Christmas.
- **Three working days a week until D07, then two**, with about three days in all over the Christmas
  fortnight. That gives 16.5 days before Christmas, where the old plan gave the same work 14. Those
  14 were a budget, never a measurement, so the margin is thin.
- **Read I and Read II become one sprint**, and bit accounting and cost per line move into the MVP
  sprint, so that the whole of attribution sits together.
- **After the MVP, ease of use comes first and the encoder last.** The encoder is the largest piece
  and the furthest from the project's user-facing centre, so it is the first to give way.
- **`my_gzig` is dropped.** It was a remnant of the first language choice, Zig.

## Scope commitment

Split three ways, because the module grades steady pace rather than completion, and because a
roadmap that promises everything is worth the same as one that promises nothing.

- **MVP — guaranteed, at D07.** MAXWELL inflates a real gzip-compressed bundle, attributes every
  compressed bit to the byte it produced and, through the source map, to the source that byte came
  from, and reports the exact gzip cost of each source in the terminal. Corrupted input fails with
  an error that says where and why.
- **Committed beyond the MVP.** The HTML report with its heat map; the remaining ease-of-use
  features — colour that respects `NO_COLOR`, output that never relies on colour alone,
  configuration from a file and the environment, completions for four shells, compressing the
  bundle with zlib at the server's level, and an estimated-savings line — and MAXWELL's own encoder,
  the first thing to give way if the pace does not hold.
- **Follow-up, not promised**, in order: CI cost budgets, lazy matching and level tuning, SIMD
  in the match finder, optimal parsing, parallel compression, and — last of all — Zstandard.

## Sprints

| Sprint | Window | Defence | Chapter | Work | What is demonstrated |
|---|---|---|---|---|---|
| 1 | 14/09 – 27/09 | **D01** 25/09 | Pitch | Subject, roadmap, risk register | The project is defined and validated |
| 2–4 | 28/09 – 08/11 | **D02** 09/10, **D03** 23/10, **D04** 06/11 | Not run | Delayed by health conditions; the toolchain environment only | The re-baseline above |
| 5 | 09/11 – 22/11 | **D05** 20/11 | Walking skeleton | Nix-rooted OxCaml toolchain with pinned libraries, dune, Makefile; CI on Linux x86-64 and macOS (build, test, format, coverage), with the toolchain cached; CD on tag; the documentation site; both documentation checks; the oracle rig | A trivial `maxwell` that builds, tests, documents and releases itself on Linux x86-64, from a fresh clone |
| 6 | 23/11 – 06/12 | **D06** 04/12 | Read | gzip container, stored, fixed and dynamic-Huffman blocks, least-significant-bit-first bit reader, the 32 KB window, located errors | All of Canterbury inflates exactly as the oracles do; a corrupted file fails with an error that says where and why |
| 7 | 07/12 – 20/12 | **D07** 18/12 | **MVP — Attribute** | Bit accounting, cost per line, source maps (ECMA-426), cost per source with raw size, the first tutorial | The exact gzip cost of every source in a real bundle |
| 8 | 21/12 – 03/01 | **D08** unscheduled ⚠️ | Ease of use II | Configuration file and environment; completions for four shells; compression with zlib at the server's level; estimated savings | Small, independent features, each shipped with its documentation |
| 9 | 04/01 – 17/01 | **D09** 15/01 | Show | HTML report with heat map; colour, `NO_COLOR`, accessible output | The report, open in a browser |
| 10 | 18/01 – 31/01 | **D10** ~29/01 ⚠️ | Shrink and delivery | MAXWELL's encoder: stored, fixed and dynamic-Huffman output, hash-chain LZ77, effort levels; whatever slipped, packaging, final documentation | Output that real `gzip` decompresses; everything, from a fresh clone |

⚠️ **D08 is not yet scheduled.** The official defence calendar leaves it open: the fortnightly
rhythm would put it on 01/01, which is New Year's Day, and its real date will be set after the
holidays.

⚠️ **D10's date is not confirmed.** The fortnightly rhythm puts it on 29/01, and the end of the
project window follows from it.

**Attribution climbs one rung at a time.** Cost per line needs no source map, so inside sprint 7 it
comes before cost per source: bits, then bytes, then lines, then sources, each rung a result in its
own right.

**Christmas carries small, independent work.** Sprint 8's four features are each a documentation
issue and an implementation issue measured in hours, so they survive scattered holiday time, and
nothing later depends on them.

**The buffer sprint is gone.** The delay used it up, so sprint 10 carries a risky feature as well as
delivery. That is a deliberate trade: the encoder comes last so that it can give way, dropped from
its last steps backwards. Work that slips from an earlier sprint lands here and pushes it out;
delivery stands whatever happens to the encoder.

## The walking skeleton is the heaviest sprint, and how it is managed

It builds the whole machine around a program that does nothing yet, with every tool new at once —
the OxCaml toolchain, which builds from source, its package tooling, coverage, CI, the
documentation site and its checks — in about five and a half days. Three measures keep it inside its defence:

- **A floor that must hold at D05.** From a fresh clone, `make` builds `maxwell` and the tests run;
  CI is green on Linux x86-64; coverage is reported; a tag produces a Linux x86-64 release
  binary; and the mechanical documentation check guards `--help` and the man page. That floor is what Part 0 of the
  subject grades at every defence, so it is not negotiable.
- **Everything above the floor has somewhere to slip to, in a known order.** First the macOS CI
  job, since the Mac is where MAXWELL is built every day anyway. Then the process-level
  documentation check, since the first user-facing feature only arrives in sprint 6. Then the
  oracle rig, which has nothing to test until the first decoder exists — also sprint 6.
  Publishing the site to Pages slips last: documentation pull requests are reviewable Markdown
  before anything renders them, but the site is the most visible part of the user-facing work.
- **Every unfamiliar tool gets a timebox.** When one runs over, the overrun becomes an issue and the
  next item starts. A slip is recorded, not absorbed — which is also what managing one's own
  deadlines looks like at a defence.

## Risks

| Risk | Mitigation |
|---|---|
| The walking skeleton overruns | The floor, the slip order and the timeboxes above |
| The catch-up pace does not hold until D07 | Everything above the floor slips in its known order, and each defence measures what is left of the MVP against the days left before D07 |
| Misreading the approval condition | D01 opens by restating it — a solution for an identified target, with an interface backed by documentation and with ease-of-use features at its centre — so a misreading costs a sentence, not a defence |
| OCaml is new, and OxCaml's extensions newer still | OCaml's functional core is familiar from Haskell; its tooling and module system are what sprint 5's timeboxes absorb. OxCaml's extensions are adopted one hot loop at a time, never up front. `decompress` is an in-language codec to read |
| Silent decoder bugs — correct on 99 files, corrupting the 100th | Correctness *is* agreement with the oracles (`decompress`, zlib, `gzip`), checked differentially and by fuzzing; the corpora run from sprint 6 |
| Source maps in the wild are messier than the specification | Before sprint 7, gather real bundles and maps from the major bundlers (esbuild, Rollup and Vite, webpack) and test against them rather than against hand-written maps |
| Versions drift between machines | Nix is the root: the OxCaml compiler and every library are pinned, identically on the Mac and in CI |
| OxCaml's extensions carry no stability promise | Extensions stay in the hot loops; everything else is plain OCaml and builds with the stock compiler. An OxCaml upgrade is a scheduled issue, like any other dependency |
| The compiler builds from source | Unless a binary cache covers the pinned revision, the first CI run is long, so the toolchain is cached from sprint 5 onward |
| Christmas disruption | Sprint 8 holds only small, independent features; nothing depends on them |
| Scope creep toward the follow-up | The committed scope ends at sprint 10; anything past it is written down as follow-up, not started |
| Solo — no one to catch a bad decision | Decisions recorded as ADRs when they are made; documentation reviewed before the code it specifies |

## Working method

Solo, but run as if contributing to someone else's project. Four role hats, each with an artifact
that proves it happened:

| Hat | Produces |
|---|---|
| Spec author | The subject, ADRs, documentation issues and pages |
| Implementer | Pull requests, each opened from an issue |
| Reviewer | Self-review against a checklist before any merge |
| Release manager | Tagged builds out of CI |

Every user-facing feature is two issues — its documentation, then its implementation — with the
first blocking the second ([ADR 0004](./adr/0004-documentation-leads-implementation.md)). Sprint =
fortnight = defence, and every defence closes by stating what the next one will deliver.
