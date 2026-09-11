# Univer Craft

Univer Craft helps build Univer Apps using Tina. It researches the Univer Office
SDK layers needed by a request and routes work to the appropriate Tina stage.
Normal mode handles research, planning, implementation, or verification as
requested. YOLO delegates the complete requested outcome to Tina YOLO.

New apps default to pnpm and TypeScript, with application source code in the
project root's `src/` unless the user explicitly specifies another location.
Existing apps retain their stack and directory conventions. The
[SDK research map](skills/univer-craft/references/univer-sdk.md) covers Web,
Server, and AI SDK boundaries; the skills require current, task-specific
research before implementing unfamiliar SDK integrations.

## Initialize a target

After cloning this repository, initialize its pinned Tina dependency:

```sh
git submodule update --init vendor/tina
```

Open this repository in Codex and use the existing skill entrypoints:

```text
$univer-craft-init /absolute/path/to/target-repository
$univer-craft-init-incognito /absolute/path/to/target-repository
```

Both install Tina and the `univer-craft` / `univer-craft-yolo` skills, including
the SDK research reference. The initialization skills remain in this source
repository. OpenSpec must be available; the tested version is defined only in
`vendor/tina/dependencies.env`. Initialization does not install global software.

Normal installation also has a shell entrypoint:

```sh
./install-univer-craft.sh /absolute/path/to/target-repository
```

The installer checks both extension destinations before invoking Tina's own
installer, then copies the Univer Craft skills. Identical content is reused;
differing content blocks installation and remains untouched.

Incognito mode requires a Git worktree root. The skill stages the combined
installation outside the target, preserves tracked content and Git status,
and keeps Tina and Univer Craft exclusions in separate local Git exclude
blocks. It preserves root instructions in `AGENTS.override.md`. Start a new
Codex session after installation; refresh a derived override when the target's
root `AGENTS.md` changes.

In the target repository, usage stays the same:

```text
$univer-craft 研究现有应用接入 Univer 协同和自有权限系统需要哪些 SDK，并给出下一步指令
$univer-craft-yolo 在这个新仓库构建支持本地编辑和保存的 Univer Sheets App
```

## Upgrade Tina

`vendor/tina` is an unmodified Git submodule of
[Tina](https://github.com/yangluoshen/tina). This repository's gitlink pins the
exact tested commit. Tina owns its installer, schema, agents, upstream pins,
and workflow; Univer Craft owns its SDK guidance and combined installation.
Tina's core workflow does not load or require Univer Craft.

In this source repository, ask Codex to update and validate the dependency:

```text
$univer-craft-update-dependencies
$univer-craft-update-dependencies <Tina tag, branch, or commit>
```

The default is upstream `main`. The skill reviews compatibility, runs the bundle
checks, and restores the previous checkout if the candidate fails validation.
It preserves local edits and leaves the tested gitlink change for a parent
commit. It does not update installed target repositories automatically.

The equivalent manual update starts with a clean submodule:

```sh
git submodule update --init --remote vendor/tina
./test.sh
git diff --submodule=log -- vendor/tina
```

Review the dependency diff and any changed initialization/sync contracts before
committing the new gitlink with `git add vendor/tina`. For a selected release or
commit, fetch in `vendor/tina` and check out that revision instead of using
`--remote`. If validation fails, keep the old pin; `git submodule update --init
vendor/tina` restores the recorded revision when the submodule has no local edits.
Compatibility changes belong in Univer Craft's wrappers, never inside Tina.

## Sync an existing target

From this source repository, use:

```text
$univer-craft-sync /absolute/path/to/target-repository
```

This syncs both Univer Craft and its current Tina dependency. It detects normal
or incognito mode, checks both components before applying changes, preserves
target customizations, and keeps their ownership manifests and exclude blocks
separate. Source-only init, dependency-update, and sync skills stay here.
An update to the dependency pin does not change existing targets until sync.

For a Tina-only update, ask Codex to follow
[`vendor/tina/.agents/skills/tina-sync/SKILL.md`](vendor/tina/.agents/skills/tina-sync/SKILL.md)
with that target's explicit path. It handles normal and incognito installations,
preserves target customizations, and manages only Tina's payload. Do not rerun
the initializer to overwrite an older installation. Preserve Univer Craft's
exclude block during a Tina-only sync or removal.
Univer Craft requires Tina to remain installed.

## Maintenance

- `.agents/skills/`: source-repository init, dependency-update, and sync skills.
- `skills/univer-craft*/`: target skills and SDK research guidance.
- `install-univer-craft.sh`: combined installer using `vendor/tina/install.sh`.
- `vendor/tina`: pinned Tina dependency; update through Git submodule commands.
- `test.sh`: Tina smoke tests and combined installation compatibility checks.

Run `./test.sh` after changing skills, installation, or the Tina pin. It requires
Git, Node.js, and OpenSpec as specified by the pinned Tina bundle.
