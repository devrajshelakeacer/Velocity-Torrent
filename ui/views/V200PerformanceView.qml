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
                    text: "V200 — 200 Mbps Broadband Pipeline Optimizer"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeTitle
                    font.weight: Font.Bold
                    color: GeistTheme.inkPrimary
                }
                Text {
                    text: "Precision bandwidth saturation, layer-by-layer telemetry, and bottleneck attribution"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeSub
                    color: GeistTheme.inkSecondary
                }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "LINE SATURATED: 23.4 MB/s"; dotColor: GeistTheme.accentGreen }
        }

        // Line Saturation Gauge Card
        GeistCard {
            Layout.fillWidth: true
            height: 124

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 10

                RowLayout {
                    Text {
                        text: "200 Mbps CONNECTION SATURATION"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeMicro
                        font.weight: Font.Bold
                        font.letterSpacing: 0.8
                        color: GeistTheme.inkSecondary
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "23.4 / 25.0 MB/s (93.6%)"
                        font.family: GeistTheme.fontMono
                        font.pixelSize: GeistTheme.fontSizeBody
                        font.weight: Font.Bold
                        color: GeistTheme.inkPrimary
                    }
                }

                GeistProgressBar {
                    Layout.fillWidth: true
                    value: 0.936
                    barColor: GeistTheme.accentBlue
                }

                Text {
                    text: "Sustaining 22–24 MB/s goodput under healthy swarm conditions. Theoretical line ceiling: 25.0 MB/s."
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeMicro
                    color: GeistTheme.inkSecondary
                }
            }
        }

        // 5-Layer Pipeline Bottleneck Diagnostic Grid
        Text {
            text: "5-LAYER PIPELINE BOTTLENECK ANALYSIS"
            font.family: GeistTheme.fontSans
            font.pixelSize: GeistTheme.fontSizeMicro
            font.weight: Font.Bold
            font.letterSpacing: 0.8
            color: GeistTheme.inkSecondary
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10

            Repeater {
                model: [
                    { layer: "1. Swarm Health Layer", desc: "Peer piece availability: 142 seeds (PUS: 88)", status: "OPTIMAL", color: GeistTheme.accentGreen },
                    { layer: "2. Transport Socket Layer", desc: "Winsock buffer auto-tuned to 8 MiB (RTT: 32ms)", status: "OPTIMAL", color: GeistTheme.accentGreen },
                    { layer: "3. Direct Cache Coalescing", desc: "4 MiB sequential chunk write commits (WAF: 0.12)", status: "ACTIVE (90% Saved)", color: GeistTheme.accentGreen },
                    { layer: "4. NVMe / SSD Storage Layer", desc: "Queue depth 4, 1.2ms write latency (No backpressure)", status: "OPTIMAL", color: GeistTheme.accentGreen },
                    { layer: "5. Thermal Guardian Safety", desc: "CPU Core Temp: 48°C (User Autonomy Active)", status: "NORMAL", color: GeistTheme.accentGreen }
                ]

                delegate: GeistCard {
                    Layout.fillWidth: true
                    height: 52

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 18
                        anchors.rightMargin: 18
                        spacing: 16

                        Text {
                            text: modelData.layer
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeBody
                            font.weight: Font.DemiBold
                            color: GeistTheme.inkPrimary
                            Layout.preferredWidth: 200
                        }

                        Text {
                            text: modelData.desc
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeSub
                            color: GeistTheme.inkSecondary
                            Layout.fillWidth: true
                        }

                        GeistBadge {
                            text: modelData.status
                            dotColor: modelData.color
                        }
                    }
                }
            }
        }
    }
}
