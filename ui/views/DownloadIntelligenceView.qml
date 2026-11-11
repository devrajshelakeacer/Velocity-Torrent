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
        spacing: 22

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text {
                    text: "Download Intelligence & Diagnostics"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeTitle
                    font.weight: Font.Bold
                    color: GeistTheme.inkPrimary
                }
                Text {
                    text: "Predictive swarm availability, ISP traffic shaping analysis, and lifetime metrics"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeSub
                    color: GeistTheme.inkSecondary
                }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "NO ISP THROTTLING DETECTED"; dotColor: GeistTheme.accentGreen }
        }

        // Lifetime Metrics Cards
        RowLayout {
            Layout.fillWidth: true
            spacing: 18

            GeistCard {
                Layout.fillWidth: true; height: 110
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 18; spacing: 4
                    Text { text: "TOTAL DOWNLOADED"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary }
                    Text { text: "1.42 TB"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeTitle; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                    Text { text: "Lifetime data verified & committed"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                }
            }

            GeistCard {
                Layout.fillWidth: true; height: 110
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 18; spacing: 4
                    Text { text: "TOTAL UPLOADED"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary }
                    Text { text: "2.18 TB"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeTitle; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                    Text { text: "Global Swarm Share Ratio: 1.53"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                }
            }

            GeistCard {
                Layout.fillWidth: true; height: 110
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 18; spacing: 4
                    Text { text: "AVERAGE VELOCITY"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary }
                    Text { text: "22.6 MB/s"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeTitle; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                    Text { text: "Measured across 200 Mbps broadband sessions"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                }
            }
        }

        // ISP Traffic Shaping & Heuristics
        GeistCard {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12

                Text {
                    text: "ISP Traffic Shaping & BitTorrent Protocol Heuristics"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: GeistTheme.inkPrimary
                }

                Text {
                    text: "VELOCITY constantly analyzes peer round-trip latency, handshake reset rates, and uTP packet drops to detect ISP throttling. In controlled 200 Mbps tests, no BitTorrent rate limiting or deep packet inspection (DPI) resets were detected."
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeBody
                    color: GeistTheme.inkSecondary
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }

                RowLayout {
                    spacing: 16
                    GeistButton { text: "Run Diagnostic Test"; variant: "primary" }
                    GeistButton { text: "Export Diagnostic Report"; variant: "secondary" }
                }
            }
        }
    }
}
