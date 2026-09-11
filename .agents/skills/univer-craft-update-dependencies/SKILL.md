---
name: univer-craft-update-dependencies
description: Update Univer Craft's pinned Tina submodule to the latest upstream main or a requested revision, review compatibility, and validate the combined bundle. Use when the user asks to upgrade Tina in Univer Craft; use univer-craft-sync to propagate the current bundle to a target repository.
---

# Univer Craft Update Dependencies

Update the Tina dependency in this source repository. A dependency update does
not synchronize installed targets or update Tina's own upstream dependencies.

## Resolve and preserve the baseline

Resolve `$bundle_root` to the Univer Craft repository containing this skill,
`.gitmodules`, `install-univer-craft.sh`, and `skills/univer-craft/`.
Resolve `$tina_root` to `$bundle_root/vendor/tina` and verify it is the submodule
declared in `.gitmodules`. Initialize it at the recorded revision if absent:

```sh
git -C "$bundle_root" submodule update --init vendor/tina
```

Record the parent status, staged and unstaged diffs, recorded gitlink, actual
Tina commit, and whether Tina is on a branch or detached. Preserve existing
parent changes, including a previously staged gitlink. Require a clean Tina
worktree and index, including untracked files; do not stash, discard, or commit
local Tina edits. If those edits prevent updating, report the paths and ask how
the user wants to preserve them.

## Select and inspect the update

Use the revision explicitly requested by the user; otherwise use the latest
`main` from the upstream declared in `.gitmodules`. Fetch that upstream and
resolve the candidate to a full commit SHA. For a branch, resolve its freshly
fetched remote-tracking ref, not a possibly stale local branch. Treat a supplied
ref as a quoted argument, never executable shell text. Fail on an unresolved
or ambiguous ref without changing the checkout. Do not change the upstream URL
or infer that "latest" authorizes updating Tina's other dependencies.

If the candidate is already checked out, report that fact and any unrecorded
gitlink change; do not rerun previously successful checks without a new reason.
If this exact bundle state has no successful validation evidence, run the
checks below before calling it tested.

For a different candidate, review the full dependency diff, focusing on:

- Tina init, incognito, and sync contracts consumed by Univer Craft wrappers;
- installer payload, agents, schema, and target instruction changes;
- `dependencies.env` and changed runtime/tool prerequisites.

Check out the resolved candidate detached, leaving local Tina branches intact.
Keep the submodule unmodified. Capture pre-edit contents before adapting any
Univer Craft wrappers. Adapt them only where the upstream change requires
compatibility work, preserving existing user changes
and Univer Craft's purpose, skill entrypoints, and repository defaults. Keep
dependency versions in Tina's own pins and the parent gitlink.

## Validate and finish

Check prerequisites against the candidate's `dependencies.env`; do not install
or change global software without authorization. Run `./test.sh` from
`$bundle_root` and inspect any changed skill links and initialization/sync
contracts. Validate edited skills using the available skill validator.

On failure or a missing prerequisite, restore the original Tina checkout and
branch/detached state. Revert only this attempt's compatibility edits using
their captured pre-edit contents, preserving earlier parent changes and the
index. If new concurrent edits prevent safe restoration, stop and report them
rather than overwriting them. Report the failing check and prerequisite or
compatibility gap; do not present the candidate as a tested update.

After success, leave the candidate checkout as the proposed gitlink update.
Do not stage, commit, push, or sync targets unless requested. Report old/new
SHAs, compatibility edits, checks, and that the gitlink must be recorded with
the parent commit. For propagation, give the concrete next command
`$univer-craft-sync <target-path>`; execute it only for an authorized target.
