// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15

Rectangle {
    id: badge

    property string text: "ACTIVE"
    property color dotColor: "#00e599"

    implicitHeight: 22
    implicitWidth: contentRow.implicitWidth + 14
    radius: 4
    color: "#111111"
    border.color: "#222222"
    border.width: 1

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 6

        Rectangle {
            width: 7
            height: 7
            radius: 3.5
            color: badge.dotColor
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: badge.text
            font.pixelSize: 10
            font.weight: Font.DemiBold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.0
            color: "#cccccc"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
