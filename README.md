<p align="center">
  <img src="logo.png" alt="Light/Dark Theme Toggle logo" width="160"/>
</p>

# Light/Dark Theme Toggle

A minimal KDE Plasma 6 panel widget that switches between the light and the dark global theme with a single click.

Plasma already knows which global theme is the light and which is the dark one, and it can switch between them by the
time of day. What it lacks is a manual switch: this widget is that switch.

A fork of [dscafati/plasma-light-dark-toggle](https://github.com/dscafati/plasma-light-dark-toggle), which switches
color schemes. It switches global themes instead, so a theme like Breeze Twilight (light colors with a dark Plasma
style), which has no color scheme of its own, is applied whole.

![License](https://img.shields.io/badge/license-GPL--2.0--or--later-blue.svg)
![Plasma](https://img.shields.io/badge/Plasma-6.5%2B-1d99f3.svg)

## Screenshots

![Panel - light & dark modes](screenshots/panel.png)

## Features

- One-click switch between the light and the dark global theme chosen in *System Settings > Global Theme*.
- Leaves the automatic day-night switching on: a manual switch holds until the next day-night transition.
- Stays in sync with the active theme: a switch made anywhere else updates the icon too.
- An "A" in the icon's bottom-right corner shows that the automatic day-night switching is on.
- Choose custom light and dark panel icons from your active icon theme, and whether the icon shows the **current
  state** (moon when dark) or the **target action** (sun when dark).
- The context menu and the widget settings open the two System Settings pages that hold the theme configuration.

## Configuration

Right-click the widget → *Configure Light/Dark Theme Toggle…*

| Setting | Description |
|---|---|
| **Light and dark theme** | Button: opens *Global Theme* (`kcm_lookandfeel`), where the light and the dark theme are chosen and *Switch to Dark Mode at Night* is turned on. Also in the context menu: *Choose Light and Dark Themes...* |
| **Day and night times** | Button: opens *Day-Night Cycle* (`kcm_nighttime`), when day and night begin. Also in the context menu: *Configure Day-Night Cycle...* |
| **Icon Mode** | `Show Current Status`: the icon mirrors what is active. `Show Target Action`: the icon shows what clicking will switch *to*. |
| **Light Icon** | The icon shown for the light theme. |
| **Dark Icon** | The icon shown for the dark theme. |

## Requirements

- KDE Plasma 6.5 or newer (the light/dark theme pair and the Day-Night Cycle page)
- `plasma-apply-lookandfeel` and `kreadconfig6` (they ship with Plasma)

## Install

### From source

```bash
git clone https://github.com/andras-tim/plasma-light-dark-toggle.git
cd plasma-light-dark-toggle
./install.sh
```

Then reload Plasma so the chooser sees the new widget:

```bash
kquitapp6 plasmashell && kstart plasmashell
```

Right-click your panel → *Add Widgets…* → search **Light/Dark Theme Toggle** → drag it to the panel. The widget also
lists itself in the system tray: *System Tray Settings → Entries*.

### Manual install

```bash
kpackagetool6 --type Plasma/Applet --install io.github.dscafati.lightdarktoggle
```

To upgrade an existing install, replace `--install` with `--upgrade`.

### Test without adding to the panel

```bash
plasmawindowed io.github.dscafati.lightdarktoggle
```

## Uninstall

```bash
kpackagetool6 --type Plasma/Applet --remove io.github.dscafati.lightdarktoggle
```

Or simply remove the directory:

```bash
rm -rf ~/.local/share/plasma/plasmoids/io.github.dscafati.lightdarktoggle
```

## Credits

The original widget is by [Diego Scafati](https://github.com/dscafati). The logo and the in-widget sun/moon icons are
derived from the [Breeze icon theme](https://invent.kde.org/frameworks/breeze-icons) (`weather-clear.svg` and
`weather-clear-night.svg`), © 2014 Uri Herrera and the KDE community, released under the GNU Lesser General Public
License v3.0 or later.

## License

The widget itself is released under the [GNU General Public License v2.0 or later](LICENSE). Bundled Breeze icons retain
their original LGPL-3.0-or-later license.
