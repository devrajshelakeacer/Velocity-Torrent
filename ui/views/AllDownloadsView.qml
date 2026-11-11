// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"
import ".."

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 20

        // Toolbar
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: "All Downloads"
                font.family: GeistTheme.fontSans
                font.pixelSize: GeistTheme.fontSizeTitle
                font.weight: Font.Bold
                color: GeistTheme.inkPrimary
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
            height: 40
            color: GeistTheme.surfaceSubtle
            border.color: GeistTheme.borderCard
            border.width: 1
            radius: GeistTheme.radiusMedium

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 18
                spacing: 14

                Text { text: "STATUS"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 100 }
                Text { text: "NAME"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.fillWidth: true }
                Text { text: "SIZE"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 80 }
                Text { text: "PROGRESS"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 150 }
                Text { text: "DOWN SPEED"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 100 }
                Text { text: "UP SPEED"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 85 }
                Text { text: "ETA"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 65 }
                Text { text: "SEEDS / PEERS"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 105 }
                Text { text: "ACTIONS"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 74 }
            }
        }

        // Torrent Rows
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8

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
                height: 52
                color: mArea.containsMouse ? GeistTheme.surfaceCardHover : GeistTheme.surfaceCard
                border.color: mArea.containsMouse ? GeistTheme.borderHover : GeistTheme.borderCard
                border.width: 1
                radius: GeistTheme.radiusMedium

                Behavior on color { ColorAnimation { duration: 120 } }
                Behavior on border.color { ColorAnimation { duration: 120 } }

                MouseArea {
                    id: mArea
                    anchors.fill: parent
                    hoverEnabled: true
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 18
                    anchors.rightMargin: 18
                    spacing: 14

                    GeistBadge {
                        text: model.statusText
                        dotColor: model.statusDot
                        Layout.preferredWidth: 100
                    }

                    Text {
                        text: model.torrentName
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeBody
                        font.weight: Font.Medium
                        color: GeistTheme.inkPrimary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: model.sizeStr
                        font.family: GeistTheme.fontMono
                        font.pixelSize: GeistTheme.fontSizeMicro
                        color: GeistTheme.inkSecondary
                        Layout.preferredWidth: 80
                    }

                    RowLayout {
                        Layout.preferredWidth: 150
                        spacing: 8
                        GeistProgressBar {
                            Layout.fillWidth: true
                            value: model.progValue
                            barColor: model.statusDot
                        }
                        Text {
                            text: model.progStr
                            font.family: GeistTheme.fontMono
                            font.pixelSize: GeistTheme.fontSizeMicro
                            color: GeistTheme.inkPrimary
                        }
                    }

                    Text {
                        text: model.downSpeed
                        font.family: GeistTheme.fontMono
                        font.pixelSize: GeistTheme.fontSizeSub
                        font.weight: Font.DemiBold
                        color: GeistTheme.inkPrimary
                        Layout.preferredWidth: 100
                    }

                    Text {
                        text: model.upSpeed
                        font.family: GeistTheme.fontMono
                        font.pixelSize: GeistTheme.fontSizeMicro
                        color: GeistTheme.inkSecondary
                        Layout.preferredWidth: 85
                    }

                    Text {
                        text: model.etaStr
                        font.family: GeistTheme.fontMono
                        font.pixelSize: GeistTheme.fontSizeMicro
                        color: GeistTheme.inkPrimary
                        Layout.preferredWidth: 65
                    }

                    Text {
                        text: model.peersStr
                        font.family: GeistTheme.fontMono
                        font.pixelSize: GeistTheme.fontSizeMicro
                        color: GeistTheme.inkSecondary
                        Layout.preferredWidth: 105
                    }

                    RowLayout {
                        Layout.preferredWidth: 74
                        spacing: 6
                        GeistButton {
                            text: "⏸"
                            implicitWidth: 32
                            implicitHeight: 30
                        }
                        GeistButton {
                            text: "✕"
                            variant: "danger"
                            implicitWidth: 32
                            implicitHeight: 30
                        }
                    }
                }
            }
        }
    }
}
