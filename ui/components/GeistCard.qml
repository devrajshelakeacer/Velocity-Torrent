// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import ".."

Rectangle {
    id: card

    property bool hoverable: false
    property alias mouseArea: mArea

    color: (hoverable && mArea.containsMouse) ? GeistTheme.surfaceCardHover : GeistTheme.surfaceCard
    border.color: (hoverable && mArea.containsMouse) ? GeistTheme.borderHover : GeistTheme.borderCard
    border.width: 1
    radius: GeistTheme.radiusCard

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
