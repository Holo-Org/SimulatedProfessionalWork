# Issue tracker: GitHub

Issues and specs for this repo live as GitHub issues in **`Holo-Org/SimulatedProfessionalWork`**
(public). Use the `gh` CLI for issues, labels, types and relationships. Use the **GraphQL API**
for issue *field values* — `gh` has no flag for those.

## Repo resolution — read this first

There is no `.git` directory here, so **`gh` cannot infer the repository**. Either point it at
the store jj keeps, once per shell:

```
export GIT_DIR=$(jj git root)
```

…or name the repo on every call, with `--repo Holo-Org/SimulatedProfessionalWork` or `GH_REPO`.
`gh api` needs neither. Read the remote with `jj git remote list`.

Requires **`gh` >= 2.100.0** for `--type`, `--parent`, `--blocked-by`, `--blocking`.
Check with `gh --version` before assuming those flags exist.

## Conventions

- **Create**: `gh issue create --title "..." --body "..." --type "<type>"`. Use a heredoc for
  multi-line bodies. Add `--parent <n>` for a sub-issue, `--blocked-by <n>` / `--blocking <n>`
  for dependencies, `-p SimulatedProfessionalWork` to place it on the board.
- **Read**: `gh issue view <n> --comments`. Add `--json id,number,title,body,labels,issueType,issueFieldValues`
  when you need the node ID or the field values.
- **List**: `gh issue list --state open --json number,title,body,labels,issueType --jq '[.[] | {number, title, labels: [.labels[].name], type: .issueType.name}]'`.
  Filter with `--label`, `--state`, `--type`.
- **Comment**: `gh issue comment <n> --body "..."`
- **Labels**: `gh issue edit <n> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <n> --comment "..."`

## Issue types

Seven org-level types, set with `--type "<name>"` on create or edit:

| Type | Use for |
| --- | --- |
| `Bug` | An unexpected problem or behavior |
| `Agile` | Planning items — Epic, Story, Task (pair with `Hierarchy`) |
| `Question` | Not a code issue; something is unclear |
| `Extra Delivrable` | Proposed addition outside the original scope *(name is misspelled upstream — match it exactly)* |
| `Build` | New build method, packaging, package manager |
| `Documentation` | Clarify usage, behaviour, or structure |
| `Improvement` | General improvement to the codebase |

**Rule — contextual typing.** Planning work an agent breaks down (`/to-tickets`, `/wayfinder`)
gets type `Agile` plus a `Hierarchy` value. Reported work gets the matching concrete type
(`Bug`, `Improvement`, `Documentation`, `Build`) plus its applicable fields (see below).

## Issue fields

Nine org-level fields, all inherited by this repo. **`gh` cannot set these.** They move only
through the GraphQL `setIssueFieldValue` mutation, keyed by node ID.

| Field | Type | Node ID | Applies to |
| --- | --- | --- | --- |
| `Priority` | single-select | `IFSS_kgDOAjyc-g` | everything |
| `Effort` | single-select | `IFSS_kgDOAjyc_Q` | everything |
| `Hierarchy` | single-select | `IFSS_kgDOAtCAjg` | `Agile` items |
| `Kind` | single-select | `IFSS_kgDOAtCCkQ` | `Bug` only |
| `Origin` | single-select | `IFSS_kgDOAtCC1g` | `Bug` only |
| `Category` | single-select | `IFSS_kgDOAtCF5w` | `Improvement` / `Build` |
| `Start date` | date | `IFD_kgDOAjyc-w` | everything |
| `Target date` | date | `IFD_kgDOAjyc_A` | everything |
| `Target release` | text | `IFT_kgDOAtCBAw` | everything |

### Option IDs

`Priority` (`03.priority: `) — Urgent `IFSSO_kgDOA-n6zw` · High `IFSSO_kgDOA-n60A` ·
Medium `IFSSO_kgDOA-n60Q` · Low `IFSSO_kgDOA-n60g` · Bonus `IFSSO_kgDOBO02QQ`

`Effort` (`04.size: `) — XL `IFSSO_kgDOA-n60w` · L `IFSSO_kgDOBO03aA` · M `IFSSO_kgDOA-n61A` ·
S `IFSSO_kgDOA-n61Q` · XS `IFSSO_kgDOBO03aQ`

