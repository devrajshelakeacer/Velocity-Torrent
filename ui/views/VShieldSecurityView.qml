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
                Text { text: "V-SHIELD — Security Architecture & Isolation"; font.pixelSize: 20; font.weight: Font.DemiBold; color: "#ffffff" }
                Text { text: "Path traversal barriers, Microsoft Defender scanning, zero auto-execution, and Network Lock"; font.pixelSize: 13; color: "#888888" }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "V-SHIELD ENFORCED"; dotColor: "#00e599" }
        }

        // 4 Security Posture Cards
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            GeistCard {
                Layout.fillWidth: true; height: 100
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 14; spacing: 4
                    Text { text: "PATH TRAVERSAL GUARD"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }
                    Text { text: "ACTIVE (100% Isolated)"; font.pixelSize: 15; font.weight: Font.Bold; color: "#00e599" }
                    Text { text: "All metadata filenames canonicalized; NTFS ADS stripped"; font.pixelSize: 11; color: "#666666" }
                }
            }

            GeistCard {
                Layout.fillWidth: true; height: 100
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 14; spacing: 4
                    Text { text: "MICROSOFT DEFENDER"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }
                    Text { text: "CONNECTED (Auto-Scan)"; font.pixelSize: 15; font.weight: Font.Bold; color: "#00e599" }
                    Text { text: "Completed downloads scanned via MpCmdRun / AMSI"; font.pixelSize: 11; color: "#666666" }
                }
            }

            GeistCard {
                Layout.fillWidth: true; height: 100
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 14; spacing: 4
                    Text { text: "AUTO-EXECUTION POLICY"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }
                    Text { text: "ZERO AUTO-EXECUTE"; font.pixelSize: 15; font.weight: Font.Bold; color: "#0070f3" }
                    Text { text: "Never executes binaries automatically; user remains in control"; font.pixelSize: 11; color: "#666666" }
                }
            }

            GeistCard {
                Layout.fillWidth: true; height: 100
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 14; spacing: 4
                    Text { text: "NETWORK LOCK"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }
                    Text { text: "READY (Kill-Switch)"; font.pixelSize: 15; font.weight: Font.Bold; color: "#ffffff" }
                    Text { text: "Binds sockets to adapter; prevents IP leaks on VPN drop"; font.pixelSize: 11; color: "#666666" }
                }
            }
        }

        // Security Activity & Quarantine Log
        GeistCard {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text { text: "Security Audit & Sanitization Event Log"; font.pixelSize: 14; font.weight: Font.Medium; color: "#ffffff" }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 6

                    model: ListModel {
                        ListElement { timeStr: "14:52:10"; eventType: "DEFENDER"; eventDesc: "Microsoft Defender scanned 'ubuntu-24.04.1-desktop-amd64.iso' [Result: Clean / No threats found]"; statusColor: "#00e599" }
                        ListElement { timeStr: "14:48:33"; eventType: "SANITIZER"; eventDesc: "VShieldSanitizer canonicalized download destination path to 'D:/Downloads'"; statusColor: "#0070f3" }
                        ListElement { timeStr: "14:30:12"; eventType: "NETWORK"; eventDesc: "Network Lock adapter check: Primary Gigabit Ethernet is operational"; statusColor: "#00e599" }
                    }

                    delegate: Rectangle {
                        width: parent.width
                        height: 38
                        color: "#0d0d0d"
                        border.color: "#1c1c1c"
                        border.width: 1
                        radius: 4

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 12

                            Text { text: model.timeStr; font.pixelSize: 11; font.family: "Consolas"; color: "#666666" }
                            GeistBadge { text: model.eventType; dotColor: model.statusColor }
                            Text { text: model.eventDesc; font.pixelSize: 12; color: "#cccccc"; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                    }
                }
            }
        }
    }
}
