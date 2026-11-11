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
                Text { text: "V200 — 200 Mbps Broadband Pipeline Optimizer"; font.pixelSize: 20; font.weight: Font.DemiBold; color: "#ffffff" }
                Text { text: "Precision bandwidth saturation, layer-by-layer telemetry, and bottleneck attribution"; font.pixelSize: 13; color: "#888888" }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "LINE SATURATED: 23.4 MB/s"; dotColor: "#00e599" }
        }

        // Line Saturation Gauge Card
        GeistCard {
            Layout.fillWidth: true
            height: 110

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                RowLayout {
                    Text { text: "200 Mbps CONNECTION SATURATION"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }
                    Item { Layout.fillWidth: true }
                    Text { text: "23.4 / 25.0 MB/s (93.6%)"; font.pixelSize: 13; font.family: "Consolas"; font.weight: Font.Bold; color: "#00e599" }
                }

                GeistProgressBar {
                    Layout.fillWidth: true
                    value: 0.936
                    barColor: "#00e599"
                }

                Text {
                    text: "Sustaining 22-24 MB/s goodput under healthy swarm conditions. Theoretical line ceiling: 25.0 MB/s."
                    font.pixelSize: 11
                    color: "#666666"
                }
            }
        }

        // 5-Layer Pipeline Bottleneck Diagnostic Grid
        Text { text: "5-LAYER PIPELINE BOTTLENECK ANALYSIS"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            // Layer 1
            Rectangle {
                Layout.fillWidth: true; height: 50; radius: 6; color: "#0d0d0d"; border.color: "#1c1c1c"; border.width: 1
                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                    Text { text: "Layer 1: Swarm Upload Supply"; font.pixelSize: 13; font.weight: Font.Medium; color: "#ffffff"; Layout.preferredWidth: 240 }
                    Text { text: "Available Seeder Capacity: 28.5 MB/s"; font.pixelSize: 12; font.family: "Consolas"; color: "#888888"; Layout.fillWidth: true }
                    GeistBadge { text: "HEALTHY (>= 20 MB/s)"; dotColor: "#00e599" }
                }
            }

            // Layer 2
            Rectangle {
                Layout.fillWidth: true; height: 50; radius: 6; color: "#0d0d0d"; border.color: "#1c1c1c"; border.width: 1
                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                    Text { text: "Layer 2: Local Network / Bufferbloat"; font.pixelSize: 13; font.weight: Font.Medium; color: "#ffffff"; Layout.preferredWidth: 240 }
                    Text { text: "Swarm RTT: 36ms (Delta +4ms over baseline)"; font.pixelSize: 12; font.family: "Consolas"; color: "#888888"; Layout.fillWidth: true }
                    GeistBadge { text: "LOW LATENCY (uTP OK)"; dotColor: "#00e599" }
                }
            }

            // Layer 3
            Rectangle {
                Layout.fillWidth: true; height: 50; radius: 6; color: "#0d0d0d"; border.color: "#1c1c1c"; border.width: 1
                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                    Text { text: "Layer 3: Winsock Buffer Stack"; font.pixelSize: 13; font.weight: Font.Medium; color: "#ffffff"; Layout.preferredWidth: 240 }
                    Text { text: "SO_RCVBUF: 2048 KiB (45% utilization)"; font.pixelSize: 12; font.family: "Consolas"; color: "#888888"; Layout.fillWidth: true }
                    GeistBadge { text: "NO BACKPRESSURE"; dotColor: "#00e599" }
                }
            }

            // Layer 4
            Rectangle {
                Layout.fillWidth: true; height: 50; radius: 6; color: "#0d0d0d"; border.color: "#1c1c1c"; border.width: 1
                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                    Text { text: "Layer 4: CPU Cryptographic Hashing"; font.pixelSize: 13; font.weight: Font.Medium; color: "#ffffff"; Layout.preferredWidth: 240 }
                    Text { text: "Worker Thread Pool: 22% utilization across 4 cores"; font.pixelSize: 12; font.family: "Consolas"; color: "#888888"; Layout.fillWidth: true }
                    GeistBadge { text: "AVX2 ACCELERATED"; dotColor: "#00e599" }
                }
            }

            // Layer 5
            Rectangle {
                Layout.fillWidth: true; height: 50; radius: 6; color: "#0d0d0d"; border.color: "#1c1c1c"; border.width: 1
                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                    Text { text: "Layer 5: Storage Disk Pipeline"; font.pixelSize: 13; font.weight: Font.Medium; color: "#ffffff"; Layout.preferredWidth: 240 }
                    Text { text: "NVMe Write Latency: 4.2ms | Direct Coalescing: 88.5%"; font.pixelSize: 12; font.family: "Consolas"; color: "#888888"; Layout.fillWidth: true }
                    GeistBadge { text: "ZERO DISK STALL"; dotColor: "#00e599" }
                }
            }
        }
    }
}
