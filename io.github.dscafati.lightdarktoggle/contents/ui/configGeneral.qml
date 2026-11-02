// SPDX-FileCopyrightText: 2026 Diego Scafati <dscafati@gmail.com>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.plasmoid
import org.kde.iconthemes as KIconThemes
import org.kde.config as KConfig

KCM.SimpleKCM {
    id: configRoot

    property string cfg_iconMode
    // Seed icon values from the saved config (or the main.xml defaults) so the
    // preview buttons show the current icon immediately on first open.
    property string cfg_lightIcon: Plasmoid.configuration.lightIcon
    property string cfg_darkIcon: Plasmoid.configuration.darkIcon

    // Icon chooser dialogs (browse the user's active icon theme)
    KIconThemes.IconDialog {
        id: lightIconDialog
        onIconNameChanged: iconName => { if (iconName) cfg_lightIcon = iconName }
    }

    KIconThemes.IconDialog {
        id: darkIconDialog
        onIconNameChanged: iconName => { if (iconName) cfg_darkIcon = iconName }
    }

    Kirigami.FormLayout {

        // ---- Themes ----
        // Plasma holds these settings, the buttons open its pages
        Kirigami.Separator {
            Kirigami.FormData.label: i18n("Themes")
            Kirigami.FormData.isSection: true
        }

        QQC2.Button {
            Kirigami.FormData.label: i18n("Light and dark theme:")
            text: i18n("Global Theme...")
            icon.name: "preferences-desktop-theme-global"
            enabled: KConfig.KAuthorized.authorizeControlModule("kcm_lookandfeel")
            onClicked: KCM.KCMLauncher.openSystemSettings("kcm_lookandfeel")
        }

        QQC2.Button {
            Kirigami.FormData.label: i18n("Day and night times:")
            text: i18n("Day-Night Cycle...")
            icon.name: "lighttable"
            enabled: KConfig.KAuthorized.authorizeControlModule("kcm_nighttime")
            onClicked: KCM.KCMLauncher.openSystemSettings("kcm_nighttime")
        }

        QQC2.Label {
            Layout.fillWidth: true
            Layout.maximumWidth: Kirigami.Units.gridUnit * 18
            text: i18n("Automatic switching by the time of day is the \"Switch to Dark Mode at Night\" option of the Global Theme page.")
            wrapMode: Text.WordWrap
            font: Kirigami.Theme.smallFont
            opacity: 0.7
        }

        // ---- Panel Icon ----
        Kirigami.Separator {
            Kirigami.FormData.label: i18n("Panel Icon")
            Kirigami.FormData.isSection: true
        }

        QQC2.ComboBox {
            id: iconModeCombo
            Kirigami.FormData.label: i18n("Icon mode:")
            model: [i18n("Show current status"), i18n("Show target action")]
            currentIndex: cfg_iconMode === "target" ? 1 : 0
            onActivated: {
                cfg_iconMode = currentIndex === 1 ? "target" : "status"
            }
        }

        QQC2.Label {
            Layout.fillWidth: true
            Layout.maximumWidth: Kirigami.Units.gridUnit * 18
            text: i18n("Show current status: the icon reflects the scheme that is active now.\nShow target action: the icon reflects what a click will switch to.")
            wrapMode: Text.WordWrap
            font: Kirigami.Theme.smallFont
            opacity: 0.7
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Light Color Scheme Icon:")
            spacing: Kirigami.Units.smallSpacing

            QQC2.Button {
                id: lightIconButton
                implicitWidth: Kirigami.Units.iconSizes.large + Kirigami.Units.smallSpacing * 2
                implicitHeight: implicitWidth
                QQC2.ToolTip.text: i18n("Choose an icon")
                QQC2.ToolTip.visible: hovered
                QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                onClicked: lightIconDialog.open()

                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: Kirigami.Units.iconSizes.large
                    height: width
                    source: cfg_lightIcon
                }
            }

            QQC2.Button {
                text: i18n("Reset")
                icon.name: "edit-undo"
                onClicked: cfg_lightIcon = "weather-clear"
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Dark Color Scheme Icon:")
            spacing: Kirigami.Units.smallSpacing

            QQC2.Button {
                id: darkIconButton
                implicitWidth: Kirigami.Units.iconSizes.large + Kirigami.Units.smallSpacing * 2
                implicitHeight: implicitWidth
                QQC2.ToolTip.text: i18n("Choose an icon")
                QQC2.ToolTip.visible: hovered
                QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                onClicked: darkIconDialog.open()

                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: Kirigami.Units.iconSizes.large
                    height: width
                    source: cfg_darkIcon
                }
            }

            QQC2.Button {
                text: i18n("Reset")
                icon.name: "edit-undo"
                onClicked: cfg_darkIcon = "weather-clear-night"
            }
        }

        QQC2.Label {
            Layout.fillWidth: true
            Layout.maximumWidth: Kirigami.Units.gridUnit * 18
            text: i18n("Icons come from your active icon theme and are recolored automatically. The defaults (weather-clear / weather-clear-night) are freedesktop-standard names available in nearly every theme.")
            wrapMode: Text.WordWrap
            font: Kirigami.Theme.smallFont
            opacity: 0.7
        }
    }
}
