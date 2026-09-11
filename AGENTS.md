# Univer Craft Repository Instructions

Univer Craft researches the Univer Office SDK and routes Univer App work through
Tina. Preserve normal stage dispatch, autonomous YOLO behavior, existing init
skill names, and the new-project `src/` default.

- Keep dependencies one-way: Univer Craft depends on Tina. Tina must not depend
  on or contain Univer Craft-specific policy.
- Treat `vendor/tina` as an unmodified, pinned Git submodule. Upgrade its revision
  with Git, review the dependency diff, and run `./test.sh` before recording a
  new pin. Keep compatibility policy in Univer Craft wrappers.
- Read Tina's own initialization and sync skills from the submodule. Do not
  duplicate its installation engine, agents, schema, upstream pins, or workflow.
- Keep init, dependency-update, and sync skills in `.agents/skills/`, and target
  skills in `skills/`.
  Never copy this root `AGENTS.md` into a target project.
- Preserve installer conflicts, target-owned content, and the incognito contract:
  unchanged tracked content/status and separate local exclude ownership.
- Run `./test.sh` after skill or installer changes and Tina dependency updates.
  Add focused behavioral checks when needed; avoid tests that match prose.
