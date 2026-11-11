// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15

Item {
    id: root

    property real value: 0.0 // 0.0 to 1.0
    property color barColor: "#0070f3"

    implicitHeight: 4
    implicitWidth: 120

    Rectangle {
        anchors.fill: parent
        radius: 2
        color: "#1a1a1a"

        Rectangle {
            height: parent.height
            width: Math.max(0, Math.min(parent.width, parent.width * root.value))
            radius: 2
            color: root.barColor

            Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
        }
    }
}
