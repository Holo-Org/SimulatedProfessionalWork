# SimulatedProfessionalWork

Epitech B-PRO-500. See `docs/subject/B-PRO-500_professionalwork.pdf` for the catalogue
and the evaluation criteria.

## Attribution

**This section overrides the global "never put yourself as a contributor" rule, for this repo
only.** That rule still holds everywhere else.

This is a school project graded partly on how the work was conducted, so who did what needs to be
on the record rather than hidden. Three cases:

- **Claude worked alone, unsupervised** — Claude is the *author*, and I am the committer:

  ```
  jj metaedit -r <rev> --author "Claude Opus 5 <noreply@anthropic.com>"
  ```

  Set this when the change was produced end-to-end without me steering it. Being reviewed by me
  afterwards does not make it mine.

- **I mention Claude in the commit body** — add a trailer, keeping me as author:

  ```
  Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
  ```

  This is the normal case for work we did together, however much of the text Claude produced. If
  I named Claude in the message, the trailer belongs there too — don't wait to be asked.

- **Neither applies** — no attribution, exactly as the global rule says.

Two mechanical notes. `signing.behavior = "force"` in this repo, so rewriting a commit re-signs it
with my key: a commit authored by Claude still carries my signature as committer, which is correct
— I am vouching for it. And `jj describe` cannot change authorship, only the description; author
changes go through `jj metaedit`.

## Agent skills

### Issue tracker

GitHub Issues in `Holo-Org/SimulatedProfessionalWork`, driven by `gh`. Two things differ
from a stock GitHub repo: every command must name `--repo` explicitly (this is a
non-colocated `jj` repo, so `gh` cannot infer it), and issue **field** values are set
through the GraphQL `setIssueFieldValue` mutation because `gh` has no flag for them.
See `docs/agents/issue-tracker.md`.

### Triage labels

The five canonical triage roles map to this repo's `01.status: `-prefixed labels.
See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `CONTEXT.md` and `docs/adr/` at the repo root.
See `docs/agents/domain.md`.
