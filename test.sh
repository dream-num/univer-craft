#!/bin/sh
set -eu

CRAFT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
for skill in tina-init tina-init-incognito tina-sync; do
  test -f "$CRAFT_ROOT/vendor/tina/.agents/skills/$skill/SKILL.md"
done
"$CRAFT_ROOT/vendor/tina/test.sh"

TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/univer-craft.XXXXXX")
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM

CRAFT_PROJECT="$TEST_ROOT/univer app"
"$CRAFT_ROOT/install-univer-craft.sh" "$CRAFT_PROJECT" >/dev/null
printf '%s\n' '{"packageManager":"npm@10.0.0"}' > "$CRAFT_PROJECT/package.json"
cp "$CRAFT_PROJECT/package.json" "$TEST_ROOT/original-package.json"
"$CRAFT_ROOT/install-univer-craft.sh" "$CRAFT_PROJECT" >/dev/null
cmp "$TEST_ROOT/original-package.json" "$CRAFT_PROJECT/package.json"
for skill in univer-craft univer-craft-yolo; do
  diff -qr "$CRAFT_ROOT/skills/$skill" "$CRAFT_PROJECT/.agents/skills/$skill"
done

# The combined installation must preserve Tina's complete installed payload.
"$CRAFT_ROOT/vendor/tina/install.sh" "$TEST_ROOT/tina-only" >/dev/null
for skill in univer-craft univer-craft-yolo; do
  test ! -e "$TEST_ROOT/tina-only/.agents/skills/$skill"
  rm -r "$CRAFT_PROJECT/.agents/skills/$skill"
done
rm "$CRAFT_PROJECT/package.json"
diff -qr "$TEST_ROOT/tina-only" "$CRAFT_PROJECT"

# A missing dependency fails before creating the target.
mkdir "$TEST_ROOT/missing-dependency"
cp "$CRAFT_ROOT/install-univer-craft.sh" "$TEST_ROOT/missing-dependency/"
if "$TEST_ROOT/missing-dependency/install-univer-craft.sh" "$TEST_ROOT/untouched" >/dev/null 2>&1; then
  echo "Installer accepted a missing Tina dependency" >&2
  exit 1
fi
test ! -e "$TEST_ROOT/untouched"

CRAFT_CONFLICT="$TEST_ROOT/craft-conflict"
mkdir -p "$CRAFT_CONFLICT/.agents/skills"
printf '%s\n' 'local skill' > "$TEST_ROOT/local-skill"
for skill in univer-craft univer-craft-yolo; do
  mkdir "$CRAFT_CONFLICT/.agents/skills/$skill"
  cp "$TEST_ROOT/local-skill" "$CRAFT_CONFLICT/.agents/skills/$skill/SKILL.md"
  if "$CRAFT_ROOT/install-univer-craft.sh" "$CRAFT_CONFLICT" >/dev/null 2>&1; then
    echo "Installer overwrote a conflicting $skill skill" >&2
    exit 1
  fi
  cmp "$TEST_ROOT/local-skill" "$CRAFT_CONFLICT/.agents/skills/$skill/SKILL.md"
  test ! -e "$CRAFT_CONFLICT/openspec"
  rm "$CRAFT_CONFLICT/.agents/skills/$skill/SKILL.md"
  rmdir "$CRAFT_CONFLICT/.agents/skills/$skill"
done
test ! -e "$CRAFT_CONFLICT/.agents/skills/univer-craft"

ln -s "$CRAFT_ROOT/skills/univer-craft" "$CRAFT_CONFLICT/.agents/skills/univer-craft"
if "$CRAFT_ROOT/install-univer-craft.sh" "$CRAFT_CONFLICT" >/dev/null 2>&1; then
  echo "Installer accepted a symlinked Univer Craft skill" >&2
  exit 1
fi
test -L "$CRAFT_CONFLICT/.agents/skills/univer-craft"
test ! -e "$CRAFT_CONFLICT/openspec"

echo "Univer Craft smoke test passed"
