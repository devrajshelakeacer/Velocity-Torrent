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
                    text: "Download History & Verification Receipts"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeTitle
                    font.weight: Font.Bold
                    color: GeistTheme.inkPrimary
                }
                Text {
                    text: "Searchable audit trail of completed transfers with cryptographic hash verification receipts"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeSub
                    color: GeistTheme.inkSecondary
                }
            }
            Item { Layout.fillWidth: true }
            GeistButton { text: "Export Receipts (JSON)"; variant: "secondary" }
        }

        // History Rows
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 10

            model: ListModel {
                ListElement { filename: "debian-12.8.0-amd64-netinst.iso"; sizeStr: "620 MB"; dateCompleted: "2026-11-10 18:22"; hashStr: "9a41b528c31048f7e6e5894101e405a2e5660142"; receiptStatus: "VERIFIED 100%" }
                ListElement { filename: "Fedora-Workstation-Live-x86_64-41.iso"; sizeStr: "2.14 GB"; dateCompleted: "2026-11-09 11:05"; hashStr: "7c12f45812e987f101e405a2e5669a41b528c310"; receiptStatus: "VERIFIED 100%" }
                ListElement { filename: "kali-linux-2026.4-live-amd64.iso"; sizeStr: "4.12 GB"; dateCompleted: "2026-11-08 22:41"; hashStr: "b8e0586e5894101e405a2e53fa85f6457174b268"; receiptStatus: "VERIFIED 100%" }
            }

            delegate: Rectangle {
                width: parent.width
                height: 60
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
                    spacing: 16

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3
                        Text {
                            text: model.filename
                            font.family: GeistTheme.fontSans
                            font.pixelSize: GeistTheme.fontSizeBody
                            font.weight: Font.Medium
                            color: GeistTheme.inkPrimary
                        }
                        Text {
                            text: "SHA-1: " + model.hashStr
                            font.family: GeistTheme.fontMono
                            font.pixelSize: GeistTheme.fontSizeMicro
                            color: GeistTheme.inkSecondary
                        }
                    }

                    Text {
                        text: model.sizeStr
                        font.family: GeistTheme.fontMono
                        font.pixelSize: GeistTheme.fontSizeSub
                        color: GeistTheme.inkPrimary
                    }

                    Text {
                        text: model.dateCompleted
                        font.family: GeistTheme.fontSans
                        font.pixelSize: GeistTheme.fontSizeMicro
                        color: GeistTheme.inkSecondary
                    }

                    GeistBadge {
                        text: model.receiptStatus
                        dotColor: GeistTheme.accentGreen
                    }
                }
            }
        }
    }
}
