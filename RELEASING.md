# Releasing

Use this checklist to publish a new version of the Plasma widget.

## Prepare

1. Update `KPlugin.Version` in `io.github.dscafati.lightdarktoggle/metadata.json`.
2. Review the working tree:

   ```bash
   git status --short
   ```

3. Commit the source changes. Do not commit generated `.plasmoid` archives; they are build artifacts and are ignored by `.gitignore`.

## Package

Build the installable archive from the package root so `metadata.json` and `contents/` are at the archive root:

```bash
version=1.1
package=io.github.dscafati.lightdarktoggle
rm -f "${package}-${version}.plasmoid"
cd "$package"
zip -r "../${package}-${version}.plasmoid" metadata.json contents
cd ..
```

Check the archive layout:

```bash
unzip -l "io.github.dscafati.lightdarktoggle-${version}.plasmoid"
```

The listing should show `metadata.json` and `contents/...` directly, without a parent project folder.

## Test

Install or upgrade the local widget package:

```bash
kpackagetool6 --type Plasma/Applet --upgrade "./io.github.dscafati.lightdarktoggle-${version}.plasmoid"
```

If the widget is not installed yet, use `--install` instead of `--upgrade`.

Then restart Plasma if needed:

```bash
kquitapp6 plasmashell && kstart plasmashell
```

Verify the widget from the panel and its configuration dialog.

## Publish

1. Create and push a git tag:

   ```bash
   git tag "v${version}"
   git push origin HEAD --tags
   ```

2. Create a GitHub Release from the tag.
3. Attach `io.github.dscafati.lightdarktoggle-${version}.plasmoid` to the GitHub Release.
4. Upload the same `.plasmoid` file to KDE Store.
5. Include the GitHub repository as the source/homepage link on KDE Store.
