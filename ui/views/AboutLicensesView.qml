// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Item {
    id: root

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 20

            RowLayout {
                Layout.fillWidth: true
                ColumnLayout {
                    spacing: 4
                    Text { text: "About VELOCITY & Open Source Licenses"; font.pixelSize: 20; font.weight: Font.DemiBold; color: "#ffffff" }
                    Text { text: "Intelligent Torrent Downloading for Windows 10 & 11 (64-bit)"; font.pixelSize: 13; color: "#888888" }
                }
                Item { Layout.fillWidth: true }
                GeistBadge { text: "GPL-3.0-OR-LATER"; dotColor: "#0070f3" }
            }

            // Product Manifest Card
            GeistCard {
                Layout.fillWidth: true
                height: 110
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 16; spacing: 6
                    Text { text: "VELOCITY v1.0.0-rc1 (Build 2026.11-x64)"; font.pixelSize: 15; font.weight: Font.Bold; color: "#ffffff" }
                    Text { text: "Engineered in C++20 with Qt 6 / QML and libtorrent-rasterbar. Visual design inspired by Vercel's Geist design system."; font.pixelSize: 12; color: "#cccccc" }
                    Text { text: "100% Free Software. No mandatory accounts, no cloud dependencies, no analytics, no advertisements."; font.pixelSize: 11; color: "#00e599" }
                }
            }

            // Software Bill of Materials (SBOM)
            Text { text: "THIRD-PARTY SOFTWARE BILL OF MATERIALS (SBOM)"; font.pixelSize: 11; font.weight: Font.DemiBold; color: "#888888" }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    Layout.fillWidth: true; height: 42; radius: 4; color: "#0d0d0d"; border.color: "#1c1c1c"; border.width: 1
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                        Text { text: "Qt 6 (Core, Quick, QML, RHI)"; font.pixelSize: 13; font.weight: Font.Medium; color: "#ffffff"; Layout.preferredWidth: 240 }
                        Text { text: "The Qt Company | LGPLv3 / GPLv3"; font.pixelSize: 12; color: "#888888"; Layout.fillWidth: true }
                        GeistBadge { text: "LGPLv3 COMPLIANT"; dotColor: "#00e599" }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 42; radius: 4; color: "#0d0d0d"; border.color: "#1c1c1c"; border.width: 1
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                        Text { text: "libtorrent-rasterbar 2.0.10"; font.pixelSize: 13; font.weight: Font.Medium; color: "#ffffff"; Layout.preferredWidth: 240 }
                        Text { text: "Arvid Norberg | BSD-3-Clause"; font.pixelSize: 12; color: "#888888"; Layout.fillWidth: true }
                        GeistBadge { text: "BSD-3 PERMISSIVE"; dotColor: "#00e599" }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 42; radius: 4; color: "#0d0d0d"; border.color: "#1c1c1c"; border.width: 1
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                        Text { text: "OpenSSL 3.3.1"; font.pixelSize: 13; font.weight: Font.Medium; color: "#ffffff"; Layout.preferredWidth: 240 }
                        Text { text: "OpenSSL Project | Apache-2.0"; font.pixelSize: 12; color: "#888888"; Layout.fillWidth: true }
                        GeistBadge { text: "APACHE-2.0 OK"; dotColor: "#00e599" }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 42; radius: 4; color: "#0d0d0d"; border.color: "#1c1c1c"; border.width: 1
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                        Text { text: "SQLite 3.45.3"; font.pixelSize: 13; font.weight: Font.Medium; color: "#ffffff"; Layout.preferredWidth: 240 }
                        Text { text: "D. Richard Hipp | Public Domain"; font.pixelSize: 12; color: "#888888"; Layout.fillWidth: true }
                        GeistBadge { text: "PUBLIC DOMAIN"; dotColor: "#00e599" }
                    }
                }
            }
        }
    }
}
