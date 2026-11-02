# plasma-light-dark-toggle fork - agent instructions

## Upstream

This repo is a fork of [dscafati/plasma-light-dark-toggle](https://github.com/dscafati/plasma-light-dark-toggle). The
work branch is `dras`, on top of upstream `master` (`v1.2`). The fork changes the widget's purpose: upstream switches
color schemes, the fork switches global themes and keeps no settings of its own (Plasma has them). An upstream change
is ported by hand, not merged; check what upstream did since the last port:

```bash
git fetch upstream --tags
git log --oneline "$(git merge-base upstream/master HEAD)"..upstream/master
```

Keep the plugin Id `io.github.dscafati.lightdarktoggle`: Plasma stores the panel and system tray entries under it.

## Repo overview

A QML-only Plasma 6 applet, nothing to build. `io.github.dscafati.lightdarktoggle/` is the package: `metadata.json` and
`contents/ui/main.qml`. `install.sh` copies it into `~/.local/share/plasma/plasmoids/`.

## Running

Test without installing and without a window on the user's desktop: put a copy into a temporary data dir that is
searched first, and run it offscreen. QML errors and `console.warn()` output go to stderr.

```bash
d=$(mktemp -d); mkdir -p "$d/plasma/plasmoids"; cp -r io.github.dscafati.lightdarktoggle "$d/plasma/plasmoids/"
XDG_DATA_DIRS="$d:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" QT_QPA_PLATFORM=offscreen \
  timeout 8 plasmawindowed io.github.dscafati.lightdarktoggle
```

A toggle (`plasma-apply-lookandfeel --apply`) changes the user's live desktop: run it only when the user asks.

## Commit conventions

Upstream style: a capitalized imperative subject, and `fork:` for what only makes sense in this fork. Brief bullet-list
bodies. No `Co-Authored-By` or similar trailers. Commits and tags are signed. Release tags are
`v<upstream version>-dras.<n>`, matching `KPlugin.Version` in `metadata.json`, each with a GitHub release and a bullet
changelog.

## Docs

A README states what is, this file states what to do. Plans live in the infra repo, branch `plasma-theme-toggle`, in
`.claude/plans/2026-11-02-plasma-theme-toggle.md`.
