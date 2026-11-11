// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15

Item {
    id: chart

    property var dataPoints: []
    property real maxValue: 25.0 // 25 MB/s
    property color lineColor: "#0070f3"
    property color fillColor: "#100070f3"

    implicitHeight: 140
    implicitWidth: 400

    Canvas {
        id: canvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var w = width;
            var h = height;

            // Draw subtle horizontal grid lines (0, 10, 20, 25 MB/s)
            ctx.strokeStyle = "#1a1a1a";
            ctx.lineWidth = 1;
            ctx.setLineDash([4, 4]);

            for (var val = 5; val <= chart.maxValue; val += 5) {
                var y = h - (val / chart.maxValue) * (h - 10);
                ctx.beginPath();
                ctx.moveTo(0, y);
                ctx.lineTo(w, y);
                ctx.stroke();
            }

            ctx.setLineDash([]);

            if (!chart.dataPoints || chart.dataPoints.length < 2) return;

            var step = w / (chart.dataPoints.length - 1);

            // Draw filled gradient area
            ctx.beginPath();
            ctx.moveTo(0, h);

            for (var i = 0; i < chart.dataPoints.length; i++) {
                var ptY = h - (chart.dataPoints[i] / chart.maxValue) * (h - 12);
                ctx.lineTo(i * step, ptY);
            }

            ctx.lineTo(w, h);
            ctx.closePath();

            var grad = ctx.createLinearGradient(0, 0, 0, h);
            grad.addColorStop(0, chart.fillColor);
            grad.addColorStop(1, "transparent");
            ctx.fillStyle = grad;
            ctx.fill();

            // Draw crisp line
            ctx.beginPath();
            for (var j = 0; j < chart.dataPoints.length; j++) {
                var lineY = h - (chart.dataPoints[j] / chart.maxValue) * (h - 12);
                if (j === 0) ctx.moveTo(0, lineY);
                else ctx.lineTo(j * step, lineY);
            }
            ctx.strokeStyle = chart.lineColor;
            ctx.lineWidth = 2;
            ctx.stroke();
        }
    }

    onDataPointsChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
}
