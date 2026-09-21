# SimulatedProfessionalWork

Epitech B-PRO-500. See `docs/subject/B-PRO-500_professionalwork.pdf` for the catalogue
and the evaluation criteria.

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
