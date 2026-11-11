// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import ".."

Item {
    id: root

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 28
            spacing: 22

            RowLayout {
                Layout.fillWidth: true
                ColumnLayout {
                    spacing: 4
                    Text {
                        text: "About VELOCITY & Open Source Licenses"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeTitle
                        font.weight: Font.Bold
                        color: GeistTheme.inkPrimary
                    }
                    Text {
                        text: "Intelligent Torrent Downloading for Windows 10 & 11 (64-bit)"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeSub
                        color: GeistTheme.inkSecondary
                    }
                }
                Item { Layout.fillWidth: true }
                GeistBadge { text: "GPL-3.0-OR-LATER"; dotColor: GeistTheme.accentBlue }
            }

            // Product Manifest Card
            GeistCard {
                Layout.fillWidth: true
                height: 124

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 8
                    Text {
                        text: "VELOCITY v1.0.0-rc1 (Build 2026.11-x64)"
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeMedium
                        font.weight: Font.Bold
                        color: GeistTheme.inkPrimary
                    }
                    Text {
                        text: "Engineered in C++20 with Qt 6 / QML and libtorrent-rasterbar. Visual design crafted following Vercel's Geist design principles."
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeSub
                        color: GeistTheme.inkSecondary
                    }
                    Text {
                        text: "100% Free Software. No accounts, no subscriptions, no cloud tracking, no advertisements."
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeMicro
                        color: GeistTheme.inkPrimary
                    }
                }
            }

            // Software Bill of Materials (SBOM)
            Text {
                text: "THIRD-PARTY SOFTWARE BILL OF MATERIALS (SBOM)"
                font.family: GeistTheme.fontSans
                font.pixelSize: GeistTheme.fontSizeMicro
                font.weight: Font.Bold
                font.letterSpacing: 0.8
                color: GeistTheme.inkSecondary
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: GeistTheme.radiusMedium
                    color: GeistTheme.surfaceSubtle
                    border.color: GeistTheme.borderCard
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 18
                        anchors.rightMargin: 18
                        Text { text: "Qt 6 (Core, Quick, QML, RHI)"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeBody; font.weight: Font.Medium; color: GeistTheme.inkPrimary; Layout.preferredWidth: 260 }
                        Text { text: "The Qt Company | LGPLv3 / GPLv3"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeSub; color: GeistTheme.inkSecondary; Layout.fillWidth: true }
                        GeistBadge { text: "LGPLv3 COMPLIANT"; dotColor: GeistTheme.accentGreen }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: GeistTheme.radiusMedium
                    color: GeistTheme.surfaceSubtle
                    border.color: GeistTheme.borderCard
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 18
                        anchors.rightMargin: 18
                        Text { text: "libtorrent-rasterbar v2.0.10"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeBody; font.weight: Font.Medium; color: GeistTheme.inkPrimary; Layout.preferredWidth: 260 }
                        Text { text: "Arvid Norberg | BSD-3-Clause"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeSub; color: GeistTheme.inkSecondary; Layout.fillWidth: true }
                        GeistBadge { text: "BSD COMPLIANT"; dotColor: GeistTheme.accentGreen }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: GeistTheme.radiusMedium
                    color: GeistTheme.surfaceSubtle
                    border.color: GeistTheme.borderCard
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 18
                        anchors.rightMargin: 18
                        Text { text: "OpenSSL v3.3.1"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeBody; font.weight: Font.Medium; color: GeistTheme.inkPrimary; Layout.preferredWidth: 260 }
                        Text { text: "OpenSSL Project | Apache-2.0"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeSub; color: GeistTheme.inkSecondary; Layout.fillWidth: true }
                        GeistBadge { text: "APACHE-2.0"; dotColor: GeistTheme.accentGreen }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: GeistTheme.radiusMedium
                    color: GeistTheme.surfaceSubtle
                    border.color: GeistTheme.borderCard
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 18
                        anchors.rightMargin: 18
                        Text { text: "Inter Font Family"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeBody; font.weight: Font.Medium; color: GeistTheme.inkPrimary; Layout.preferredWidth: 260 }
                        Text { text: "Rasmus Andersson | SIL Open Font License 1.1"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeSub; color: GeistTheme.inkSecondary; Layout.fillWidth: true }
                        GeistBadge { text: "OFL-1.1"; dotColor: GeistTheme.accentGreen }
                    }
                }
            }
        }
    }
}
