# Roadmap

Delivery plan for MAXWELL. The subject in [`docs/subject/maxwell.html`](./subject/maxwell.html)
describes *what* is built and is deliberately undated; this file says *when*, and is the only
place dates belong.

Project window: **14/09/2026 → 17/01/2027**. Nine fortnightly sprints, each ending with its
defence on the Friday of its second week. Capacity is **two working days per week**, so roughly
four working days per sprint and ~32 person-days in total.

## Scope commitment

Split three ways, because the module grades steady pace rather than completion, and because a
roadmap that promises everything is worth the same as one that promises nothing.

- **MVP — guaranteed.** A working decoder: gzip container, all three DEFLATE block types, the
  32 KB sliding window. It inflates files it did not produce.
- **Committed beyond the MVP.** An encoder whose output the reference implementation reads, LZ77
  match finding with meaningful effort levels, a benchmark harness over published corpora, and
  optimal parsing — the point at which output is measurably smaller than `gzip -9` while
  remaining readable by every deployed decoder.
- **Follow-up, not promised.** Zstandard: first a decoder, then the compressor that Zig's
  standard library does not have. Written into the subject as bonus tracks so that reaching them
  is credit rather than obligation.

## Sprints

| Sprint | Window | Defence | Work | What is demonstrated |
|---|---|---|---|---|
| 1 | 14/09 – 27/09 | **D01** 25/09 | Pitch: subject, roadmap, risk register | The project is defined and validated |
| 2 | 28/09 – 11/10 | **D02** 09/10 | Setup — Nix flake pinning the toolchain, `build.zig`, Makefile, CI (build/test/fmt/lint), CD producing a release binary, differential-test rig against the reference. Plus gzip container and stored blocks | Green pipeline from a fresh clone; a stored-block file round-trips |
| 3 | 12/10 – 25/10 | **D03** 23/10 | Fixed and dynamic Huffman decoding, sliding window with overlapping copy | Decodes the entire Canterbury corpus |
| 4 | 26/10 – 08/11 | **D04** 06/11 | Encoder: stored and fixed-Huffman output | Real `gzip` decompresses our output |
| 5 | 09/11 – 22/11 | **D05** 20/11 | Encoder: dynamic Huffman, LZ77 hash chains, lazy matching, effort levels | Ratio table against `gzip -1..-9` |
| 6 | 23/11 – 06/12 | **D06** 04/12 | Benchmark harness, profiling, targeted optimisation | Ratio and throughput curves against the reference |
| 7 | 07/12 – 20/12 | **D07** 18/12 | Optimal parsing | Smaller than `gzip -9`, still gzip-readable |
| 8 | 21/12 – 03/01 | **D08** 01/01 ⚠️ | Deliberately light: zlib and raw containers, fuzzing, malformed-input handling, coverage, documentation | Fuzz results, coverage report, user manual |
| 9 | 04/01 – 17/01 | **D09** 15/01 | Buffer, packaging, final delivery | Everything, from a fresh clone |

⚠️ **D08 falls on New Year's Day and will have to move** — confirm the replacement date with the
pedagogical team early. Sprint 8 also straddles Christmas, which is why it carries non-blocking
work that survives being done in scattered hours, and why the headline result (optimal parsing)
lands at D07, before the holidays, rather than after them.

**Sprint 9 is slack by design.** The final fortnight carries delivery, not a risky feature. Work
that slips from any earlier sprint lands here; if nothing slips, the follow-up tracks start.

## Risks

| Risk | Mitigation |
|---|---|
| Zig 0.17 releases mid-project | Toolchain pinned to 0.16.0 through Nix. A release becomes a backlog issue — "evaluate 0.17 portage" — triaged like any other, not an interrupt. 0.17's known churn is in `std.Io` and the build system; this project touches little beyond files and memory |
| Silent decoder bugs — correct on 99 files, corrupting the 100th | Differential testing against the reference implementation is the *definition* of correctness here, not a supplementary check. Fuzzing from sprint 8, corpora from sprint 3 |
| Sprint 2 carries both setup and first feature | Setup is the priority; stored blocks slip to sprint 3 if needed. Everything downstream has a fortnight of slack at sprint 9 |
| Christmas disruption | Sprint 8 pre-loaded with non-blocking work; no dependency runs through it |
| Solo — no one to catch a bad decision | Decisions recorded as ADRs in `docs/adr/` at the time they are made, so they can be reviewed later rather than reconstructed |
| Scope creep toward Zstandard | Explicitly a bonus track in the subject. The committed scope ends at optimal parsing |

## Working method

Solo, but run as if contributing to someone else's project. Four role hats, each with an artifact
that proves it happened:

| Hat | Produces |
|---|---|
| Spec author | The subject, ADRs, issue descriptions |
| Implementer | Pull requests, each opened from an issue |
| Reviewer | Self-review against a checklist before any merge |
| Release manager | Tagged builds out of CI |

Sprint = fortnight = defence. Every defence closes by stating what the next one will deliver.
