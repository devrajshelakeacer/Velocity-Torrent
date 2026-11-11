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
                Text { text: "Download History & Verification Receipts"; font.pixelSize: 20; font.weight: Font.DemiBold; color: "#ffffff" }
                Text { text: "Searchable log of completed transfers with cryptographic hash verification receipts"; font.pixelSize: 13; color: "#888888" }
            }
            Item { Layout.fillWidth: true }
            GeistButton { text: "Export Receipts (JSON)"; variant: "secondary" }
        }

        // History Rows
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8

            model: ListModel {
                ListElement { filename: "debian-12.8.0-amd64-netinst.iso"; sizeStr: "620 MB"; dateCompleted: "2026-11-10 18:22"; hashStr: "9a41b528c31048f7e6e5894101e405a2e5660142"; receiptStatus: "VERIFIED 100%" }
                ListElement { filename: "Fedora-Workstation-Live-x86_64-41.iso"; sizeStr: "2.14 GB"; dateCompleted: "2026-11-09 11:05"; hashStr: "7c12f45812e987f101e405a2e5669a41b528c310"; receiptStatus: "VERIFIED 100%" }
                ListElement { filename: "kali-linux-2026.4-live-amd64.iso"; sizeStr: "4.12 GB"; dateCompleted: "2026-11-08 22:41"; hashStr: "b8e0586e5894101e405a2e53fa85f6457174b268"; receiptStatus: "VERIFIED 100%" }
            }

            delegate: Rectangle {
                width: parent.width
                height: 56
                color: "#0a0a0a"
                border.color: "#1a1a1a"
                border.width: 1
                radius: 6

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text { text: model.filename; font.pixelSize: 13; font.weight: Font.Medium; color: "#ffffff" }
                        Text { text: "SHA-1: " + model.hashStr; font.pixelSize: 11; font.family: "Consolas"; color: "#666666" }
                    }

                    Text { text: model.sizeStr; font.pixelSize: 12; font.family: "Consolas"; color: "#888888" }
                    Text { text: model.dateCompleted; font.pixelSize: 11; color: "#666666" }
                    GeistBadge { text: model.receiptStatus; dotColor: "#00e599" }
                    GeistButton { text: "Open Folder"; implicitHeight: 28; implicitWidth: 85 }
                }
            }
        }
    }
}
