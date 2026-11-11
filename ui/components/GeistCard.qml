// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15

Rectangle {
    id: card

    property bool hoverable: false
    property alias mouseArea: mArea

    color: (hoverable && mArea.containsMouse) ? "#121212" : "#0a0a0a"
    border.color: (hoverable && mArea.containsMouse) ? "#333333" : "#1f1f1f"
    border.width: 1
    radius: 8

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    MouseArea {
        id: mArea
        anchors.fill: parent
        hoverEnabled: card.hoverable
        enabled: card.hoverable
        cursorShape: card.hoverable ? Qt.PointingHandCursor : Qt.ArrowCursor
    }
}
