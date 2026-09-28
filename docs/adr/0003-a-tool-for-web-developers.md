# MAXWELL is a tool for web developers, and the codec is its engine

The pedagogical team approved MAXWELL on 24/09/2026 on one condition, quoted verbatim: « ok pour
le projet SI si tu intègres tout un plan utilisateur au centre de ce dernier: interface,
documentation, fonctionnalités visant la facilitation de l'utilisation, … ». A project defined as
"a gzip-compatible compressor that beats `gzip -9`" has no user at its centre, so the project was
restructured around one, rather than given a user-facing layer on top.

**Decision:** MAXWELL is a tool for **web developers who ship gzip-compressed bundles**. It tells
them the *exact* compressed cost of every source in their bundle — by decoding the real compressed
stream, attributing every bit to the output byte it produced, and following the bundle's source
map back to the source that byte came from. Later, it makes their output smaller while keeping it
readable by every existing decoder.

The test applied was whether the user-facing features *need* the engine or merely sit on top of
it. They need it: exact attribution requires decoding the real stream while accounting for every
bit, and smaller output requires an encoder of one's own. Without the codec there is no product;
without the product the codec has no user.

## Consequences

- **The MVP moves.** It is no longer "a working decoder" but "a working decoder that tells a user
  something they could not know before": inflate, attribution, and a report. The encoder becomes
  the chapter after the MVP.
- **Low-level work becomes roughly half the project** rather than nearly all of it, and optimal
  parsing likely moves to the follow-up. Accepted explicitly: both the chosen language and the
  low-level work survive the trade.
- **Scope is gzip, and only gzip.** Brotli carries a comparable share of web traffic — about 46% of
  CDN responses in 2025, against about 42% for gzip
  ([Web Almanac 2025](https://almanac.httparchive.org/en/2025/cdn)) — but other formats are out of
  scope and are not defended against. The one discipline this imposes is on wording: MAXWELL
  reports *the exact gzip cost*, never "the exact download cost", which would be false for a site
  serving Brotli.
- **Both halves rest on published specifications**: RFC 1951 and 1952 for the codec, and ECMA-426
  (source maps, 1st edition, December 2024) for attribution. This keeps the design target of
  [ADR 0001](./0001-project-archetype.md).

## The shape of the product

The interface is a **CLI**, where every ease-of-use feature lives, plus **one self-contained HTML
report** written from a template compiled into the binary. It is the form the target user already
knows — webpack-bundle-analyzer, rollup-plugin-visualizer and source-map-explorer all produce an
HTML page — which makes those tools direct comparison points; and a page can be attached to a pull
request or published by CI. Rejected alongside it: a CLI with no visual output, which loses to the
report on every count; a browser app built from wasm, which is the same report with a second
codebase; and a TUI, which suited the author's background more than the user's habits — web
developers review bundle analysis in a browser, and a terminal session cannot be attached to a pull
request.

In the MVP, the user supplies the compressed file, from `gzip` or from the precompressed asset
their build already emits. Compressing the bundle on the user's behalf, with zlib at the level
their server uses, is in scope as an ease-of-use feature after the MVP. Downloading the live asset
from a server is out of scope: it is networking, which the author chose to keep out of this
project.

## Considered and rejected

- **A user-facing layer on top of the unchanged codec project** — a TUI, a nicer CLI, more
  documentation — without changing what the project is *for*. Rejected as exactly the bolting-on
  the condition rules out.
- **Stopping and choosing another project**, where the user dimension and the low-level work would
  not compete for the same days. Rejected: the trade was acceptable, and the restructured MVP is
  stronger — it proves value, not just competence.
- **Other target users.** Everyday terminal users compressing logs and backups want a humane CLI,
  which tools such as `ouch` and the `zstd` CLI already provide. Learners who want to *see*
  compression are a strong fit for a visual interface, but their need is thin. The web developer
  was chosen because their pain is documented: the maintainer of source-map-explorer called exact
  per-module gzip size "almost impossible"
  ([#177](https://github.com/danvk/source-map-explorer/issues/177)).
