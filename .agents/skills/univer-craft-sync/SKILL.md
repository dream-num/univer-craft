---
name: univer-craft-sync
description: Synchronize the current Univer Craft bundle and its pinned Tina dependency to an initialized target repository while preserving customizations. Use when the user asks to update or propagate Univer Craft to another repository, including normal and incognito installations.
---

# Univer Craft Sync

Synchronize one explicit target with the current Univer Craft source and its
checked-out Tina dependency. This skill does not fetch or upgrade Tina; use
`$univer-craft-update-dependencies` first when requested.

## Resolve source, target, and mode

Resolve `$bundle_root` to this Univer Craft repository and `$tina_root` to
`$bundle_root/vendor/tina`. Initialize the recorded submodule if absent with
`git -C "$bundle_root" submodule update --init vendor/tina`.
Require an explicit target Git worktree root outside both source repositories.

Read [Tina Sync](../../../vendor/tina/.agents/skills/tina-sync/SKILL.md).
Apply its baseline capture, source-dirty decision, prerequisite checks, mode
detection, ownership rules, conflict decisions, rollback, and verification to
the combined sync, with the component boundaries below. In inherited Tina
instructions the source bundle is `$tina_root`; check its `dependencies.env`.
Record both source revisions and dirty state, including an unrecorded gitlink
change. For dirty source content, reuse explicit user authorization when given;
otherwise follow Tina Sync's source selection question before writing targets.

Use Tina's recorded or detected target mode. An extension manifest must agree
with it; ask on disagreement or ambiguous evidence, without converting modes.
If Tina is not initialized, route to `$univer-craft-init` or
`$univer-craft-init-incognito` for the requested installation mode. An existing
Tina-only target may receive the Univer Craft skills through this sync.

## Build and partition the desired payload

Run the combined installer in a temporary directory outside both source
repositories and the target:

```sh
"$bundle_root/install-univer-craft.sh" "$staging"
```

Never run the installer or `openspec init` directly in an existing target to
force an upgrade. Use Tina Sync's staged payload selection, plus every file
under the two staged extension directories:

- `.agents/skills/univer-craft/`
- `.agents/skills/univer-craft-yolo/`

Keep those extension files out of Tina's ownership set. Do not copy source-only
maintenance skills, `vendor/tina`, or this repository's root `AGENTS.md`.
Tina owns the schema, agents, OpenSpec config, and its managed instruction block;
Univer Craft adds no target instruction block. Preserve Tina's semantic config
handling and all target application code, artifacts, and unrelated files.

## Track separate ownership and plan together

Resolve the target's worktree Git directory with `git rev-parse --git-dir`.
Keep Tina's manifest at `<git-dir>/tina-workflow/manifest` and the extension
manifest at `<git-dir>/univer-craft/manifest`. Never write extension entries into
Tina's manifest or change Tina's skill to understand Univer Craft.

Use Tina Sync's manifest fields and `managed`/`custom` comparison rules for each
component. The extension manifest records the Univer Craft source revision and
dirty state; Tina's records the Tina source revision and dirty state. Restrict
manifest paths to the component's managed payload roots; stop on paths escaping
those roots, malformed records, or symlinks along a destination path.

For an extension without a manifest, adopt identical files as managed and treat
differences as unknown provenance. Show the focused diff and resolve preserve,
merge, or replace decisions once, unless the user already authorized that exact
resolution. Do not infer permission to overwrite from the sync request alone.
Preserve files with no established ownership. Remove an obsolete file only when
the previous manifest owns it and its installed hash is unchanged; apply Tina's
conflict rules to missing, modified, and custom files.

Preflight both components before writing either. Present unresolved conflicts
together; do not complete Tina sync and only then discover an extension
conflict. Apply safe, authorized updates without asking for another confirmation.

## Apply and verify as one operation

Back up all paths that either component will change, both manifests, and the
local exclude file before applying the combined plan. Track newly created paths
and keep backups until both components pass verification. Reuse Tina's rollback
rules across the whole operation, including restoring both previous manifests
if either manifest write fails. Do not independently finalize Tina first.

In incognito mode, also read the exclusion and instruction preservation rules
in [Univer Craft Init Incognito](../univer-craft-init-incognito/SKILL.md).
Keep Tina's exclusions in its existing block and extension exclusions in
`# univer-craft-incognito:start` / `# univer-craft-incognito:end`.
Preserve valid entries used by other linked worktrees; reject malformed or
unfamiliar entries. Add exact untracked destinations before copying, verify
they are ignored, and remove obsolete entries only when no worktree needs them.
Never rewrite differing tracked files, modify `.gitignore`, or hide changes with
index flags. Preserve root instructions when updating `AGENTS.override.md`.

Complete Tina's schema/default validation. Check each managed extension file
against the desired source and each custom file against its approved result;
an intentional customization is not a failed directory-wide comparison.
Verify preserved target content against the baseline. Normal mode reports the
focused sync diff; incognito mode requires unchanged status, staged/unstaged
diffs, and tracked file content, including affected linked worktrees.

Only then write both manifests atomically per file and discard rollback backups
after both writes succeed. On failure restore only this operation's changes.
Do not stage, commit, push, or start an application workflow unless requested.
Report both source revisions, target/mode, updated or removed files, preserved
customizations, checks, both manifest paths, and any required session restart.
