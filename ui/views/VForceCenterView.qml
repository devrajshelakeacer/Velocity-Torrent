// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"
import ".."

Item {
    id: root

    property string selectedProfile: (typeof velocityBridge !== "undefined") ? velocityBridge.activeProfile : "V-FORCE MAX"
    property real currentTemp: (typeof velocityBridge !== "undefined") ? velocityBridge.cpuTemp : 48.0
    property real ssdWafReduction: (typeof velocityBridge !== "undefined") ? velocityBridge.wafReduction : 90.0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 22

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text {
                    text: "V-FORCE — Hardware-Aware Maximum Performance"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeTitle
                    font.weight: Font.Bold
                    color: GeistTheme.inkPrimary
                }
                Text {
                    text: "Hardware-aware resource scaling, Direct Piece Coalescing, and user-controlled thermal policy"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeSub
                    color: GeistTheme.inkSecondary
                }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "ACTIVE: " + root.selectedProfile; dotColor: GeistTheme.accentBlue }
        }

        // Direct Piece Coalescing Cache Banner
        GeistCard {
            Layout.fillWidth: true
            height: 96

            RowLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 16

                Rectangle {
                    width: 50
                    height: 50
                    radius: GeistTheme.radiusCard
                    color: GeistTheme.surfaceSubtle
                    border.color: GeistTheme.borderCard
                    border.width: 1
                    Text { text: "⚡"; font.pixelSize: 22; anchors.centerIn: parent }
                }

                ColumnLayout {
                    spacing: 4
                    Text {
                        text: "Direct Piece Coalescing Cache (SSD Endurance Protection)"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeMedium
                        font.weight: Font.DemiBold
                        color: GeistTheme.inkPrimary
                    }
                    Text {
                        text: "Assembling incoming 16KB blocks in RAM into 4MB–16MB contiguous sequential writes | SSD Write Amplification reduced by " + root.ssdWafReduction.toFixed(1) + "%"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeSub
                        color: GeistTheme.inkSecondary
                    }
                }
            }
        }

        // Three Performance Profiles
        Text {
            text: "OPERATIONAL PROFILES"
            font.family: GeistTheme.fontSans
            font.pixelSize: GeistTheme.fontSizeMicro
            font.weight: Font.Bold
            font.letterSpacing: 0.8
            color: GeistTheme.inkSecondary
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 18

            // Profile 1: Balanced
            GeistCard {
                Layout.fillWidth: true
                height: 180
                hoverable: true
                border.color: root.selectedProfile === "BALANCED" ? GeistTheme.accentBlue : GeistTheme.borderCard

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 8
                    RowLayout {
                        Text { text: "BALANCED"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMedium; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                        Item { Layout.fillWidth: true }
                        GeistBadge { text: "128 MB RAM"; dotColor: GeistTheme.inkSecondary }
                    }
                    Text {
                        text: "Energy-efficient operation. 128 MB cache buffer, 2 hashing threads, low-power socket scheduling.";
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeSub
                        color: GeistTheme.inkSecondary
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                    Item { Layout.fillHeight: true }
                    GeistButton {
                        text: root.selectedProfile === "BALANCED" ? "Current Profile" : "Switch to Balanced"
                        variant: root.selectedProfile === "BALANCED" ? "primary" : "secondary"
                        onClicked: {
                            root.selectedProfile = "BALANCED"
                            if (typeof velocityBridge !== "undefined") velocityBridge.setProfile("BALANCED")
                        }
                    }
                }
            }

            // Profile 2: Turbo
            GeistCard {
                Layout.fillWidth: true
                height: 180
                hoverable: true
                border.color: root.selectedProfile === "TURBO" ? GeistTheme.accentBlue : GeistTheme.borderCard

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 8
                    RowLayout {
                        Text { text: "TURBO"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMedium; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                        Item { Layout.fillWidth: true }
                        GeistBadge { text: "512 MB RAM"; dotColor: GeistTheme.accentAmber }
                    }
                    Text {
                        text: "High-performance scheduling. 512 MB memory cache, 4 hash threads, dynamic request queue pipelining.";
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeSub
                        color: GeistTheme.inkSecondary
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                    Item { Layout.fillHeight: true }
                    GeistButton {
                        text: root.selectedProfile === "TURBO" ? "Current Profile" : "Switch to Turbo"
                        variant: root.selectedProfile === "TURBO" ? "primary" : "secondary"
                        onClicked: {
                            root.selectedProfile = "TURBO"
                            if (typeof velocityBridge !== "undefined") velocityBridge.setProfile("TURBO")
                        }
                    }
                }
            }

            // Profile 3: V-Force Max
            GeistCard {
                Layout.fillWidth: true
                height: 180
                hoverable: true
                border.color: root.selectedProfile === "V-FORCE MAX" ? GeistTheme.accentBlue : GeistTheme.borderCard

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 8
                    RowLayout {
                        Text { text: "V-FORCE MAX"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMedium; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                        Item { Layout.fillWidth: true }
                        GeistBadge { text: "1.5 GB RAM"; dotColor: GeistTheme.accentGreen }
                    }
                    Text {
                        text: "Maximum 200 Mbps saturation. 1.5 GB RAM cache, multi-core AVX2 hashing, sustained 24 MB/s goodput.";
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeSub
                        color: GeistTheme.inkSecondary
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                    Item { Layout.fillHeight: true }
                    GeistButton {
                        text: root.selectedProfile === "V-FORCE MAX" ? "Active Max Profile" : "Engage V-Force Max"
                        variant: root.selectedProfile === "V-FORCE MAX" ? "primary" : "secondary"
                        onClicked: {
                            root.selectedProfile = "V-FORCE MAX"
                            if (typeof velocityBridge !== "undefined") velocityBridge.setProfile("V-FORCE MAX")
                        }
                    }
                }
            }
        }

        // Thermal Guardian User-Controlled Policy Card
        GeistCard {
            Layout.fillWidth: true
            height: 130

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 8

                RowLayout {
                    Text {
                        text: "THERMAL GUARDIAN — USER AUTONOMY POLICY"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeMicro
                        font.weight: Font.Bold
                        font.letterSpacing: 0.8
                        color: GeistTheme.inkSecondary
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "CPU Core Temp: " + root.currentTemp.toFixed(1) + "°C (WMI Sensor)"
                        font.family: GeistTheme.fontMono
                        font.pixelSize: GeistTheme.fontSizeSub
                        font.weight: Font.Bold
                        color: GeistTheme.inkPrimary
                    }
                }

                Text {
                    text: "VELOCITY respects user autonomy: Thermal Guardian does NOT automatically demote your profile to Balanced at 85°C. Uninterrupted fast downloads continue with visible status warnings, reserving emergency alerts strictly for extreme hardware peak danger (>= 95°C)."
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeSub
                    color: GeistTheme.inkSecondary
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }
    }
}
