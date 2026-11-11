// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text { text: "Peer Explorer (VSE-X Swarm Intelligence)"; font.pixelSize: 20; font.weight: Font.DemiBold; color: "#ffffff" }
                Text { text: "Live peer telemetry, utility scoring, and transport encryption tracking"; font.pixelSize: 13; color: "#888888" }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "42 CONNECTED PEERS"; dotColor: "#00e599" }
        }

        // Table Header
        Rectangle {
            Layout.fillWidth: true
            height: 36
            color: "#0d0d0d"
            border.color: "#1f1f1f"
            border.width: 1
            radius: 4

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 12

                Text { text: "IP & PORT"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 150 }
                Text { text: "CLIENT"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.fillWidth: true }
                Text { text: "TRANSPORT"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 90 }
                Text { text: "DOWN RATE"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 100 }
                Text { text: "UP RATE"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 90 }
                Text { text: "RTT"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 60 }
                Text { text: "PUS SCORE"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 80 }
                Text { text: "CHOKE"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#666666"; Layout.preferredWidth: 80 }
            }
        }

        // Peer Rows
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 6

            model: ListModel {
                ListElement { peerIp: "185.120.45.12:51413"; client: "Transmission 4.0.5"; transport: "uTP (Encrypted)"; downRate: "8.50 MB/s"; upRate: "120 KB/s"; rtt: "32 ms"; pus: "92 / 100"; choke: "Unchoked" }
                ListElement { peerIp: "194.67.210.88:6881"; client: "qBittorrent 4.6.3"; transport: "TCP (Encrypted)"; downRate: "6.20 MB/s"; upRate: "80 KB/s"; rtt: "41 ms"; pus: "87 / 100"; choke: "Unchoked" }
                ListElement { peerIp: "82.165.197.14:58820"; client: "libtorrent 2.0.10"; transport: "uTP (Encrypted)"; downRate: "5.40 MB/s"; upRate: "95 KB/s"; rtt: "38 ms"; pus: "85 / 100"; choke: "Unchoked" }
                ListElement { peerIp: "104.244.42.1:6889"; client: "Deluge 2.1.1"; transport: "TCP (Encrypted)"; downRate: "2.70 MB/s"; upRate: "45 KB/s"; rtt: "85 ms"; pus: "76 / 100"; choke: "Unchoked" }
            }

            delegate: Rectangle {
                width: parent.width
                height: 44
                color: "#0a0a0a"
                border.color: "#1a1a1a"
                border.width: 1
                radius: 4

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12

                    Text { text: model.peerIp; font.pixelSize: 12; font.family: "Consolas"; color: "#ffffff"; Layout.preferredWidth: 150 }
                    Text { text: model.client; font.pixelSize: 12; color: "#cccccc"; Layout.fillWidth: true }
                    Text { text: model.transport; font.pixelSize: 11; color: "#0070f3"; Layout.preferredWidth: 90 }
                    Text { text: model.downRate; font.pixelSize: 12; font.family: "Consolas"; font.weight: Font.DemiBold; color: "#00e599"; Layout.preferredWidth: 100 }
                    Text { text: model.upRate; font.pixelSize: 12; font.family: "Consolas"; color: "#888888"; Layout.preferredWidth: 90 }
                    Text { text: model.rtt; font.pixelSize: 11; font.family: "Consolas"; color: "#aaaaaa"; Layout.preferredWidth: 60 }
                    Text { text: model.pus; font.pixelSize: 12; font.family: "Consolas"; font.weight: Font.Bold; color: "#00e599"; Layout.preferredWidth: 80 }
                    Text { text: model.choke; font.pixelSize: 11; color: "#00e599"; Layout.preferredWidth: 80 }
                }
            }
        }
    }
}
