// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text { text: "Download Intelligence & Diagnostics"; font.pixelSize: 20; font.weight: Font.DemiBold; color: "#ffffff" }
                Text { text: "Predictive swarm availability, ISP traffic shaping analysis, and lifetime metrics"; font.pixelSize: 13; color: "#888888" }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "NO ISP THROTTLING DETECTED"; dotColor: "#00e599" }
        }

        // Lifetime Metrics Cards
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            GeistCard {
                Layout.fillWidth: true; height: 95
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 14; spacing: 4
                    Text { text: "TOTAL DOWNLOADED"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }
                    Text { text: "1.42 TB"; font.pixelSize: 22; font.weight: Font.Bold; font.family: "Consolas"; color: "#00e599" }
                    Text { text: "Lifetime data received"; font.pixelSize: 11; color: "#666666" }
                }
            }

            GeistCard {
                Layout.fillWidth: true; height: 95
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 14; spacing: 4
                    Text { text: "TOTAL UPLOADED"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }
                    Text { text: "2.18 TB"; font.pixelSize: 22; font.weight: Font.Bold; font.family: "Consolas"; color: "#0070f3" }
                    Text { text: "Global Share Ratio: 1.53"; font.pixelSize: 11; color: "#666666" }
                }
            }

            GeistCard {
                Layout.fillWidth: true; height: 95
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 14; spacing: 4
                    Text { text: "AVERAGE VELOCITY"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }
                    Text { text: "22.6 MB/s"; font.pixelSize: 22; font.weight: Font.Bold; font.family: "Consolas"; color: "#ffffff" }
                    Text { text: "Measured across 200 Mbps sessions"; font.pixelSize: 11; color: "#666666" }
                }
            }
        }

        // ISP Traffic Shaping Detector
        GeistCard {
            Layout.fillWidth: true
            height: 120
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 16; spacing: 6
                Text { text: "ISP TRAFFIC SHAPING HEURISTIC ENGINE"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }
                Text { text: "Unshaped Connection Detected: BitTorrent protocol handshake and encrypted uTP packets are flowing at unrestricted speeds without artificial packet dropping or port reset injection."; font.pixelSize: 12; color: "#cccccc"; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                Text { text: "Measured packet loss: 0.04% | Reset flags received: 0"; font.pixelSize: 11; font.family: "Consolas"; color: "#00e599" }
            }
        }
    }
}
