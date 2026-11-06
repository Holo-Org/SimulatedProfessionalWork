# Issue tracker: GitHub

Issues and specs for this repo live as GitHub issues in **`Holo-Org/SimulatedProfessionalWork`**
(public). Use the `gh` CLI for issues, labels, types and relationships. Use the **GraphQL API**
for issue *field values* — `gh` has no flag for those.

## Repo resolution — read this first

There is no `.git` directory here, so **`gh` cannot infer the repository**.
Name the repo on every call, with `--repo Holo-Org/SimulatedProfessionalWork` or set `GH_REPO`.
`gh api` needs neither. Read the remote with `jj git remote list`.

## Conventions

- **Create**: `gh issue create --title "..." --body "..." --type "<type> --label "01.status: <state>`. Use a heredoc for multi-line bodies. Add `--parent <n>` for a sub-issue, `--blocked-by <n>` / `--blocking <n>`
  for dependencies, `-p SimulatedProfessionalWork` to place it on the board.
- **Read**: `gh issue view <n> --comments`. Add `--json id,number,title,body,labels,issueType,issueFieldValues`
  when you need the node ID or the field values.
- **List**: `gh issue list --state open --json number,title,body,labels,issueType --jq '[.[] | {number, title, labels: [.labels[].name], type: .issueType.name}]'`.
  Filter with `--label`, `--state`, `--type`.
- **Comment**: `gh issue comment <n> --body "..."`
- **Labels**: `gh issue edit <n> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <n> --comment "..."`

## Issue types (the triage "category")

Every issue has exactly one type, set with `--type` on create or edit. Triage `bug` is `Bug`; triage `enhancement` is `Improvement`. The others are `Agile`, `Question`, `Extra Deliverable`, `Build` and `Documentation`. If none fits, ask the maintainer.

**Rule — contextual typing.** Planning work an agent breaks down (`/to-tickets`, or the execution
issues a `/wayfinder` map hands off to) gets type `Agile` plus a `Hierarchy` value. Reported work
gets the matching concrete type (`Bug`, `Improvement`, `Documentation`, `Build`) plus its
applicable fields (see below). A Wayfinder map and its tickets are neither: they are `Question`,
see [Wayfinding operations](#wayfinding-operations).

## Issue fields

`gh issue` does not expose issue fields; use `gh api graphql`. When creating an issue, fill at least the fields pinned to its type:

- `Bug`: Kind, Origin
- `Improvement`: Target release, Category (pick the matching option)
- `Build`, `Documentation`: Target release
- `Agile`: Priority, Effort, Start date, Target date, Hierarchy
- `Extra Deliverable`: none
- `Question`: Wayfinder, only for Wayfinder issues

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

### Suggest vs. write

Set the value when the maintainer stated it or the issue makes it certain. Otherwise propose it with `suggest: true`, a `confidence` (`LOW`, `MEDIUM` or `HIGH`) and a `rationale`. Look up IDs by name first:

```
gh api graphql -f query='query{organization(login:"Holo-Org"){
  issueTypes(first:20){nodes{id name pinnedFields{... on IssueFieldSingleSelect{name} ... on IssueFieldText{name} ... on IssueFieldDate{name}}}}
  issueFields(first:50){nodes{... on IssueFieldSingleSelect{id name options{id name}} ... on IssueFieldText{id name} ... on IssueFieldDate{id name}}}}}'
```

Set a value on an existing issue (`textValue` and `dateValue` exist for text and date fields):

```
mutation{setIssueFieldValue(input:{issueId:"<id>", issueFields:[
  {fieldId:"<field>", singleSelectOptionId:"<option>", suggest:true, confidence:MEDIUM, rationale:"..."}]}){issue{id}}}
```

`createIssue` accepts `issueTypeId`, `parentIssueId` and the same `issueFields` list.

## Pull requests

- PRs are not a triage surface and take no `01.status:` labels.
- Every PR gets one or two `2.component:` labels (`gh pr create --label`). If none fits, create one: `gh label create "2.component: <name>" --color A78BFA --description "..." --repo Holo-Org/SimulatedProfessionalWork`. All component labels use `#A78BFA`, except `2.component: uncategorized`.
- `2.component: uncategorized` means a human found no fitting component. The first agent to see it creates and/or assigns the right component label(s) and removes `uncategorized`.
- A PR that needs more than two components should be split into a stack. Open the PRs from jj bookmarks as usual, then link them bottom to top with `gh stack link <pr> <pr> ...`; it works from PR numbers, URLs or branch names without local stack tracking, so it needs no `.git` directory (see `gh stack link --help`).

## When a skill says "publish to the issue tracker"

Create a GitHub issue, typed per the contextual rule above, placed on board 5.

## When a skill says "fetch the relevant ticket"

`gh issue view <n> --repo Holo-Org/SimulatedProfessionalWork --comments`

## Wayfinding operations

Used by `/wayfinder`. Wayfinder issues have type `Question` and the Wayfinder field set, and take no status label.

- **Map**: an issue with type `Question` and Wayfinder = `05.wayfinder: map`, holding the Notes / Decisions-so-far / Fog body.
- **Child ticket**: type `Question`, Wayfinder = `05.wayfinder: research`, `grilling`, `prototype` or `task`, created with `parentIssueId` = the map (or `addSubIssue(input:{issueId, subIssueId})` afterwards). The assignee is the claim.
- **Blocking**: native dependencies, `addBlockedBy(input:{issueId:"<blocked>", blockingIssueId:"<blocker>"})`. Open blockers show in `issueDependenciesSummary.blockedBy`.
- **Frontier query**: the map's `subIssues` that are open, have `issueDependenciesSummary.blockedBy == 0` and no assignee; first in map order wins.
- **Claim**: `gh issue edit <n> --add-assignee @me`, the session's first write.
- **Resolve**: `gh issue comment <n> --body "<answer>"`, then `gh issue close <n>`, then append a context pointer to the map's Decisions-so-far.
