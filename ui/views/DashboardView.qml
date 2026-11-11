// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"

Item {
    id: root

    property real downloadSpeedMBs: 23.4
    property real uploadSpeedMBs: 1.45
    property real lineEfficiency: 93.6
    property real swarmHealth: 94.2
    property real cpuTemp: 48.0
    property string activeProfile: "V-FORCE MAX"
    property string primaryBottleneck: "Optimal Line Saturation (23+ MB/s)"

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 20

            // Header Section
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                ColumnLayout {
                    spacing: 4
                    Text {
                        text: "Dashboard Overview"
                        font.pixelSize: 20
                        font.weight: Font.DemiBold
                        color: "#ffffff"
                    }
                    Text {
                        text: "Real-time telemetry and 200 Mbps broadband pipeline utilization"
                        font.pixelSize: 13
                        color: "#888888"
                    }
                }

                Item { Layout.fillWidth: true }

                GeistBadge {
                    text: root.activeProfile
                    dotColor: "#0070f3"
                }

                GeistButton {
                    text: "+ Add Torrent"
                    variant: "primary"
                }
            }

            // High Priority Thermal Banner (User-Controlled Policy)
            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: 6
                color: root.cpuTemp >= 95 ? "#331111" : (root.cpuTemp >= 80 ? "#261a00" : "transparent")
                border.color: root.cpuTemp >= 95 ? "#ff3333" : (root.cpuTemp >= 80 ? "#f5a623" : "transparent")
                border.width: 1
                visible: root.cpuTemp >= 80

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    Text {
                        text: root.cpuTemp >= 95 ? "⚠️ CRITICAL PEAK TEMPERATURE (>= 95°C): Hardware thermal limit reached!" :
                                                   "🔥 ELEVATED TEMPERATURE: " + root.cpuTemp.toFixed(1) + "°C — Fast Download Continues (User in Control)"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: root.cpuTemp >= 95 ? "#ff5555" : "#f5a623"
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "No automatic speed cut | Retaining your full throughput"
                        font.pixelSize: 11
                        color: "#cccccc"
                    }
                }
            }

            // Top 3 KPI Metric Cards
            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                GeistCard {
                    Layout.fillWidth: true
                    height: 100
                    hoverable: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 6

                        Text {
                            text: "TOTAL THROUGHPUT"
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            color: "#888888"
                            font.letterSpacing: 0.8
                        }

                        RowLayout {
                            spacing: 8
                            Text {
                                text: root.downloadSpeedMBs.toFixed(1) + " MB/s"
                                font.pixelSize: 24
                                font.weight: Font.Bold
                                font.family: "Consolas, monospace"
                                color: "#00e599"
                            }
                            Text {
                                text: "↑ " + root.uploadSpeedMBs.toFixed(2) + " MB/s"
                                font.pixelSize: 13
                                font.family: "Consolas, monospace"
                                color: "#888888"
                            }
                        }

                        Text {
                            text: "V200 Line Saturation: " + root.lineEfficiency.toFixed(1) + "% of 25 MB/s"
                            font.pixelSize: 11
                            color: "#0070f3"
                        }
                    }
                }

                GeistCard {
                    Layout.fillWidth: true
                    height: 100
                    hoverable: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 6

                        Text {
                            text: "SWARM HEALTH"
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            color: "#888888"
                            font.letterSpacing: 0.8
                        }

                        Text {
                            text: root.swarmHealth.toFixed(1) + "% Optimal"
                            font.pixelSize: 24
                            font.weight: Font.Bold
                            color: "#ffffff"
                        }

                        Text {
                            text: "142 connected peers | Average PUS: 88/100"
                            font.pixelSize: 11
                            color: "#888888"
                        }
                    }
                }

                GeistCard {
                    Layout.fillWidth: true
                    height: 100
                    hoverable: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 6

                        Text {
                            text: "THERMAL GUARDIAN"
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            color: "#888888"
                            font.letterSpacing: 0.8
                        }

                        RowLayout {
                            spacing: 8
                            Text {
                                text: root.cpuTemp.toFixed(1) + " °C"
                                font.pixelSize: 24
                                font.weight: Font.Bold
                                color: root.cpuTemp >= 95 ? "#ff3333" : (root.cpuTemp >= 80 ? "#f5a623" : "#ffffff")
                            }
                            GeistBadge {
                                text: root.cpuTemp >= 95 ? "DANGER" : (root.cpuTemp >= 80 ? "ELEVATED" : "NORMAL")
                                dotColor: root.cpuTemp >= 95 ? "#ff3333" : (root.cpuTemp >= 80 ? "#f5a623" : "#00e599")
                            }
                        }

                        Text {
                            text: "Direct Piece Coalescing: 88.5% SSD Wear Saved"
                            font.pixelSize: 11
                            color: "#888888"
                        }
                    }
                }
            }

            // Real-Time Throughput Graph
            GeistCard {
                Layout.fillWidth: true
                height: 220

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Real-Time Throughput (Last 60 Seconds)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: "#ffffff"
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: "Target: 22.0 - 24.0 MB/s (200 Mbps)"
                            font.pixelSize: 12
                            font.family: "Consolas, monospace"
                            color: "#888888"
                        }
                    }

                    GeistChart {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        maxValue: 25.0
                        lineColor: "#0070f3"
                        fillColor: "#150070f3"
                        dataPoints: [18.2, 19.5, 21.0, 22.4, 22.8, 23.4, 23.1, 23.5, 22.9, 23.4, 23.6, 23.4]
                    }
                }
            }

            // Bottleneck Attribution Banner
            GeistCard {
                Layout.fillWidth: true
                height: 60

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Text {
                        text: "BOTTLENECK DIAGNOSTICS:"
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        color: "#888888"
                    }

                    Text {
                        text: root.primaryBottleneck
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#00e599"
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "Socket RTT: 32ms | Disk Latency: 4.2ms | Winsock: 45%"
                        font.pixelSize: 11
                        font.family: "Consolas, monospace"
                        color: "#888888"
                    }
                }
            }
        }
    }
}
