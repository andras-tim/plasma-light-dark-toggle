// SPDX-FileCopyrightText: 2026 Diego Scafati <dscafati@gmail.com>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property bool isDarkMode: false

    // Icons are pulled from the user's active icon theme so they match it
    // automatically. Defaults are freedesktop-standard names present in
    // virtually every theme.
    readonly property string lightIcon: Plasmoid.configuration.lightIcon || "weather-clear"
    readonly property string darkIcon: Plasmoid.configuration.darkIcon || "weather-clear-night"

    Component.onCompleted: updateColorSchemeState()

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Toggle Color Scheme")
            icon.name: "preferences-desktop-theme-global"
            onTriggered: root.toggleColorScheme()
        }
    ]

    // Function to check current color scheme
    function updateColorSchemeState() {
        colorSchemeChecker.exec("plasma-apply-colorscheme", ["--list-schemes"])
    }

    // DataSource to check current color scheme
    Plasma5Support.DataSource {
        id: colorSchemeChecker
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            const output = data.stdout || ""
            const configuredDarkTheme = Plasmoid.configuration.darkTheme || "BreezeDark"

            // Match the exact line for the configured dark theme followed by "(current"
            isDarkMode = false
            for (const line of output.split('\n')) {
                const match = line.match(/^\s*\*\s+(.+?)\s+\(current/)
                if (match && match[1] === configuredDarkTheme) {
                    isDarkMode = true
                    break
                }
            }

            disconnectSource(source)
        }

        function exec(cmd, args) {
            const fullCommand = args && args.length > 0 ? cmd + " " + args.join(" ") : cmd
            connectSource(fullCommand)
        }
    }

    // Preferred representation is just the icon
    preferredRepresentation: compactRepresentation

    // Tooltip
    toolTipMainText: i18n("Light/Dark Color Scheme Toggle")
    toolTipSubText: isDarkMode ? i18n("Switch to Light Colors") : i18n("Switch to Dark Colors")

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
                toggleColorScheme()
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
                text: root.isDarkMode ? i18n("Dark Colors Active") : i18n("Light Colors Active")
                level: 2
            }

            QQC2.Button {
                Layout.alignment: Qt.AlignHCenter
                text: root.isDarkMode ? i18n("Switch to Light Colors") : i18n("Switch to Dark Colors")
                icon.name: root.isDarkMode ? root.lightIcon : root.darkIcon
                onClicked: {
                    toggleColorScheme()
                }
            }
        }
    }

    // Function to toggle between dark and light color schemes
    function toggleColorScheme() {
        // Switch only color schemes, not the entire theme
        const lightColorScheme = Plasmoid.configuration.lightTheme || "BreezeLight"
        const darkColorScheme = Plasmoid.configuration.darkTheme || "BreezeDark"
        
        const targetColorScheme = root.isDarkMode ? lightColorScheme : darkColorScheme
        
        // Execute the command to switch color schemes
        // Use plasma-apply-colorscheme for Plasma 6
        executable.exec("plasma-apply-colorscheme", [targetColorScheme])
    }

    // DataEngine for executing commands (Plasma 6 uses Plasma5Support)
    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            disconnectSource(source)
            
            // Update the color scheme state after switching
            Qt.callLater(updateColorSchemeState)
        }

        function exec(cmd, args) {
            const fullCommand = args && args.length > 0 ? cmd + " " + args.join(" ") : cmd
            connectSource(fullCommand)
        }
    }
}

