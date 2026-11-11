// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import ".."

Item {
    id: root

    property real value: 0.0 // 0.0 to 1.0
    property color barColor: GeistTheme.accentBlue

    implicitHeight: 6
    implicitWidth: 140

    Rectangle {
        anchors.fill: parent
        radius: 3
        color: GeistTheme.surfaceElevated
        border.color: GeistTheme.borderHairline
        border.width: 1

        Rectangle {
            height: parent.height
            width: Math.max(0, Math.min(parent.width, parent.width * root.value))
            radius: 3
            color: root.barColor

            Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
        }
    }
}
