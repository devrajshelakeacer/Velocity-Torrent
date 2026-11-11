// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."

Button {
    id: control

    property string variant: "secondary" // "primary", "secondary", "blue", "danger"
    property string iconSource: ""

    implicitHeight: 36
    implicitWidth: Math.max(96, contentItem.implicitWidth + 28)

    contentItem: Row {
        spacing: 8
        anchors.centerIn: parent

        Text {
            text: control.text
            font.family: GeistTheme.fontSans
            font.pixelSize: GeistTheme.fontSizeSub
            font.weight: (control.variant === "primary" || control.variant === "blue") ? Font.DemiBold : Font.Medium
            color: {
                if (control.variant === "primary") {
                    return "#000000"
                } else if (control.variant === "blue") {
                    return "#ffffff"
                } else if (control.variant === "danger") {
                    return "#ff5555"
                } else {
                    return control.hovered ? "#ffffff" : "#d4d4d4"
                }
            }
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: Rectangle {
        implicitHeight: 36
        radius: GeistTheme.radiusMedium
        color: {
            if (control.variant === "primary") {
                return control.down ? "#cccccc" : (control.hovered ? "#e6e6e6" : "#ffffff")
            } else if (control.variant === "blue") {
                return control.down ? "#0050bf" : (control.hovered ? "#0060df" : "#0070f3")
            } else if (control.variant === "danger") {
                return control.down ? "#330d0d" : (control.hovered ? "#260808" : "#1a0505")
            } else {
                return control.down ? "#1f1f1f" : (control.hovered ? "#141414" : "#0a0a0a")
            }
        }
        border.color: {
            if (control.visualFocus) return "#0070f3"
            if (control.variant === "primary" || control.variant === "blue") return "transparent"
            if (control.variant === "danger") return control.hovered ? "#662222" : "#3d1414"
            return control.hovered ? "#444444" : "#262626"
        }
        border.width: 1

        Behavior on color { ColorAnimation { duration: 120 } }
        Behavior on border.color { ColorAnimation { duration: 120 } }
    }
}
