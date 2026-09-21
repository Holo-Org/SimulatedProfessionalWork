# Triage Labels

The skills speak in terms of five canonical triage roles. This file maps those roles to the
actual label strings used in `Holo-Org/SimulatedProfessionalWork`.

| Label in mattpocock/skills | Label in our tracker      | Meaning                                  |
| -------------------------- | ------------------------- | ---------------------------------------- |
| `needs-triage`             | `01.status: needs-triage` | Maintainer needs to evaluate this issue  |
| `needs-info`               | `01.status: needs-info`   | Waiting on reporter for more information |
| `ready-for-agent`          | `01.status: ready-for-agent` | Fully specified, ready for an AFK agent |
| `ready-for-human`          | `01.status: ready-for-human` | Requires human implementation         |
| `wontfix`                  | `01.status: wontfix`      | Will not be actioned                     |

When a skill mentions a role (e.g. "apply the AFK-ready triage label"), use the corresponding
label string from the right-hand column. **Always quote them** — every string contains a space
and a colon:

```
gh issue edit 12 --repo Holo-Org/SimulatedProfessionalWork --add-label "01.status: ready-for-agent"
```

## Labels agents must not set

Two more labels share the `01.status: ` prefix but are **not** triage roles, and agents do not
apply them by hand:

| Label | Why not |
| --- | --- |
| `01.status: blocked` | Blocking is owned by GitHub's native dependencies (`--blocked-by`). A hand-applied label drifts out of sync with the real gate. |
| `01.status: in-progress` | Owned by the assignee plus the board's `Status` column. |

See the status model in `issue-tracker.md` for the full division.

## The rest of the label vocabulary

Not triage roles, but the same repo uses them — leave them alone unless a skill has a reason:

- `00.release: major | minor | patch` — version-bump impact
- `1.type: Chore` — maintenance that fits no other type. Note the `1.type: ` prefix is *also*
  used by the `Kind`, `Origin` and `Category` **issue fields**, which are a different mechanism.
  If a skill says "set the type", it almost always means the **issue type**
  (`gh issue create --type`), not this label.
- `2.component: Setup | uncategorized` — area of the codebase
- `3.external: first-issue | help-wanted` — newcomer-facing

Edit the right-hand column of the first table if the label vocabulary changes.
