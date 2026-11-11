// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"

Item {
    id: root

    property string selectedProfile: "V-FORCE MAX"
    property real currentTemp: 48.0
    property real ssdWafReduction: 88.5

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text { text: "V-FORCE — Maximum Safe Performance & Thermal Guardian"; font.pixelSize: 20; font.weight: Font.DemiBold; color: "#ffffff" }
                Text { text: "Hardware-aware resource scaling, Direct Piece Coalescing, and user-first thermal management"; font.pixelSize: 13; color: "#888888" }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "ACTIVE: " + root.selectedProfile; dotColor: "#0070f3" }
        }

        // Direct Piece Coalescing Cache Banner
        GeistCard {
            Layout.fillWidth: true
            height: 90

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                Rectangle {
                    width: 48; height: 48; radius: 24; color: "#111111"; border.color: "#222222"; border.width: 1
                    Text { text: "⚡"; font.pixelSize: 22; anchors.centerIn: parent }
                }

                ColumnLayout {
                    spacing: 4
                    Text {
                        text: "Direct Piece Coalescing Cache (SSD Endurance Protection)"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: "#ffffff"
                    }
                    Text {
                        text: "Assembling incoming 16KB blocks in RAM into 4MB–16MB contiguous writes | SSD Write Amplification reduced by " + root.ssdWafReduction.toFixed(1) + "%"
                        font.pixelSize: 12
                        color: "#00e599"
                    }
                }
            }
        }

        // Three Performance Profiles
        Text { text: "OPERATIONAL PROFILES"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            // Profile 1: Balanced
            GeistCard {
                Layout.fillWidth: true
                height: 160
                hoverable: true
                border.color: root.selectedProfile === "BALANCED" ? "#0070f3" : "#1f1f1f"

                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 16; spacing: 8
                    RowLayout {
                        Text { text: "BALANCED"; font.pixelSize: 15; font.weight: Font.DemiBold; color: "#ffffff" }
                        Item { Layout.fillWidth: true }
                        GeistBadge { text: "128 MB RAM"; dotColor: "#888888" }
                    }
                    Text { text: "Energy-efficient operation. 128 MB disk cache, 2 hash worker threads, standard socket buffers. Silent fan profile."; font.pixelSize: 12; color: "#888888"; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    Item { Layout.fillHeight: true }
                    GeistButton {
                        text: root.selectedProfile === "BALANCED" ? "Current Profile" : "Switch to Balanced"
                        variant: root.selectedProfile === "BALANCED" ? "primary" : "secondary"
                        onClicked: root.selectedProfile = "BALANCED"
                    }
                }
            }

            // Profile 2: Turbo
            GeistCard {
                Layout.fillWidth: true
                height: 160
                hoverable: true
                border.color: root.selectedProfile === "TURBO" ? "#0070f3" : "#1f1f1f"

                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 16; spacing: 8
                    RowLayout {
                        Text { text: "TURBO"; font.pixelSize: 15; font.weight: Font.DemiBold; color: "#ffffff" }
                        Item { Layout.fillWidth: true }
                        GeistBadge { text: "512 MB RAM"; dotColor: "#f5a623" }
                    }
                    Text { text: "Performance scheduling. 512 MB memory cache, 4 hash worker threads, dynamic request pipelining."; font.pixelSize: 12; color: "#888888"; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    Item { Layout.fillHeight: true }
                    GeistButton {
                        text: root.selectedProfile === "TURBO" ? "Current Profile" : "Switch to Turbo"
                        variant: root.selectedProfile === "TURBO" ? "primary" : "secondary"
                        onClicked: root.selectedProfile = "TURBO"
                    }
                }
            }

            // Profile 3: V-Force Max
            GeistCard {
                Layout.fillWidth: true
                height: 160
                hoverable: true
                border.color: root.selectedProfile === "V-FORCE MAX" ? "#0070f3" : "#1f1f1f"

                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 16; spacing: 8
                    RowLayout {
                        Text { text: "V-FORCE MAX"; font.pixelSize: 15; font.weight: Font.DemiBold; color: "#ffffff" }
                        Item { Layout.fillWidth: true }
                        GeistBadge { text: "1.5 GB RAM"; dotColor: "#00e599" }
                    }
                    Text { text: "Maximum throughput. 1.5 GB cache, full AVX2 multi-core hashing, deep Winsock buffers. Sustains full 24 MB/s."; font.pixelSize: 12; color: "#888888"; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    Item { Layout.fillHeight: true }
                    GeistButton {
                        text: root.selectedProfile === "V-FORCE MAX" ? "Active Max Profile" : "Engage V-Force Max"
                        variant: root.selectedProfile === "V-FORCE MAX" ? "primary" : "secondary"
                        onClicked: root.selectedProfile = "V-FORCE MAX"
                    }
                }
            }
        }

        // Thermal Guardian User-Controlled Policy Card
        GeistCard {
            Layout.fillWidth: true
            height: 120

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                RowLayout {
                    Text { text: "THERMAL GUARDIAN — USER AUTONOMY POLICY"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }
                    Item { Layout.fillWidth: true }
                    Text { text: "CPU Temperature: " + root.currentTemp.toFixed(1) + "°C (WMI Sensor)"; font.pixelSize: 12; font.family: "Consolas"; color: "#00e599" }
                }

                Text {
                    text: "VELOCITY respects user autonomy: Thermal Guardian does NOT automatically demote your profile to Balanced at 85°C. Uninterrupted fast downloads continue with visible warnings, reserving emergency alerts strictly for extreme hardware peak danger (>= 95°C)."
                    font.pixelSize: 12
                    color: "#cccccc"
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }
    }
}
