---
name: resolving-merge-conflicts
description: "Use when you need to resolve a merge or rebase conflict."
---

1. **See the current state.** `jj status` for the working copy, `jj resolve --list` for the conflicted files, `jj log -r 'conflicts()'` for every conflicted commit. Resolve the oldest first; descendants usually follow.

2. **Find the primary sources** for each conflict. Understand deeply why each change was made, and what the original intent was. Read the descriptions (`jj log`, `jj show <rev>`), check the PRs, check original issues/tickets.

3. **Resolve each hunk.** Preserve both intents where possible. Where incompatible, pick the one matching the merge's stated goal and note the trade-off. Do **not** invent new behaviour. Edit the markers directly, or `jj resolve` (`-r <rev>` for a commit other than the working copy). Always resolve; never abandon the conflicted commit.

4. Discover the project's **automated checks** and run them, typically typecheck, then tests, then format. Where there's a `.jj-ci.toml`, that's the list: `nu ~/Scripts/jj-ci/bin/jj-ci ci` (not yet installed as the `jj ci` alias). Fix anything the merge broke.

5. **Finish.** Confirm with `jj status` and `jj log -r 'conflicts()'` that nothing is left. `jj describe` if the commit still needs a message.