`Hierarchy` (`02.layer: `) — Epic `IFSSO_kgDOBO0_Ig` · Feature `IFSSO_kgDOBO0_Iw` ·
Story `IFSSO_kgDOBO0_JA` · Task `IFSSO_kgDOBO0_JQ` · ~~Initative `IFSSO_kgDOBO0_IQ`~~ **DO NOT USE**

`Kind` (`1.type: `) — Logic `IFSSO_kgDOBO1CrQ` · Crash `IFSSO_kgDOBO1Crg` · Security `IFSSO_kgDOBO1Crw` ·
Concurrency `IFSSO_kgDOBO1CsA` · Configuration `IFSSO_kgDOBO1CsQ` · Data `IFSSO_kgDOBO1Csg` ·
Build / Dependency `IFSSO_kgDOBO1Csw`

`Origin` (`1.type: `) — Regression `IFSSO_kgDOBO1DKw` · New `IFSSO_kgDOBO1DLA` · Legacy `IFSSO_kgDOBO1DLQ`

`Category` (`1.type: `) — CI `IFSSO_kgDOBO1Ijg` · Build `IFSSO_kgDOBO1Ijw` · Refactor `IFSSO_kgDOBO1IkA` ·
Cleanup `IFSSO_kgDOBO1IkQ` · Performance `IFSSO_kgDOBO1Ikg` · Compatibility `IFSSO_kgDOBO1Ikw` ·
UI / UX `IFSSO_kgDOBO1IlA` · Dependencies `IFSSO_kgDOBO1IlQ` · E2E Tests `IFSSO_kgDOBO1Ilg` ·
Integration Tests `IFSSO_kgDOBO1Ilw` · Unit Tests `IFSSO_kgDOBO1ImA` · Contract Tests `IFSSO_kgDOBO1ImQ` ·
Fuzz Tests `IFSSO_kgDOBO1Img`

Re-derive any of these with:

```
gh api graphql -f query='{ organization(login:"Holo-Org") { issueFields(first:20) { nodes {
  ... on IssueFieldCommon { name dataType }
  ... on IssueFieldSingleSelect { id options { id name } }
  ... on IssueFieldText { id } ... on IssueFieldDate { id } ... on IssueFieldNumber { id }
} } } }'
```

### Setting a field value

Get the issue's node ID, then call the mutation:

```
gh issue view <n> --repo Holo-Org/SimulatedProfessionalWork --json id --jq .id
```

```
gh api graphql -f query='
mutation($issueId: ID!) {
  setIssueFieldValue(input: {
    issueId: $issueId
    issueFields: [{
      fieldId: "IFSS_kgDOAjyc_Q"
      singleSelectOptionId: "IFSSO_kgDOA-n61A"
      suggest: true
      confidence: MEDIUM
      rationale: "Touches two modules with a known unknown in the parser."
    }]
  }) { issue { number } }
}' -f issueId="<node-id>"
```

`issueFields` takes a list, so set several fields in one call. Value keys by data type:
`singleSelectOptionId`, `multiSelectOptionIds`, `textValue`, `dateValue`, `numberValue`.
`delete: true` clears a value.

### Suggest vs. write — the policy

The mutation is agent-aware. `suggest: true` stores the value as a **pending suggestion for
human review** instead of applying it; `confidence` is `LOW | MEDIUM | HIGH`; `rationale` is
free text, max 280 characters.

- **Judgement calls → `suggest: true`.** `Priority`, `Effort`, `Hierarchy`, `Target date`.
  These are the maintainer's calls; an agent proposes, a human accepts.
- **Facts → write directly** (`suggest` omitted). `Kind` and `Origin` on a bug the agent just
  diagnosed, `Category` on work the agent itself scoped.
- **Always set `rationale`**, on suggestions and direct writes alike. It is the audit trail.
- Set `confidence` honestly. `LOW` on a suggestion is a useful signal, not a failure.

## Status model

Status is representable three ways here. Each owns one thing; do not cross the streams.

