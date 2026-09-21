---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work.

Describe your work with `jj describe`, then `jj new` to start the next piece. Bookmarks don't move on their own: `jj tug` pulls the nearest one forward to `@-`. Don't push unless the user asked.
