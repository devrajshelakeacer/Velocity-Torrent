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
                Text { text: "Network Monitor & Interface Topology"; font.pixelSize: 20; font.weight: Font.DemiBold; color: "#ffffff" }
                Text { text: "Windows IP Helper adapter discovery, UPnP status, and routing stack diagnostics"; font.pixelSize: 13; color: "#888888" }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "PORT 6881 OPEN (UPnP OK)"; dotColor: "#00e599" }
        }

        // Detected Network Adapters
        Text { text: "DETECTED NETWORK INTERFACES"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            GeistCard {
                Layout.fillWidth: true
                height: 120
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 14; spacing: 4
                    RowLayout {
                        Text { text: "Ethernet (Realtek PCIe GbE)"; font.pixelSize: 14; font.weight: Font.DemiBold; color: "#ffffff" }
                        Item { Layout.fillWidth: true }
                        GeistBadge { text: "ACTIVE"; dotColor: "#00e599" }
                    }
                    Text { text: "IPv4: 192.168.1.105 | Subnet: 255.255.255.0"; font.pixelSize: 11; font.family: "Consolas"; color: "#888888" }
                    Text { text: "Gateway: 192.168.1.1 | Speed: 1000 Mbps Full Duplex"; font.pixelSize: 11; font.family: "Consolas"; color: "#888888" }
                    Text { text: "Bound Peer Sockets: 38 connections"; font.pixelSize: 11; color: "#0070f3" }
                }
            }

            GeistCard {
                Layout.fillWidth: true
                height: 120
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 14; spacing: 4
                    RowLayout {
                        Text { text: "Wi-Fi 6 (Intel AX200 160MHz)"; font.pixelSize: 14; font.weight: Font.DemiBold; color: "#ffffff" }
                        Item { Layout.fillWidth: true }
                        GeistBadge { text: "STANDBY"; dotColor: "#888888" }
                    }
                    Text { text: "IPv4: 192.168.1.142 | Signal: 98% (-42 dBm)"; font.pixelSize: 11; font.family: "Consolas"; color: "#888888" }
                    Text { text: "Link Speed: 1200 Mbps (802.11ax)"; font.pixelSize: 11; font.family: "Consolas"; color: "#888888" }
                    Text { text: "Secondary route: Standby (Metrics: 45)"; font.pixelSize: 11; color: "#888888" }
                }
            }
        }

        // Port & Socket Diagnostics
        GeistCard {
            Layout.fillWidth: true
            height: 120
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 16; spacing: 8
                Text { text: "PORT FORWARDING & WINSOCK BUFFER STATUS"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }
                RowLayout {
                    spacing: 24
                    Column {
                        spacing: 2
                        Text { text: "External Listening Port"; font.pixelSize: 11; color: "#666666" }
                        Text { text: "6881 (TCP / UDP)"; font.pixelSize: 14; font.family: "Consolas"; font.weight: Font.Bold; color: "#00e599" }
                    }
                    Column {
                        spacing: 2
                        Text { text: "NAT Traversal"; font.pixelSize: 11; color: "#666666" }
                        Text { text: "UPnP IGD Profile 2.0 (Active)"; font.pixelSize: 14; font.weight: Font.Bold; color: "#ffffff" }
                    }
                    Column {
                        spacing: 2
                        Text { text: "Winsock Buffer Allocation"; font.pixelSize: 11; color: "#666666" }
                        Text { text: "2048 KiB (Dynamic Tuning)"; font.pixelSize: 14; font.family: "Consolas"; font.weight: Font.Bold; color: "#0070f3" }
                    }
                    Column {
                        spacing: 2
                        Text { text: "Network Lock Interface"; font.pixelSize: 11; color: "#666666" }
                        Text { text: "All Physical Interfaces"; font.pixelSize: 14; font.weight: Font.Bold; color: "#cccccc" }
                    }
                }
            }
        }
    }
}
