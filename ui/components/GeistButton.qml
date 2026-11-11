// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: control

    property string variant: "secondary" // "primary", "secondary", "danger"
    property string iconSource: ""

    implicitHeight: 34
    implicitWidth: Math.max(90, contentItem.implicitWidth + 24)

    contentItem: Row {
        spacing: 6
        anchors.centerIn: parent

        Text {
            text: control.text
            font.pixelSize: 13
            font.weight: Font.Medium
            font.family: "Segoe UI, sans-serif"
            color: {
                if (control.variant === "primary") {
                    return "#ffffff"
                } else if (control.variant === "danger") {
                    return "#ff3333"
                } else {
                    return control.hovered ? "#ffffff" : "#cccccc"
                }
            }
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: Rectangle {
        implicitHeight: 34
        radius: 6
        color: {
            if (control.variant === "primary") {
                return control.down ? "#005bb5" : (control.hovered ? "#0070f3" : "#0062cc")
            } else if (control.variant === "danger") {
                return control.down ? "#331111" : (control.hovered ? "#221111" : "transparent")
            } else {
                return control.down ? "#222222" : (control.hovered ? "#161616" : "transparent")
            }
        }
        border.color: {
            if (control.visualFocus) return "#0070f3"
            if (control.variant === "primary") return "transparent"
            if (control.variant === "danger") return control.hovered ? "#ff3333" : "#552222"
            return control.hovered ? "#444444" : "#262626"
        }
        border.width: 1

        Behavior on color { ColorAnimation { duration: 120 } }
        Behavior on border.color { ColorAnimation { duration: 120 } }
    }
}
