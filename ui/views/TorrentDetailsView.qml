// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"

Item {
    id: root

    property string torrentName: "ubuntu-24.04.1-desktop-amd64.iso"
    property string infoHash: "e5893a77d853106198f7e6e5894101e405a2e566"
    property string savePath: "D:/Downloads/ubuntu-24.04.1-desktop-amd64.iso"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // Header Title
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            ColumnLayout {
                spacing: 4
                Text {
                    text: root.torrentName
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    color: "#ffffff"
                }
                Text {
                    text: "Hash: " + root.infoHash + " | Path: " + root.savePath
                    font.pixelSize: 11
                    font.family: "Consolas, monospace"
                    color: "#666666"
                }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "90.2% COMPLETE"; dotColor: "#00e599" }
        }

        // Details Grid Cards
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            GeistCard {
                Layout.fillWidth: true
                height: 80
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 12
                    Text { text: "VERIFIED PIECES"; font.pixelSize: 11; color: "#888888" }
                    Text { text: "2,309 / 2,560 (4 MiB each)"; font.pixelSize: 16; font.weight: Font.Bold; font.family: "Consolas"; color: "#00e599" }
                    Text { text: "0 bad blocks detected | 100% hash integrity"; font.pixelSize: 11; color: "#666666" }
                }
            }

            GeistCard {
                Layout.fillWidth: true
                height: 80
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 12
                    Text { text: "ACTIVE TRACKERS"; font.pixelSize: 11; color: "#888888" }
                    Text { text: "4 Working (Tier 0 & 1)"; font.pixelSize: 16; font.weight: Font.Bold; font.family: "Consolas"; color: "#ffffff" }
                    Text { text: "torrent.ubuntu.com:6969 [UDP Announce OK]"; font.pixelSize: 11; color: "#666666" }
                }
            }

            GeistCard {
                Layout.fillWidth: true
                height: 80
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 12
                    Text { text: "FILE PRIORITY"; font.pixelSize: 11; color: "#888888" }
                    Text { text: "Sequential Head/Tail Enabled"; font.pixelSize: 16; font.weight: Font.Bold; color: "#0070f3" }
                    Text { text: "First 2% & Last 1% cached for preview"; font.pixelSize: 11; color: "#666666" }
                }
            }
        }

        // Visual Piece Heatmap
        GeistCard {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text {
                    text: "Swarm Piece Heatmap (2,560 Pieces)"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    color: "#ffffff"
                }

                // Grid of piece status blocks
                GridView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    cellWidth: 10
                    cellHeight: 10
                    clip: true
                    model: 320 // Sample piece representation

                    delegate: Rectangle {
                        width: 8
                        height: 8
                        radius: 1
                        color: index < 288 ? "#00e599" : (index < 298 ? "#0070f3" : "#222222")
                    }
                }

                RowLayout {
                    spacing: 16
                    Row { spacing: 6; Rectangle { width: 8; height: 8; radius: 1; color: "#00e599"; anchors.verticalCenter: parent.verticalCenter }; Text { text: "Verified Downloaded"; font.pixelSize: 11; color: "#888888" } }
                    Row { spacing: 6; Rectangle { width: 8; height: 8; radius: 1; color: "#0070f3"; anchors.verticalCenter: parent.verticalCenter }; Text { text: "Pending Verification"; font.pixelSize: 11; color: "#888888" } }
                    Row { spacing: 6; Rectangle { width: 8; height: 8; radius: 1; color: "#222222"; anchors.verticalCenter: parent.verticalCenter }; Text { text: "Remaining"; font.pixelSize: 11; color: "#888888" } }
                }
            }
        }
    }
}
