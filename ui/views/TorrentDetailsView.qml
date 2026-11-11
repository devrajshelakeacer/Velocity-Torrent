// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"
import ".."

Item {
    id: root

    property string torrentName: "ubuntu-24.04.1-desktop-amd64.iso"
    property string infoHash: "e5893a77d853106198f7e6e5894101e405a2e566"
    property string savePath: "D:/Downloads/ubuntu-24.04.1-desktop-amd64.iso"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 20

        // Header Title
        RowLayout {
            Layout.fillWidth: true
            spacing: 14
            ColumnLayout {
                spacing: 4
                Text {
                    text: root.torrentName
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeTitle
                    font.weight: Font.Bold
                    color: GeistTheme.inkPrimary
                }
                Text {
                    text: "Hash: " + root.infoHash + " | Path: " + root.savePath
                    font.family: GeistTheme.fontMono
                    font.pixelSize: GeistTheme.fontSizeMicro
                    color: GeistTheme.inkSecondary
                }
            }
            Item { Layout.fillWidth: true }
            GeistBadge {
                text: "90.2% COMPLETE"
                dotColor: GeistTheme.accentGreen
            }
        }

        // Details Grid Cards
        RowLayout {
            Layout.fillWidth: true
            spacing: 18

            GeistCard {
                Layout.fillWidth: true
                height: 96
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 4
                    Text { text: "VERIFIED PIECES"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary }
                    Text { text: "2,309 / 2,560 (4 MiB each)"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMedium; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                    Text { text: "0 bad blocks detected | 100% hash integrity"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                }
            }

            GeistCard {
                Layout.fillWidth: true
                height: 96
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 4
                    Text { text: "ACTIVE TRACKERS"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary }
                    Text { text: "4 Working (Tier 0 & 1)"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMedium; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                    Text { text: "torrent.ubuntu.com:6969 [UDP Announce OK]"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                }
            }

            GeistCard {
                Layout.fillWidth: true
                height: 96
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 4
                    Text { text: "FILE PRIORITY"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary }
                    Text { text: "Sequential Head/Tail Enabled"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMedium; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                    Text { text: "First 2% & Last 1% cached for instant preview"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                }
            }
        }

        // Visual Piece Heatmap
        GeistCard {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 14

                Text {
                    text: "Swarm Piece Assembly Heatmap (2,560 Pieces)"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: GeistTheme.inkPrimary
                }

                // Grid of piece status blocks
                GridView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    cellWidth: 12
                    cellHeight: 12
                    clip: true
                    model: 320

                    delegate: Rectangle {
                        width: 10
                        height: 10
                        radius: 2
                        color: index < 288 ? GeistTheme.accentGreen : (index < 298 ? GeistTheme.accentBlue : "#1e1e1e")
                    }
                }

                RowLayout {
                    spacing: 20
                    Row {
                        spacing: 8
                        Rectangle { width: 10; height: 10; radius: 2; color: GeistTheme.accentGreen; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Verified Downloaded"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                    }
                    Row {
                        spacing: 8
                        Rectangle { width: 10; height: 10; radius: 2; color: GeistTheme.accentBlue; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "In-Flight In Cache"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                    }
                    Row {
                        spacing: 8
                        Rectangle { width: 10; height: 10; radius: 2; color: "#1e1e1e"; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Unrequested"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                    }
                }
            }
        }
    }
}
