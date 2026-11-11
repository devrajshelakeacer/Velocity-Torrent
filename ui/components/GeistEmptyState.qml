// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15

Item {
    id: emptyState

    property string title: "No Items"
    property string description: "Nothing to display at this time."
    property string buttonText: ""
    signal actionTriggered()

    implicitHeight: 240
    implicitWidth: 320

    Column {
        anchors.centerIn: parent
        spacing: 12
        width: Math.min(parent.width - 32, 380)

        Rectangle {
            width: 48
            height: 48
            radius: 24
            color: "#111111"
            border.color: "#222222"
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "📁"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
        }

        Text {
            text: emptyState.title
            font.pixelSize: 15
            font.weight: Font.DemiBold
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: emptyState.description
            font.pixelSize: 13
            color: "#888888"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
        }

        GeistButton {
            visible: emptyState.buttonText !== ""
            text: emptyState.buttonText
            variant: "primary"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: emptyState.actionTriggered()
        }
    }
}
