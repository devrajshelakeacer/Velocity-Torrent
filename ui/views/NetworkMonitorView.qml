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
                    text: "Network Monitor & Interface Topology"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeTitle
                    font.weight: Font.Bold
                    color: GeistTheme.inkPrimary
                }
                Text {
                    text: "Windows IP Helper adapter discovery, UPnP status, and Winsock routing diagnostics"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeSub
                    color: GeistTheme.inkSecondary
                }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "PORT 6881 OPEN (UPnP OK)"; dotColor: GeistTheme.accentGreen }
        }

        // Detected Network Adapters
        Text {
            text: "DETECTED NETWORK INTERFACES"
            font.family: GeistTheme.fontSans
            font.pixelSize: GeistTheme.fontSizeMicro
            font.weight: Font.Bold
            font.letterSpacing: 0.8
            color: GeistTheme.inkSecondary
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 18

            GeistCard {
                Layout.fillWidth: true
                height: 136
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 6
                    RowLayout {
                        Text {
                            text: "Ethernet (Realtek PCIe GbE)"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMedium
                            font.weight: Font.DemiBold
                            color: GeistTheme.inkPrimary
                        }
                        Item { Layout.fillWidth: true }
                        GeistBadge { text: "PRIMARY ACTIVE"; dotColor: GeistTheme.accentGreen }
                    }
                    Text { text: "IPv4: 192.168.1.105 | Subnet: 255.255.255.0"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                    Text { text: "Gateway: 192.168.1.1 | Link: 1000 Mbps Full Duplex"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                    Text { text: "Bound Peer Sockets: 38 connections active"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkPrimary }
                }
            }

            GeistCard {
                Layout.fillWidth: true
                height: 136
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 6
                    RowLayout {
                        Text {
                            text: "Wi-Fi 6 (Intel AX200 160MHz)"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMedium
                            font.weight: Font.DemiBold
                            color: GeistTheme.inkPrimary
                        }
                        Item { Layout.fillWidth: true }
                        GeistBadge { text: "HOT STANDBY"; dotColor: GeistTheme.inkSecondary }
                    }
                    Text { text: "IPv4: 192.168.1.142 | Signal: 98% (-42 dBm)"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                    Text { text: "Link Speed: 1200 Mbps (802.11ax)"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                    Text { text: "Secondary route: Standby (Metric: 45)"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                }
            }
        }

        // Routing Stack Diagnostics
        GeistCard {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12

                Text {
                    text: "Socket Pipeline & Routing Diagnostics"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: GeistTheme.inkPrimary
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 24

                    ColumnLayout {
                        spacing: 4
                        Text { text: "Average RTT (Round Trip Time): 32.4 ms"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                        Text { text: "Packet Loss Rate: 0.02% (Target: < 0.5%)"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                        Text { text: "Winsock Send/Recv Buffer: 8 MiB (Auto-Tuned)"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                    }

                    Item { Layout.fillWidth: true }

                    ColumnLayout {
                        spacing: 4
                        Text { text: "uTP Congestion Control: LEDBAT Native"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                        Text { text: "TCP BBR/Cubic Window: Saturated (24 MB/s)"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                        Text { text: "Network Lock (Kill-Switch): ARMED"; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkPrimary }
                    }
                }
            }
        }
    }
}
