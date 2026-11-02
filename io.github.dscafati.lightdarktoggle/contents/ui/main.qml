// SPDX-FileCopyrightText: 2026 Diego Scafati <dscafati@gmail.com>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick
import QtQml
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCMUtils
import org.kde.config as KConfig

PlasmoidItem {
    id: root

    property bool isDarkMode: false

    // The light and dark global themes, as chosen in System Settings > Global Theme
    property string lightLookAndFeel: "org.kde.breeze.desktop"
    property string darkLookAndFeel: "org.kde.breezedark.desktop"

    // Icons are pulled from the user's active icon theme so they match it
    // automatically. Defaults are freedesktop-standard names present in
    // virtually every theme.
    readonly property string lightIcon: Plasmoid.configuration.lightIcon || "weather-clear"
    readonly property string darkIcon: Plasmoid.configuration.darkIcon || "weather-clear-night"

    Component.onCompleted: updateThemeState()

    // Plasma exposes no "the active global theme changed" signal, but every
    // theme switch repaints the palette, so the palette is our cue to re-read
    // which theme is now active. This keeps the icon in sync with changes made
    // from System Settings or from another instance of this widget, not just
    // with our own toggle.
    Connections {
        target: Kirigami.Theme

        function onColorsChanged() {
            resyncTimer.restart()
        }
    }

    // Coalesces the bursts of colorsChanged that a single theme switch emits,
    // so we read kdeglobals once per switch instead of once per signal.
    Timer {
        id: resyncTimer
        interval: 150
        onTriggered: root.updateThemeState()
    }

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Toggle Light/Dark Theme")
            icon.name: "preferences-desktop-theme-global"
            onTriggered: root.toggleTheme()
        },
        // Plasma holds the theme settings, these open its pages
        PlasmaCore.Action {
            text: i18n("Choose Light and Dark Themes...")
            icon.name: "preferences-desktop-theme-global"
            visible: KConfig.KAuthorized.authorizeControlModule("kcm_lookandfeel")
            onTriggered: KCMUtils.KCMLauncher.openSystemSettings("kcm_lookandfeel")
        },
        PlasmaCore.Action {
            text: i18n("Configure Day-Night Cycle...")
            icon.name: "lighttable"
            visible: KConfig.KAuthorized.authorizeControlModule("kcm_nighttime")
            onTriggered: KCMUtils.KCMLauncher.openSystemSettings("kcm_nighttime")
        }
    ]

    // Reads the active global theme and the light/dark pair, one per line.
    // The defaults are Plasma's own for unset keys.
    function updateThemeState() {
        const keys = [
            ["LookAndFeelPackage", "org.kde.breeze.desktop"],
            ["DefaultLightLookAndFeel", "org.kde.breeze.desktop"],
            ["DefaultDarkLookAndFeel", "org.kde.breezedark.desktop"]
        ]
        themeChecker.connectSource(keys.map(key => root.buildCommand("kreadconfig6", [
            "--file", "kdeglobals",
            "--group", "KDE",
            "--key", key[0],
            "--default", key[1]
        ])).join("; "))
    }

    // DataSource to check the current global theme
    Plasma5Support.DataSource {
        id: themeChecker
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            const lines = (data.stdout || "").trim().split("\n")

            if (lines.length === 3) {
                root.lightLookAndFeel = lines[1]
                root.darkLookAndFeel = lines[2]
                root.isDarkMode = lines[0] === root.darkLookAndFeel
            }

            disconnectSource(source)
        }
    }

    // Names may contain spaces ("My Theme"), so quote every argument:
    // the executable engine splits the command with shell-style rules.
    function buildCommand(cmd, args) {
        if (!args || args.length === 0) {
            return cmd
        }
        const quoted = args.map(arg => "'" + String(arg).replace(/'/g, "'\\''") + "'")
        return cmd + " " + quoted.join(" ")
    }

    // Preferred representation is just the icon
    preferredRepresentation: compactRepresentation

    // Tooltip
    toolTipMainText: i18n("Light/Dark Theme Toggle")
    toolTipSubText: isDarkMode ? i18n("Switch to Light Theme") : i18n("Switch to Dark Theme")

    // Compact representation (icon in panel)
    compactRepresentation: Item {
        id: compactRoot

        Layout.fillWidth: false
        Layout.fillHeight: false
        Layout.minimumWidth: Kirigami.Units.iconSizes.small
        Layout.minimumHeight: Kirigami.Units.iconSizes.small
        Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
        Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium

        Kirigami.Icon {
            id: icon
            anchors.fill: parent
            source: {
                const showTarget = Plasmoid.configuration.iconMode === "target"
                if (showTarget) {
                    // Show target: if dark now, show sun (will switch to light)
                    return root.isDarkMode ? root.lightIcon : root.darkIcon
                } else {
                    // Show status: if dark now, show moon
                    return root.isDarkMode ? root.darkIcon : root.lightIcon
                }
            }
            active: mouseArea.containsMouse

            // Smooth transition when icon changes
            Behavior on source {
                SequentialAnimation {
                    NumberAnimation {
                        target: icon
                        property: "opacity"
                        to: 0
                        duration: 100
                    }
                    PropertyAction {
                        target: icon
                        property: "source"
                    }
                    NumberAnimation {
                        target: icon
                        property: "opacity"
                        to: 1
                        duration: 100
                    }
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                toggleTheme()
            }
        }
    }

    // Full representation (when expanded, though we don't really need it)
    fullRepresentation: Item {
        Layout.preferredWidth: Kirigami.Units.gridUnit * 12
        Layout.preferredHeight: Kirigami.Units.gridUnit * 8

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Kirigami.Units.largeSpacing

            Kirigami.Icon {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: Kirigami.Units.iconSizes.huge
                Layout.preferredHeight: Kirigami.Units.iconSizes.huge
                source: root.isDarkMode ? root.darkIcon : root.lightIcon
            }

            Kirigami.Heading {
                Layout.alignment: Qt.AlignHCenter
                text: root.isDarkMode ? i18n("Dark Theme Active") : i18n("Light Theme Active")
                level: 2
            }

            QQC2.Button {
                Layout.alignment: Qt.AlignHCenter
                text: root.isDarkMode ? i18n("Switch to Light Theme") : i18n("Switch to Dark Theme")
                icon.name: root.isDarkMode ? root.lightIcon : root.darkIcon
                onClicked: {
                    toggleTheme()
                }
            }
        }
    }

    // Switches the global theme, so a theme like Breeze Twilight (light colors,
    // dark Plasma style) is applied whole. --keep-auto leaves the automatic
    // day-night switching on: it takes over again at the next transition.
    function toggleTheme() {
        const target = root.isDarkMode ? root.lightLookAndFeel : root.darkLookAndFeel
        executable.exec("plasma-apply-lookandfeel", ["--keep-auto", "--apply", target])
    }

    // DataEngine for executing commands (Plasma 6 uses Plasma5Support)
    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            disconnectSource(source)

            // Update the theme state after switching. The palette watcher
            // above usually beats us to it, but re-read anyway in case the two
            // themes share a palette.
            resyncTimer.restart()
        }

        function exec(cmd, args) {
            connectSource(root.buildCommand(cmd, args))
        }
    }
}
