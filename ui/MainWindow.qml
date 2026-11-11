// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import "components"
import "views"

Window {
    id: appWindow
    width: 1240
    height: 800
    minimumWidth: 960
    minimumHeight: 640
    visible: true
    title: "VELOCITY — Intelligent Torrent Downloading"
    color: "#000000"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Persistent Left Sidebar
        Sidebar {
            id: navSidebar
            Layout.fillHeight: true
            currentViewIndex: stackContainer.currentIndex
            onViewSelected: function(idx) {
                stackContainer.currentIndex = idx;
            }
        }

        // Main View Stack
        StackLayout {
            id: stackContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: 0

            DashboardView {}             // 0
            AllDownloadsView {}          // 1
            TorrentDetailsView {}        // 2
            PeerExplorerView {}          // 3
            NetworkMonitorView {}        // 4
            V200PerformanceView {}       // 5
            VForceCenterView {}          // 6
            VShieldSecurityView {}       // 7
            DownloadIntelligenceView {}  // 8
            SettingsView {}              // 9
            DownloadHistoryView {}       // 10
            AboutLicensesView {}         // 11
        }
    }
}
