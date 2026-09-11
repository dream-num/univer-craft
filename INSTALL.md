# Install Univer Craft from the target repository

Open the target repository in Codex and send:

```text
请读取 https://raw.githubusercontent.com/dream-num/univer-craft/main/INSTALL.md，将 Univer Craft 安装到当前仓库。
```

For local-only installation, append `使用 incognito 模式，保持 Git 状态不变。`
To select another target, replace `当前仓库` with its absolute path. This URL
becomes usable once the repository and this guide are published; until then,
give Codex the absolute path to a local checkout's `INSTALL.md`.

## Instructions for the installing agent

This guide installs both Univer Craft and its pinned Tina dependency. Read the
initialization skills as files from the acquired checkout; they do not need to
be installed or discovered in the current session first.

### Resolve target and acquire source

Resolve the user's target to an absolute `$target` before changing directories.
"Current repository" selects the current project/worktree root and satisfies
the init skill's explicit-target requirement. Ask only if that identity is
ambiguous. Read the target instructions and capture its existing changes.
Default to normal mode; select incognito for an explicit incognito, local-only,
or unchanged-Git-status request. It requires a Git worktree root. Preserve an
existing incognito installation's mode on a generic rerun.

Use a local Univer Craft checkout explicitly supplied by the user, or clone
`https://github.com/dream-num/univer-craft.git` into a temporary directory outside
the target. Use the requested ref, defaulting to upstream `main`, and record the
resolved full SHA. Read this guide and the selected init skill from that same
revision; do not mix files from different refs. Set `$bundle_root` to the clone.
For a supplied dirty checkout, use already-given authorization or ask whether
to use the uncommitted contents, record that state, and preserve local edits.

Initialize Tina at the recorded gitlink, without following its latest branch:

```sh
git -C "$bundle_root" submodule update --init vendor/tina
```

Set `$tina_root` to `$bundle_root/vendor/tina` and record its full commit SHA.
For a reused checkout, require the Tina checkout to match the recorded gitlink
and be unmodified; do not reset local edits or silently mix dependency versions.
Keep clones, tool directories, and staging paths outside the target.

### Supply the pinned CLI and follow the existing initialization skill

Require Git, Node.js, and npm. Read the OpenSpec pin from Tina's own
`dependencies.env`. Use a fresh empty `$tool_run` directory outside both source
repositories and the target for isolated package execution:

```sh
. "$tina_root/dependencies.env"
cd "$tool_run"
npm exec --yes --package="$OPENSPEC_PACKAGE@$OPENSPEC_VERSION" -- openspec --version
```

Require the reported version to equal the pin. This supplies the init skill's
OpenSpec prerequisite without a global installation. Prefix every installer
and later OpenSpec invocation with this same package selection; the installer
inherits the CLI through `PATH`. Do not use `latest`, install global software,
or change target package dependencies to obtain the installation tool.

- Normal: read `.agents/skills/univer-craft-init/SKILL.md` from `$bundle_root`,
  then the pinned Tina skill it references, and follow the combined procedure.
  Its installer invocation becomes:

  ```sh
  npm exec --yes --package="$OPENSPEC_PACKAGE@$OPENSPEC_VERSION" -- "$bundle_root/install-univer-craft.sh" "$target"
  ```

- Incognito: read `.agents/skills/univer-craft-init-incognito/SKILL.md` and its
  pinned Tina reference. Apply their combined staging, conflict protection,
  separate local exclude blocks, instruction preservation, and rollback. Use
  the same `npm exec` prefix for the staging installer; never run the installer
  or `openspec init` directly against the target in this mode.

Run later OpenSpec validation from `$tool_run` with the target as the child
shell's working directory:

```sh
npm exec --yes --package="$OPENSPEC_PACKAGE@$OPENSPEC_VERSION" -- sh -c 'cd "$1" && openspec schema validate tina --verbose && openspec schema which tina' sh "$target"
```

Check both installed extension directories against their source, and complete
Tina's mode-specific verification.

Preserve target customizations and the skills' conflict decisions. Do not copy
source-only maintenance skills, either source root's `AGENTS.md`, or the
submodule into the target. Do not commit, deploy, or launch an app workflow.
After successful verification, remove only this attempt's temporary paths and
keep any supplied checkout. Report both SHAs, absolute target, mode, checks,
and blockers. Tell the user to start a new Codex session for the installed
skills and instructions, including any incognito override snapshot caveat.
