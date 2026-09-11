---
name: univer-craft-init
description: Initialize both Tina Workflow and Univer Craft from this bundle in a new or existing target repository, preserving existing project files. Use when the user asks to install or initialize Univer Craft; use univer-craft-init-incognito for a Git-invisible setup.
---

# Univer Craft Init

Resolve `$bundle_root` to this Univer Craft repository and `$tina_root` to
`$bundle_root/vendor/tina`. Initialize the pinned dependency when absent with
`git -C "$bundle_root" submodule update --init vendor/tina` before reading the
Tina skill. In inherited Tina instructions, the source bundle is `$tina_root`:
read its `dependencies.env` and `templates/AGENTS.md`. Use Univer Craft's
`install-univer-craft.sh` for the combined installation. Require an explicit
target path and never use either source repository as the target.

Read and follow [Tina Init](../../../vendor/tina/.agents/skills/tina-init/SKILL.md)
with the source paths and installer substitution described here.
Apply its source/target resolution, prerequisite checks, conflict handling, and
verification to the combined installation.

Inspect `.agents/skills/univer-craft/` and `.agents/skills/univer-craft-yolo/`
alongside Tina's destinations. Apply the same conflict protection to both,
including references and other nested files. Then run:

```sh
"$bundle_root/install-univer-craft.sh" "$target"
```

Use this command wherever Tina Init calls for running or rerunning `install.sh`.
It preflights the two extension directories, invokes the existing Tina
installer, and copies the extensions. Do not first install Tina separately or
reproduce either installer's copy logic.

Verify Tina's schema and normal installation results, then compare both
installed Univer Craft directories with their bundle sources using `diff -qr`.
The result must contain Tina, `univer-craft`, `univer-craft-yolo`, and the SDK
research reference. Report the combined result and target Git changes; do not
commit or start an application workflow.

These initialization skills stay in the source bundle. Keep the dependency
direction Univer Craft → Tina; do not change Tina Init or Tina's payload to
require the extension.
