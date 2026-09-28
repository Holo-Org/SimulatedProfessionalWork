# Documentation leads implementation

User-facing behaviour is documented — and the documentation merged — *before* it is implemented.
The documentation is the specification the implementation must meet, not a description written
after the fact. Drift that nothing checks is drift nobody catches, so the check is automatic.

It is enforced in two layers:

- **Mechanically, for the reference.** The reference pages, `--help`, the man page and the
  generated shell completions all come from the single CLI definition, and the generated files are
  committed. A documentation change edits them first; the implementation must then regenerate them
  exactly, or CI fails. For the reference, the documentation *is* the test.
- **By process, for prose.** Tutorials, how-to guides and explanations cannot be generated, so every
  implementation pull request links its documentation pull request, and CI checks that the
  documentation was merged first.

In practice, every user-facing feature becomes two issues, the documentation issue blocking the
implementation issue — a relationship the tracker supports natively.

## Where the documentation lives

In this repository, as an Astro Starlight site under `site/`, published to GitHub Pages by CI on
every merge. Its structure follows Diátaxis — tutorials, how-to guides, reference, explanation —
and its home page carries the comparison with existing tools. It is written in English.

`docs/` stays separate because it has a different reader: it holds the subject, the roadmap and
these decisions, for whoever *works on* MAXWELL, while `site/` is for whoever *uses* it.

A separate documentation repository was considered, and would work with the same two checks. It
lost on cost alone: there, the mechanical check needs a second checkout and an access token, where
in one repository it is a local diff.
