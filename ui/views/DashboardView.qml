// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import ".."

Item {
    id: root

    property real downloadSpeedMBs: (typeof velocityBridge !== "undefined") ? velocityBridge.downloadSpeed : 23.4
    property real uploadSpeedMBs: (typeof velocityBridge !== "undefined") ? velocityBridge.uploadSpeed : 1.45
    property real lineEfficiency: (typeof velocityBridge !== "undefined") ? velocityBridge.lineEfficiency : 93.6
    property real swarmHealth: (typeof velocityBridge !== "undefined") ? velocityBridge.swarmHealth : 94.2
    property real cpuTemp: (typeof velocityBridge !== "undefined") ? velocityBridge.cpuTemp : 48.0
    property string activeProfile: (typeof velocityBridge !== "undefined") ? velocityBridge.activeProfile : "V-FORCE MAX"
    property string primaryBottleneck: (typeof velocityBridge !== "undefined") ? velocityBridge.primaryBottleneck : "Optimal Line Saturation (23+ MB/s)"

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 28
            spacing: 24

            // Header Section
            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                ColumnLayout {
                    spacing: 4
                    Text {
                        text: "Dashboard Overview"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeTitle
                        font.weight: Font.Bold
                        color: GeistTheme.inkPrimary
                    }
                    Text {
                        text: "Real-time telemetry and 200 Mbps broadband saturation pipeline"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeSub
                        color: GeistTheme.inkSecondary
                    }
                }

                Item { Layout.fillWidth: true }

                GeistBadge {
                    text: root.activeProfile
                    dotColor: GeistTheme.accentBlue
                }

                GeistButton {
                    text: "+ Add Torrent"
                    variant: "primary"
                }
            }

            // High Priority Thermal Banner (User-Controlled Policy)
            Rectangle {
                Layout.fillWidth: true
                height: 44
                radius: GeistTheme.radiusCard
                color: root.cpuTemp >= 95 ? "#260808" : (root.cpuTemp >= 80 ? "#261a00" : "transparent")
                border.color: root.cpuTemp >= 95 ? "#ff3333" : (root.cpuTemp >= 80 ? "#f5a623" : "transparent")
                border.width: 1
                visible: root.cpuTemp >= 80

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 10

                    Text {
                        text: root.cpuTemp >= 95 ? "CRITICAL PEAK TEMPERATURE (>= 95°C): Hardware thermal boundary reached!" :
                                                   "ELEVATED TEMPERATURE: " + root.cpuTemp.toFixed(1) + "°C — Fast Download Continues (User in Control)"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeSub
                        font.weight: Font.DemiBold
                        color: root.cpuTemp >= 95 ? "#ff5555" : "#f5a623"
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "No automatic speed cut | Sustaining line saturation"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeMicro
                        color: "#a1a1a1"
                    }
                }
            }

            // Top 3 KPI Metric Cards (Monochromatic Vercel Standard)
            RowLayout {
                Layout.fillWidth: true
                spacing: 18

                // Card 1: Throughput
                GeistCard {
                    Layout.fillWidth: true
                    height: 120
                    hoverable: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 8

                        Text {
                            text: "TOTAL THROUGHPUT"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMicro
                            font.weight: Font.DemiBold
                            font.letterSpacing: 1.0
                            color: GeistTheme.inkSecondary
                        }

                        RowLayout {
                            spacing: 10
                            Text {
                                text: root.downloadSpeedMBs.toFixed(1) + " MB/s"
                                font.family: GeistTheme.fontSans
                                font.pixelSize: GeistTheme.fontSizeDisplay
                                font.weight: Font.Bold
                                color: GeistTheme.inkPrimary
                            }
                            Text {
                                text: "↑ " + root.uploadSpeedMBs.toFixed(2) + " MB/s"
                                font.family: GeistTheme.fontSans
                                font.pixelSize: GeistTheme.fontSizeBody
                                color: GeistTheme.inkSecondary
                            }
                        }

                        Text {
                            text: "Broadband Line Saturation: " + root.lineEfficiency.toFixed(1) + "% of 25.0 MB/s"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMicro
                            color: GeistTheme.inkSecondary
                        }
                    }
                }

                // Card 2: Swarm Health
                GeistCard {
                    Layout.fillWidth: true
                    height: 120
                    hoverable: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 8

                        Text {
                            text: "SWARM HEALTH"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMicro
                            font.weight: Font.DemiBold
                            font.letterSpacing: 1.0
                            color: GeistTheme.inkSecondary
                        }

                        Text {
                            text: root.swarmHealth.toFixed(1) + "% Optimal"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeDisplay
                            font.weight: Font.Bold
                            color: GeistTheme.inkPrimary
                        }

                        Text {
                            text: "142 active peers | Average PUS: 88/100"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMicro
                            color: GeistTheme.inkSecondary
                        }
                    }
                }

                // Card 3: Thermal & Cache
                GeistCard {
                    Layout.fillWidth: true
                    height: 120
                    hoverable: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 8

                        Text {
                            text: "THERMAL & HARDWARE GUARDIAN"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMicro
                            font.weight: Font.DemiBold
                            font.letterSpacing: 1.0
                            color: GeistTheme.inkSecondary
                        }

                        RowLayout {
                            spacing: 12
                            Text {
                                text: root.cpuTemp.toFixed(1) + " °C"
                                font.family: GeistTheme.fontSans
                                font.pixelSize: GeistTheme.fontSizeDisplay
                                font.weight: Font.Bold
                                color: root.cpuTemp >= 95 ? "#ff5555" : (root.cpuTemp >= 80 ? "#f5a623" : GeistTheme.inkPrimary)
                            }
                            GeistBadge {
                                text: root.cpuTemp >= 95 ? "CRITICAL" : (root.cpuTemp >= 80 ? "ELEVATED" : "NORMAL")
                                dotColor: root.cpuTemp >= 95 ? "#ff3333" : (root.cpuTemp >= 80 ? "#f5a623" : GeistTheme.accentGreen)
                            }
                        }

                        Text {
                            text: "Direct Piece Coalescing: 90% SSD Wear Saved"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMicro
                            color: GeistTheme.inkSecondary
                        }
                    }
                }
            }

            // Real-Time Throughput Graph Card
            GeistCard {
                Layout.fillWidth: true
                height: 240

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 14

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Real-Time Throughput (Last 60 Seconds)"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMedium
                            font.weight: Font.DemiBold
                            color: GeistTheme.inkPrimary
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: "Broadband Target: 22.0 – 24.0 MB/s"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeSub
                            color: GeistTheme.inkSecondary
                        }
                    }

                    GeistChart {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        maxValue: 25.0
                        lineColor: GeistTheme.accentBlue
                        fillColor: "#150070f3"
                        dataPoints: [18.5, 19.8, 21.2, 22.4, 23.0, 23.4, 23.2, 23.6, 23.1, 23.4, 23.7, 23.5]
                    }
                }
            }

            // Bottleneck Attribution Diagnostics (Monochromatic Vercel Card)
            GeistCard {
                Layout.fillWidth: true
                height: 64

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 16

                    Text {
                        text: "BOTTLENECK DIAGNOSTICS:"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeMicro
                        font.weight: Font.Bold
                        font.letterSpacing: 0.8
                        color: GeistTheme.inkSecondary
                    }

                    Text {
                        text: root.primaryBottleneck
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeBody
                        font.weight: Font.DemiBold
                        color: GeistTheme.inkPrimary
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "Socket RTT: 32ms | Disk Latency: 4.2ms | Winsock: 45%"
                        font.family: GeistTheme.fontMono
                        font.pixelSize: GeistTheme.fontSizeMicro
                        color: GeistTheme.inkSecondary
                    }
                }
            }
        }
    }
}
