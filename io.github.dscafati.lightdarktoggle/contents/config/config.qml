// SPDX-FileCopyrightText: 2026 Diego Scafati <dscafati@gmail.com>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "preferences-desktop-theme"
        source: "configGeneral.qml"
    }
}

