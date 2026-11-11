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
        spacing: 20

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text {
                    text: "Peer Explorer (VSE-X Swarm Intelligence)"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeTitle
                    font.weight: Font.Bold
                    color: GeistTheme.inkPrimary
                }
                Text {
                    text: "Real-time peer telemetry, peer utility scoring (PUS), and transport encryption validation"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeSub
                    color: GeistTheme.inkSecondary
                }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "42 CONNECTED PEERS"; dotColor: GeistTheme.accentGreen }
        }

        // Table Header
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: GeistTheme.surfaceSubtle
            border.color: GeistTheme.borderCard
            border.width: 1
            radius: GeistTheme.radiusMedium

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 18
                spacing: 14

                Text { text: "IP & PORT"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 160 }
                Text { text: "CLIENT"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.fillWidth: true }
                Text { text: "TRANSPORT"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 110 }
                Text { text: "DOWN RATE"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 100 }
                Text { text: "UP RATE"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 90 }
                Text { text: "RTT"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 60 }
                Text { text: "PUS SCORE"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 90 }
                Text { text: "CHOKE"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary; Layout.preferredWidth: 80 }
            }
        }

        // Peer Rows
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8

            model: ListModel {
                ListElement { peerIp: "185.120.45.12:51413"; client: "Transmission 4.0.5"; transport: "uTP (Encrypted)"; downRate: "8.50 MB/s"; upRate: "120 KB/s"; rtt: "32 ms"; pus: "92 / 100"; choke: "Unchoked" }
                ListElement { peerIp: "194.67.210.88:6881"; client: "qBittorrent 4.6.3"; transport: "TCP (Encrypted)"; downRate: "6.20 MB/s"; upRate: "80 KB/s"; rtt: "41 ms"; pus: "87 / 100"; choke: "Unchoked" }
                ListElement { peerIp: "82.165.197.1:52100"; client: "Deluge 2.1.1"; transport: "uTP (Encrypted)"; downRate: "4.80 MB/s"; upRate: "240 KB/s"; rtt: "28 ms"; pus: "84 / 100"; choke: "Unchoked" }
                ListElement { peerIp: "45.154.255.4:6881"; client: "libtorrent 2.0.10"; transport: "TCP (Encrypted)"; downRate: "3.30 MB/s"; upRate: "110 KB/s"; rtt: "55 ms"; pus: "79 / 100"; choke: "Unchoked" }
            }

            delegate: Rectangle {
                width: parent.width
                height: 50
                color: mArea.containsMouse ? GeistTheme.surfaceCardHover : GeistTheme.surfaceCard
                border.color: mArea.containsMouse ? GeistTheme.borderHover : GeistTheme.borderCard
                border.width: 1
                radius: GeistTheme.radiusMedium

                Behavior on color { ColorAnimation { duration: 120 } }
                Behavior on border.color { ColorAnimation { duration: 120 } }

                MouseArea {
                    id: mArea
                    anchors.fill: parent
                    hoverEnabled: true
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 18
                    anchors.rightMargin: 18
                    spacing: 14

                    Text { text: model.peerIp; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkPrimary; Layout.preferredWidth: 160 }
                    Text { text: model.client; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeBody; font.weight: Font.Medium; color: GeistTheme.inkPrimary; Layout.fillWidth: true }
                    Text { text: model.transport; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary; Layout.preferredWidth: 110 }
                    Text { text: model.downRate; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeSub; font.weight: Font.DemiBold; color: GeistTheme.inkPrimary; Layout.preferredWidth: 100 }
                    Text { text: model.upRate; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary; Layout.preferredWidth: 90 }
                    Text { text: model.rtt; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary; Layout.preferredWidth: 60 }
                    Text { text: model.pus; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; color: GeistTheme.inkPrimary; Layout.preferredWidth: 90 }
                    Text { text: model.choke; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary; Layout.preferredWidth: 80 }
                }
            }
        }
    }
}
