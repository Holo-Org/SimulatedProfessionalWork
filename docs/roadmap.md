# Roadmap

Delivery plan for MAXWELL. The subject in [`docs/subject/maxwell.html`](./subject/maxwell.html)
describes *what* is built and is deliberately undated; this file says *when*, and is the only place
dates belong.

MAXWELL is a tool for web developers: it reports the exact gzip cost of every source in their
bundle, then makes that bundle smaller while every existing decoder can still read it
([ADR 0003](./adr/0003-a-tool-for-web-developers.md)). It is written in OCaml
([ADR 0005](./adr/0005-ocaml-not-zig.md)), and its documentation leads its implementation
([ADR 0004](./adr/0004-documentation-leads-implementation.md)).

Project window: **14/09/2026 → 17/01/2027**. Nine fortnightly sprints, each ending with its defence
on the Friday of its second week. Working days are **Thursdays and Fridays**, so a sprint holds four
working days, one of which is its own defence — about three and a half days of building.

## Scope commitment

Split three ways, because the module grades steady pace rather than completion, and because a
roadmap that promises everything is worth the same as one that promises nothing.

- **MVP — guaranteed, at D05.** MAXWELL inflates a real gzip-compressed bundle, attributes every
  compressed bit to the byte it produced and, through the source map, to the source that byte came
  from, and reports the exact gzip cost of each source in the terminal. Corrupted input fails with
  an error that says where and why.
- **Committed beyond the MVP.** The HTML report with its heat map; the remaining ease-of-use
  features — colour that respects `NO_COLOR`, output that never relies on colour alone,
  configuration from a file and the environment, completions for five shells, compressing the
  bundle with zlib at the server's level, an estimated-savings line, and the `my_gzig` drop-in —
  and MAXWELL's own encoder.
- **Follow-up, not promised**, in order: CI cost budgets, lazy matching and level tuning, optimal
  parsing, parallel compression across OCaml 5 domains, and — last of all — Zstandard.

## Sprints

| Sprint | Window | Defence | Chapter | Work | What is demonstrated |
|---|---|---|---|---|---|
| 1 | 14/09 – 27/09 | **D01** 25/09 | Pitch | Subject, roadmap, risk register | The project is defined and validated |
| 2 | 28/09 – 11/10 | **D02** 09/10 | Walking skeleton | Nix toolchain, opam lock file, dune, Makefile; CI on macOS, Linux and Windows (build, test, format, coverage); CD on tag; the documentation site; both documentation checks; the oracle rig | A trivial `maxwell` that builds, tests, documents and releases itself on three systems |
| 3 | 12/10 – 25/10 | **D03** 23/10 | Read I | gzip container, stored and fixed-Huffman blocks, least-significant-bit-first bit reader, located errors | Simple files decompress; a corrupted one fails with an error that says where and why |
| 4 | 26/10 – 08/11 | **D04** 06/11 | Read II | Dynamic-Huffman blocks, the 32 KB window, bit accounting, cost per line | All of Canterbury inflates exactly as the oracles do; the first cost table |
| 5 | 09/11 – 22/11 | **D05** 20/11 | **MVP — Attribute** | Source maps (ECMA-426), cost per source with raw size, the first tutorial | The exact gzip cost of every source in a real bundle |
| 6 | 23/11 – 06/12 | **D06** 04/12 | Show | HTML report with heat map; colour, `NO_COLOR`, accessible output | The report, open in a browser |
| 7 | 07/12 – 20/12 | **D07** 18/12 | Shrink | MAXWELL's encoder: stored, fixed and dynamic-Huffman output, hash-chain LZ77, effort levels | Output that real `gzip` decompresses |
| 8 | 21/12 – 03/01 | **D08** unscheduled ⚠️ | Ease of use II | Configuration file and environment; completions for five shells; compression with zlib at the server's level; estimated savings; `my_gzig` | Small, independent features, each shipped with its documentation |
| 9 | 04/01 – 17/01 | **D09** 15/01 | Buffer and delivery | Whatever slipped, packaging, final documentation | Everything, from a fresh clone |

⚠️ **D08 is not yet scheduled.** The official defence calendar leaves it open: the fortnightly
rhythm would put it on 01/01, which is New Year's Day, and its real date will come from the
pedagogical team.

**Attribution climbs one rung at a time.** Cost per line (sprint 4) needs no source map, so it comes
before cost per source (sprint 5): bits, then bytes, then lines, then sources, each rung a result in
its own right.

**Christmas carries small, independent work.** Sprint 8's five features are each a documentation
issue and an implementation issue measured in hours, so they survive scattered holiday time, and
nothing later depends on them. The encoder, the largest piece after the MVP, lands at D07, before
the holidays.

**Sprint 9 is slack by design.** The final fortnight carries delivery, not a risky feature. Work
that slips from any earlier sprint lands here; if nothing slips, the follow-up starts.

## Sprint 2 is the heaviest, and how it is managed

It builds the whole machine around a program that does nothing yet, with every tool new at once —
OCaml's build and package tooling, coverage, CI on three systems, the documentation site and its
checks — in about three and a half days. Three measures keep it inside its defence:

- **A floor that must hold at D02.** From a fresh clone, `make` builds `maxwell` and the tests run;
  CI is green on macOS and Linux; coverage is reported; a tag produces a release binary; and the
  mechanical documentation check guards `--help` and the man page. That floor is what Part 0 of the
  subject grades at every defence, so it is not negotiable.
- **Everything above the floor has somewhere to slip to, in a known order.** First the
  process-level documentation check, since the first user-facing feature only arrives in sprint 3.
  Then the oracle rig, which has nothing to test until the first decoder exists — also sprint 3.
  Then publishing the site to Pages, since documentation pull requests are reviewable Markdown
  before anything renders them. The Windows CI job slips last, because Windows problems compound
  the longer nobody sees them.
- **Every unfamiliar tool gets a timebox.** When one runs over, the overrun becomes an issue and the
  next item starts. A slip is recorded, not absorbed — which is also what managing one's own
  deadlines looks like at a defence.

## Risks

| Risk | Mitigation |
|---|---|
| Sprint 2 overruns | The floor, the slip order and the timeboxes above |
| Misreading the approval condition | D01 opens by restating it — a solution for an identified target, with an interface backed by documentation and with ease-of-use features at its centre — so a misreading costs a sentence, not a defence |
| OCaml is new | Its functional core is familiar from Haskell; what is new is the tooling and the module system, which sprint 2's timeboxes absorb. `decompress` is an in-language codec to read |
| Silent decoder bugs — correct on 99 files, corrupting the 100th | Correctness *is* agreement with the oracles (`decompress`, zlib, `gzip`), checked differentially and by fuzzing; the corpora run from sprint 4 |
| Source maps in the wild are messier than the specification | Before sprint 5, gather real bundles and maps from the major bundlers (esbuild, Rollup and Vite, webpack) and test against them rather than against hand-written maps |
| Library versions drift between systems | Nix pins the toolchain; one opam lock file pins every library, identically on macOS, Linux and Windows |
| Christmas disruption | Sprint 8 holds only small, independent features; nothing depends on them |
| Scope creep toward the follow-up | The committed scope ends at sprint 8; anything past it is written down as follow-up, not started |
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
