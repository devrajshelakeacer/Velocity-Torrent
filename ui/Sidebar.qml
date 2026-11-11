// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "components"
import "."

Rectangle {
    id: sidebar

    property int currentViewIndex: 0
    signal viewSelected(int index)

    width: 240
    color: "#050505"
    border.color: GeistTheme.borderHairline
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 16

        // Brand Title (Vercel Style Minimalist Header)
        RowLayout {
            spacing: 10
            Rectangle {
                width: 32
                height: 32
                radius: GeistTheme.radiusMedium
                color: GeistTheme.accentBlue
                Text {
                    text: "▲"
                    font.pixelSize: 14
                    color: "#ffffff"
                    anchors.centerIn: parent
                }
            }
            Column {
                spacing: 2
                Text {
                    text: "VELOCITY"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeMedium
                    font.weight: Font.Bold
                    font.letterSpacing: 1.5
                    color: GeistTheme.inkPrimary
                }
                Text {
                    text: "Intelligent Torrenting"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeMicro
                    color: GeistTheme.inkSecondary
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: GeistTheme.borderHairline
        }

        // Navigation Item List
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4

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
                height: 40
                radius: GeistTheme.radiusMedium
                color: (sidebar.currentViewIndex === model.viewId) ? "#161616" : (mArea.containsMouse ? "#0f0f0f" : "transparent")
                border.color: (sidebar.currentViewIndex === model.viewId) ? GeistTheme.borderCard : "transparent"
                border.width: 1

                Behavior on color { ColorAnimation { duration: 100 } }

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
                    spacing: 12

                    Text {
                        text: model.icon
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        text: model.name
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeSub
                        font.weight: (sidebar.currentViewIndex === model.viewId) ? Font.DemiBold : Font.Normal
                        color: (sidebar.currentViewIndex === model.viewId) ? "#ffffff" : (mArea.containsMouse ? "#e5e5e5" : "#888888")
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                    }
                }
            }
        }

        // Bottom System Status Indicator
        Rectangle {
            Layout.fillWidth: true
            height: 38
            radius: GeistTheme.radiusMedium
            color: GeistTheme.surfaceCard
            border.color: GeistTheme.borderHairline
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                Rectangle {
                    width: 7; height: 7; radius: 3.5
                    color: GeistTheme.accentGreen
                }

                Text {
                    text: "Engine Online (v1.0.0)"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeMicro
                    color: GeistTheme.inkSecondary
                }
            }
        }
    }
}
