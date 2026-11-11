// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "components"

Rectangle {
    id: sidebar

    property int currentViewIndex: 0
    signal viewSelected(int index)

    width: 220
    color: "#050505"
    border.color: "#1a1a1a"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Brand Title
        RowLayout {
            spacing: 8
            Rectangle {
                width: 28; height: 28; radius: 6; color: "#0070f3"
                Text { text: "V"; font.pixelSize: 16; font.weight: Font.Bold; color: "#ffffff"; anchors.centerIn: parent }
            }
            Column {
                spacing: 1
                Text { text: "VELOCITY"; font.pixelSize: 14; font.weight: Font.Bold; font.letterSpacing: 1.2; color: "#ffffff" }
                Text { text: "Intelligent Torrenting"; font.pixelSize: 10; color: "#888888" }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#1a1a1a" }

        // Navigation Item List
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 3

            model: ListModel {
                ListElement { name: "Dashboard"; icon: "📊"; viewId: 0 }
                ListElement { name: "All Downloads"; icon: "📥"; viewId: 1 }
                ListElement { name: "Torrent Details"; icon: "🔍"; viewId: 2 }
                ListElement { name: "Peer Explorer"; icon: "🌐"; viewId: 3 }
                ListElement { name: "Network Monitor"; icon: "📡"; viewId: 4 }
                ListElement { name: "V200 Performance"; icon: "⚡"; viewId: 5 }
                ListElement { name: "V-FORCE Center"; icon: "🚀"; viewId: 6 }
                ListElement { name: "V-SHIELD Security"; icon: "🛡️"; viewId: 7 }
                ListElement { name: "Intelligence"; icon: "🧠"; viewId: 8 }
                ListElement { name: "Settings"; icon: "⚙️"; viewId: 9 }
                ListElement { name: "History"; icon: "📜"; viewId: 10 }
                ListElement { name: "About & Legal"; icon: "ℹ️"; viewId: 11 }
            }

            delegate: Rectangle {
                width: parent.width
                height: 36
                radius: 6
                color: (sidebar.currentViewIndex === model.viewId) ? "#161616" : (mArea.containsMouse ? "#0f0f0f" : "transparent")
                border.color: (sidebar.currentViewIndex === model.viewId) ? "#2a2a2a" : "transparent"
                border.width: 1

                MouseArea {
                    id: mArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sidebar.viewSelected(model.viewId)
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    Text {
                        text: model.icon
                        font.pixelSize: 13
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: model.name
                        font.pixelSize: 13
                        font.weight: (sidebar.currentViewIndex === model.viewId) ? Font.DemiBold : Font.Normal
                        color: (sidebar.currentViewIndex === model.viewId) ? "#ffffff" : (mArea.containsMouse ? "#cccccc" : "#888888")
                        anchors.verticalCenter: parent.verticalCenter
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
