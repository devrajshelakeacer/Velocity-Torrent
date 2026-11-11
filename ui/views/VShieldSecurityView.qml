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
        spacing: 22

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text {
                    text: "V-SHIELD — Zero-Trust Security & Isolation"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeTitle
                    font.weight: Font.Bold
                    color: GeistTheme.inkPrimary
                }
                Text {
                    text: "Path traversal barriers, Microsoft Defender scanning, zero auto-execution, and Network Lock"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeSub
                    color: GeistTheme.inkSecondary
                }
            }
            Item { Layout.fillWidth: true }
            GeistBadge { text: "V-SHIELD ENFORCED"; dotColor: GeistTheme.accentGreen }
        }

        // 4 Security Posture Cards
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            GeistCard {
                Layout.fillWidth: true; height: 110
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 16; spacing: 4
                    Text { text: "PATH TRAVERSAL GUARD"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary }
                    Text { text: "ACTIVE (Isolated)"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMedium; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                    Text { text: "Canonicalized paths; NTFS ADS stripped"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                }
            }

            GeistCard {
                Layout.fillWidth: true; height: 110
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 16; spacing: 4
                    Text { text: "MICROSOFT DEFENDER"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary }
                    Text { text: "CONNECTED (Auto-Scan)"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMedium; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                    Text { text: "Completed downloads scanned via MpCmdRun"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                }
            }

            GeistCard {
                Layout.fillWidth: true; height: 110
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 16; spacing: 4
                    Text { text: "AUTO-EXECUTION POLICY"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary }
                    Text { text: "ZERO AUTO-EXECUTE"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMedium; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                    Text { text: "Never executes binaries; user in control"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                }
            }

            GeistCard {
                Layout.fillWidth: true; height: 110
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 16; spacing: 4
                    Text { text: "NETWORK LOCK KILL-SWITCH"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; font.weight: Font.Bold; font.letterSpacing: 0.8; color: GeistTheme.inkSecondary }
                    Text { text: "ARMED & READY"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMedium; font.weight: Font.Bold; color: GeistTheme.inkPrimary }
                    Text { text: "Zero IP leaks on VPN/interface drop"; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary }
                }
            }
        }

        // Security Audit & Quarantine Log
        GeistCard {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12

                Text {
                    text: "V-Shield Real-Time Security Audit Log"
                    font.family: GeistTheme.fontSans
                    font.pixelSize: GeistTheme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: GeistTheme.inkPrimary
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 8

                    model: ListModel {
                        ListElement { timeStr: "15:42:01"; eventStr: "Sanitized path: stripped invalid NTFS reparse point '\\..\\..\\Windows\\System32'"; level: "INFO" }
                        ListElement { timeStr: "15:42:04"; eventStr: "Microsoft Defender scan passed: ubuntu-24.04.1-desktop-amd64.iso (Clean)"; level: "SUCCESS" }
                        ListElement { timeStr: "15:42:08"; eventStr: "Stripped alternate data stream (Zone.Identifier) on piece hash commit"; level: "INFO" }
                        ListElement { timeStr: "15:42:12"; eventStr: "Memory limit guard active: 1.5 GB allocated within 16 GB physical RAM envelope"; level: "SUCCESS" }
                    }

                    delegate: Rectangle {
                        width: parent.width
                        height: 38
                        color: GeistTheme.surfaceSubtle
                        radius: GeistTheme.radiusSmall
                        border.color: GeistTheme.borderHairline
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 12

                            Text { text: model.timeStr; font.family: GeistTheme.fontMono; font.pixelSize: GeistTheme.fontSizeMicro; color: GeistTheme.inkSecondary; Layout.preferredWidth: 70 }
                            Text { text: model.eventStr; font.family: GeistTheme.fontSans; font.pixelSize: GeistTheme.fontSizeSub; color: GeistTheme.inkPrimary; Layout.fillWidth: true }
                            GeistBadge { text: model.level; dotColor: model.level === "SUCCESS" ? GeistTheme.accentGreen : GeistTheme.accentBlue }
                        }
                    }
                }
            }
        }
    }
}
