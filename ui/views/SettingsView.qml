// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
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
                Text { text: "Settings & Preferences"; font.pixelSize: 20; font.weight: Font.DemiBold; color: "#ffffff" }
                Text { text: "Manage local download pathways, network interfaces, V-FORCE profiles, and security parameters"; font.pixelSize: 13; color: "#888888" }
            }
            Item { Layout.fillWidth: true }
            GeistButton { text: "Save Changes"; variant: "primary" }
        }

        // Settings Category Cards
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth
            clip: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 16

                // Section 1: Downloads
                GeistCard {
                    Layout.fillWidth: true
                    height: 140
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 16; spacing: 8
                        Text { text: "DEFAULT DOWNLOAD PATHWAYS"; font.pixelSize: 13; font.weight: Font.DemiBold; color: "#ffffff" }
                        Text { text: "Completed Torrents Destination:"; font.pixelSize: 12; color: "#888888" }
                        Rectangle {
                            Layout.fillWidth: true; height: 34; color: "#111111"; border.color: "#262626"; border.width: 1; radius: 4
                            RowLayout {
                                anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 8
                                Text { text: "D:/Downloads"; font.pixelSize: 12; font.family: "Consolas"; color: "#ffffff"; Layout.fillWidth: true }
                                GeistButton { text: "Browse..."; implicitHeight: 26; implicitWidth: 70 }
                            }
                        }
                    }
                }

                // Section 2: V-FORCE & Thermal
                GeistCard {
                    Layout.fillWidth: true
                    height: 120
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 16; spacing: 8
                        Text { text: "V-FORCE & THERMAL GUARDIAN POLICY"; font.pixelSize: 13; font.weight: Font.DemiBold; color: "#ffffff" }
                        Text { text: "Default Profile on Startup: V-FORCE MAX (1.5 GB cache, full 24 MB/s throughput)"; font.pixelSize: 12; color: "#cccccc" }
                        Text { text: "Thermal Guardian Policy: User Autonomy (No auto-downgrade to Balanced at 85°C; warnings displayed)."; font.pixelSize: 11; color: "#00e599" }
                    }
                }

                // Section 3: V-SHIELD Security
                GeistCard {
                    Layout.fillWidth: true
                    height: 120
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 16; spacing: 8
                        Text { text: "V-SHIELD SECURITY & ANTIVIRUS INTEGRATION"; font.pixelSize: 13; font.weight: Font.DemiBold; color: "#ffffff" }
                        Text { text: "Microsoft Defender Scanning: Enabled (automatic quarantine on threat detection)"; font.pixelSize: 12; color: "#cccccc" }
                        Text { text: "Automatic Execution: Strictly Prohibited (Protects host from malicious payloads)"; font.pixelSize: 11; color: "#0070f3" }
                    }
                }
            }
        }
    }
}
