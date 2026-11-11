// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // Toolbar
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: "All Downloads"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                color: "#ffffff"
            }

            Item { Layout.fillWidth: true }

            GeistButton {
                text: "+ Add Torrent"
                variant: "primary"
            }

            GeistButton {
                text: "Paste Magnet"
                variant: "secondary"
            }

            GeistButton {
                text: "Pause All"
                variant: "secondary"
            }
        }

        // Table Header
        Rectangle {
            Layout.fillWidth: true
            height: 36
            color: "#0d0d0d"
            border.color: "#1f1f1f"
            border.width: 1
            radius: 4

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 12

                Text { text: "STATUS"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 90 }
                Text { text: "NAME"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.fillWidth: true }
                Text { text: "SIZE"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 80 }
                Text { text: "PROGRESS"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 140 }
                Text { text: "DOWN SPEED"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 95 }
                Text { text: "UP SPEED"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 80 }
                Text { text: "ETA"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 60 }
                Text { text: "SEEDS / PEERS"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 100 }
                Text { text: "ACTIONS"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 70 }
            }
        }

        // Torrent Rows
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 6

            model: ListModel {
                ListElement {
                    torrentName: "ubuntu-24.04.1-desktop-amd64.iso"
                    statusText: "DOWNLOADING"
                    statusDot: "#00e599"
                    sizeStr: "5.76 GB"
                    progValue: 0.90
                    progStr: "90.2%"
                    downSpeed: "22.8 MB/s"
                    upSpeed: "1.45 MB/s"
                    etaStr: "27s"
                    peersStr: "84 (312)"
                }
                ListElement {
                    torrentName: "archlinux-2026.11.01-x86_64.iso"
                    statusText: "DOWNLOADING"
                    statusDot: "#00e599"
                    sizeStr: "900 MB"
                    progValue: 0.45
                    progStr: "45.0%"
                    downSpeed: "1.85 MB/s"
                    upSpeed: "420 KB/s"
                    etaStr: "4m 40s"
                    peersStr: "18 (45)"
                }
                ListElement {
                    torrentName: "debian-12.8.0-amd64-netinst.iso"
                    statusText: "SEEDING"
                    statusDot: "#0070f3"
                    sizeStr: "620 MB"
                    progValue: 1.0
                    progStr: "100%"
                    downSpeed: "0 KB/s"
                    upSpeed: "2.10 MB/s"
                    etaStr: "Done"
                    peersStr: "28 (55)"
                }
            }

            delegate: Rectangle {
                width: parent.width
                height: 48
                color: mArea.containsMouse ? "#141414" : "#0a0a0a"
                border.color: mArea.containsMouse ? "#2a2a2a" : "#1a1a1a"
                border.width: 1
                radius: 6

                MouseArea {
                    id: mArea
                    anchors.fill: parent
                    hoverEnabled: true
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12

                    GeistBadge {
                        text: model.statusText
                        dotColor: model.statusDot
                        Layout.preferredWidth: 90
                    }

                    Text {
                        text: model.torrentName
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#ffffff"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: model.sizeStr
                        font.pixelSize: 12
                        font.family: "Consolas, monospace"
                        color: "#888888"
                        Layout.preferredWidth: 80
                    }

                    RowLayout {
                        Layout.preferredWidth: 140
                        spacing: 8
                        GeistProgressBar {
                            Layout.fillWidth: true
                            value: model.progValue
                            barColor: model.statusDot
                        }
                        Text {
                            text: model.progStr
                            font.pixelSize: 11
                            font.family: "Consolas, monospace"
                            color: "#cccccc"
                        }
                    }

                    Text {
                        text: model.downSpeed
                        font.pixelSize: 12
                        font.family: "Consolas, monospace"
                        font.weight: Font.DemiBold
                        color: model.downSpeed.indexOf("22") !== -1 ? "#00e599" : "#ffffff"
                        Layout.preferredWidth: 95
                    }

                    Text {
                        text: model.upSpeed
                        font.pixelSize: 12
                        font.family: "Consolas, monospace"
                        color: "#888888"
                        Layout.preferredWidth: 80
                    }

                    Text {
                        text: model.etaStr
                        font.pixelSize: 12
                        font.family: "Consolas, monospace"
                        color: "#cccccc"
                        Layout.preferredWidth: 60
                    }

                    Text {
                        text: model.peersStr
                        font.pixelSize: 12
                        font.family: "Consolas, monospace"
                        color: "#888888"
                        Layout.preferredWidth: 100
                    }

                    RowLayout {
                        Layout.preferredWidth: 70
                        spacing: 4
                        GeistButton {
                            text: "⏸"
                            implicitWidth: 30
                            implicitHeight: 28
                        }
                        GeistButton {
                            text: "✕"
                            variant: "danger"
                            implicitWidth: 30
                            implicitHeight: 28
                        }
                    }
                }
            }
        }
    }
}
