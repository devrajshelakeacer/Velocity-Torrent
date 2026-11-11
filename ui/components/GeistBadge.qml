// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import ".."

Rectangle {
    id: badge

    property string text: "ACTIVE"
    property color dotColor: GeistTheme.accentGreen

    implicitHeight: 26
    implicitWidth: contentRow.implicitWidth + 18
    radius: GeistTheme.radiusPill
    color: GeistTheme.surfaceSubtle
    border.color: GeistTheme.borderCard
    border.width: 1

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 7

        Rectangle {
            width: 7
            height: 7
            radius: 3.5
            color: badge.dotColor
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: badge.text
            font.family: GeistTheme.fontSans
            font.pixelSize: GeistTheme.fontSizeMicro
            font.weight: Font.DemiBold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 0.8
            color: GeistTheme.inkPrimary
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
