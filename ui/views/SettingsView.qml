// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import ".."

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 24

        // Settings View Header
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text {
                    text: "Settings & Preferences"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeTitle
                    font.weight: Font.Bold
                    color: GeistTheme.inkPrimary
                }
                Text {
                    text: "Configure local storage pathways, network interfaces, V-FORCE engine profiles, and security parameters"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeSub
                    color: GeistTheme.inkSecondary
                }
            }
            Item { Layout.fillWidth: true }
            GeistButton {
                text: "Save Changes"
                variant: "primary"
            }
        }

        // Settings Category Cards (Clean Monochromatic Hierarchy)
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth
            clip: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 20

                // Section 1: Storage Pathways
                GeistCard {
                    Layout.fillWidth: true
                    height: 160

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12

                        Text {
                            text: "DEFAULT DOWNLOAD PATHWAYS"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMicro
                            font.weight: Font.Bold
                            font.letterSpacing: 0.8
                            color: GeistTheme.inkSecondary
                        }

                        Text {
                            text: "Target directory for verified completed files and metadata assemblies:"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeSub
                            color: GeistTheme.inkPrimary
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            color: GeistTheme.surfaceSubtle
                            border.color: GeistTheme.borderCard
                            border.width: 1
                            radius: GeistTheme.radiusMedium

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 14
                                anchors.rightMargin: 8

                                Text {
                                    text: "D:/Downloads/Velocity"
                                    font.family: GeistTheme.fontMono
                                    font.pixelSize: GeistTheme.fontSizeSub
                                    color: GeistTheme.inkPrimary
                                    Layout.fillWidth: true
                                }

                                GeistButton {
                                    text: "Browse..."
                                    implicitHeight: 28
                                    implicitWidth: 84
                                }
                            }
                        }
                    }
                }

                // Section 2: V-FORCE & Thermal Policy
                GeistCard {
                    Layout.fillWidth: true
                    height: 140

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 10

                        Text {
                            text: "V-FORCE & THERMAL GUARDIAN POLICY"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMicro
                            font.weight: Font.Bold
                            font.letterSpacing: 0.8
                            color: GeistTheme.inkSecondary
                        }

                        Text {
                            text: "Default Profile on Launch: V-FORCE MAX (1.5 GB cache, sequential coalescing, 24 MB/s goodput)"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeSub
                            font.weight: Font.Medium
                            color: GeistTheme.inkPrimary
                        }

                        Text {
                            text: "Thermal Guardian Mode: User Autonomy (No automatic down-shifting to Balanced at 85°C; alert banner displayed while maintaining download throughput)."
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMicro
                            color: GeistTheme.inkSecondary
                        }
                    }
                }

                // Section 3: V-SHIELD Security
                GeistCard {
                    Layout.fillWidth: true
                    height: 140

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 10

                        Text {
                            text: "V-SHIELD ZERO-TRUST SECURITY"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMicro
                            font.weight: Font.Bold
                            font.letterSpacing: 0.8
                            color: GeistTheme.inkSecondary
                        }

                        Text {
                            text: "Microsoft Defender Integration: Enabled (Background telemetry & threat quarantining)"
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeSub
                            font.weight: Font.Medium
                            color: GeistTheme.inkPrimary
                        }

                        Text {
                            text: "Execution Guard: Automatic launch of binary payloads is strictly prohibited to protect system integrity."
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeMicro
                            color: GeistTheme.inkSecondary
                        }
                    }
                }
            }
        }
    }
}