| Concern | Owner | Agent behaviour |
| --- | --- | --- |
| Blocking | GitHub **native dependencies** (`--blocked-by` / `--blocking`) | Create and read these. A ticket is unblocked when every blocker is closed. |
| Triage state | `01.status: ` **labels** | Read and write these — this is what `/triage` operates on. |
| Workflow state | Board **`Status`** field | Human view. Agents read it; they do not drive it. |

**Never hand-apply `01.status: blocked`.** Blocking is derived from native dependencies; the
label is cosmetic and will drift. Same for `01.status: in-progress` — an assignee plus the
board column is the real signal.

## Project board

Board **`SimulatedProfessionalWork`** (org `Holo-Org`, number **5**, `PVT_kwDODnMOUs4BkLui`).

Add an issue on create with `-p SimulatedProfessionalWork`, or after the fact with
`gh issue edit <n> --add-project SimulatedProfessionalWork`.

`Status` options: Backlog · Ready · Created · In Progress · In Review · Changes Requested ·
Waiting Merge · Merged · Fixed · Cancelled · — plus a **`Sprint`** iteration field
(`PVTIF_lADODnMOUs4BkLuizhi9O7c`) and `Number of day worked on`.

The board's `Priority`, `Effort` and `Hierarchy` columns **are the org issue fields themselves**,
linked directly into GitHub Projects — not project-level copies. So `setIssueFieldValue` is the
only write needed: set the issue field and the board column follows. Do **not** also call
`updateProjectV2ItemFieldValue` for these three; that would be writing to the same value twice.

`Status`, `Sprint` and `Number of day worked on` are genuine project-level fields and do go
through `updateProjectV2ItemFieldValue` — but per the status model above, agents leave those
to humans.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` if this repo starts treating external PRs as
feature requests; `/triage` reads this flag.)_

GitHub shares one number space across issues and PRs, so a bare `#42` may be either: resolve
with `gh pr view 42` and fall back to `gh issue view 42`.

## When a skill says "publish to the issue tracker"

Create a GitHub issue, typed per the contextual rule above, placed on board 5.

## When a skill says "fetch the relevant ticket"

`gh issue view <n> --repo Holo-Org/SimulatedProfessionalWork --comments`

## Wayfinding operations

Used by `/wayfinder`. The **map** is a parent issue with **child** issues as tickets.

- **Map**: an issue of type `Agile` with `Hierarchy` = `02.layer: Epic`, holding the
  Notes / Decisions-so-far / Fog body.
- **Child ticket**: `gh issue create --parent <map> --type Agile`, with `Hierarchy` =
  `02.layer: Task` (or `Story` for a multi-part child). Native sub-issues, so the map shows
  `Sub-issues progress` on the board.
- **Blocking**: `gh issue create --blocked-by <n>` or `gh issue edit <n> --add-blocked-by <m>`.
  Read back with `gh api repos/Holo-Org/SimulatedProfessionalWork/issues/<n> --jq .issue_dependencies_summary.blocked_by`
  (open blockers only — the live gate).
- **Frontier**: list the map's open children, drop any with an open blocker or an assignee;
  first in map order wins.
- **Claim**: `gh issue edit <n> --add-assignee @me`, the session's first write.
- **Resolve**: `gh issue comment <n> --body "<answer>"`, `gh issue close <n>`, then append a
  context pointer (gist + link) to the map's Decisions-so-far.

> **Gap:** `/wayfinder` distinguishes ticket types `research` / `prototype` / `grilling` / `task`,
> and this repo has no vocabulary for that. Interim rule: use issue type `Question` for
> `research` and `grilling`, `Agile` + `Hierarchy: Task` for `prototype` and `task`. Replace this
> with dedicated labels if the distinction starts mattering.

## Known upstream typos

These are exact-match strings. Match them as written until they are fixed at the org level.

| Where | Current | Intended |
| --- | --- | --- |
| `Hierarchy` option | `O2.layer: Story` — leading letter **O**, not zero | `02.layer: Story` |
| Issue type | `Extra Delivrable` | `Extra Deliverable` |
| `Hierarchy` option | `02.layer: Initative` | `02.layer: Initiative` |
| `Improvement` description | "Genral improvement" | "General improvement" |
