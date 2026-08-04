<p align="center">
  <img src="logo.png" alt="Light/Dark Color Scheme Toggle logo" width="160"/>
</p>

# Light/Dark Color Scheme Toggle

A minimal KDE Plasma 6 panel widget that switches your color scheme between light and dark with a single click.

Unlike switching Global Themes, this only applies a color scheme, so it leaves your Plasma style, icon theme, window decorations, cursors, and other desktop settings alone.

![License](https://img.shields.io/badge/license-GPL--2.0--or--later-blue.svg)
![Plasma](https://img.shields.io/badge/Plasma-6.0%2B-1d99f3.svg)

## Screenshots

![Panel — light & dark modes](screenshots/panel.png)

![Settings dialog](screenshots/config.png)

## Features

- One-click toggle between any two installed color schemes (defaults: `BreezeLight` / `BreezeDark`).
- Pick which schemes count as "light" and "dark" in the widget settings.
- Choose custom light and dark panel icons from your active icon theme.
- Choose whether the panel icon shows the **current state** (moon when dark) or the **target action** (sun when dark, to indicate clicking will switch to light).
- Stays in sync with the active color scheme. If you change schemes from System Settings, from a shortcut, or from a second copy of this widget, every instance updates its icon immediately.
- Exposes a `Toggle Color Scheme` action, so you can bind a global keyboard shortcut to it via *System Settings → Shortcuts*.

## Requirements

- KDE Plasma 6.0 or newer
- `plasma-apply-colorscheme` (ships with Plasma)

## Install

### From source

```bash
git clone https://github.com/dscafati/plasma-light-dark-toggle.git
cd plasma-light-dark-toggle
./install.sh
```

Then reload Plasma so the chooser sees the new widget:

```bash
kquitapp6 plasmashell && kstart plasmashell
```

Right-click your panel → *Add Widgets…* → search **Light/Dark Color Scheme Toggle** → drag it to the panel.

### Manual install

```bash
kpackagetool6 --type Plasma/Applet --install io.github.dscafati.lightdarktoggle
```

To upgrade an existing install, replace `--install` with `--upgrade`.

### Test without adding to the panel

```bash
plasmoidviewer6 -a io.github.dscafati.lightdarktoggle
```

## Configuration

Right-click the widget → *Configure Light/Dark Color Scheme Toggle…*

| Setting | Description |
|---|---|
| **Light Color Scheme** | The scheme used when toggling to "light". |
| **Dark Color Scheme** | The scheme used when toggling to "dark". |
| **Light Icon** | The icon shown for the light scheme. |
| **Dark Icon** | The icon shown for the dark scheme. |
| **Icon Mode** | `Show Current Status` — the icon mirrors what is active. `Show Target Action` — the icon shows what clicking will switch *to*. |

The color scheme dropdowns are populated from `plasma-apply-colorscheme --list-schemes`, so any color scheme installed on your system is available. Icons come from your active icon theme.

## Maintainers

See [RELEASING.md](RELEASING.md) for the release and KDE Store upload checklist.

## Uninstall

```bash
kpackagetool6 --type Plasma/Applet --remove io.github.dscafati.lightdarktoggle
```

Or simply remove the directory:

```bash
rm -rf ~/.local/share/plasma/plasmoids/io.github.dscafati.lightdarktoggle
```

## Credits

The logo and the in-widget sun/moon icons are derived from the [Breeze icon theme](https://invent.kde.org/frameworks/breeze-icons) (`weather-clear.svg` and `weather-clear-night.svg`), © 2014 Uri Herrera and the KDE community, released under the GNU Lesser General Public License v3.0 or later.

## License

The widget itself is released under the [GNU General Public License v2.0 or later](LICENSE). Bundled Breeze icons retain their original LGPL-3.0-or-later license.
