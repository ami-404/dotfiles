import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property bool active: false

    property int barCount: 16

    property color barColor: "#cba6f7"

    property var levels: []

    Process {
        id: cavaProcess

        command: [
            "bash",
            "-c",
            Quickshell.env("HOME") +
            "/.config/quickshell/scripts/cava-run"
        ]

        running: root.active

        stdout: SplitParser {
            onRead: function(line) {
                line = line.trim()

                if (!line.length)
                    return

                var parts = line.split(";")
                var values = []

                for (var i = 0; i < parts.length; ++i) {
                    if (!parts[i].length)
                        continue

                    var value = parseFloat(parts[i])

                    if (!isNaN(value)) {
                        values.push(
                            Math.max(
                                0,
                                Math.min(1, value / 100)
                            )
                        )
                    }
                }

                if (values.length > 0) {
                    root.levels = values
                    canvas.requestPaint()
                }
            }
        }

        stderr: SplitParser {
            onRead: function(line) {
                if (line.trim().length)
                    console.log("[CAVA]", line)
            }
        }
    }

    Canvas {
        id: canvas

        anchors.fill: parent

        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d")

            var w = width
            var h = height

            ctx.clearRect(0, 0, w, h)

            if (w < 1 || h < 1)
                return

            var values = root.levels

            if (!values || values.length === 0)
                return

            var count = Math.min(
                root.barCount,
                values.length
            )

            // Thin bars like QuattroWave
            var gap = 2
            var barWidth = 2

            // Center the whole spectrum
            var totalWidth =
                count * barWidth +
                (count - 1) * gap

            var startX =
                Math.max(0, (w - totalWidth) / 2)

            for (var i = 0; i < count; ++i) {

                var level = values[i]

                // Prevent bars from completely disappearing
                var shown = Math.max(
                    level,
                    0.06
                )

                var barHeight =
                    Math.max(
                        1,
                        Math.round(h * shown)
                    )

                var x =
                    startX +
                    i * (barWidth + gap)

                var y =
                    h - barHeight

                ctx.fillStyle = root.barColor

                ctx.fillRect(
                    Math.round(x),
                    Math.round(y),
                    barWidth,
                    barHeight
                )
            }
        }
    }

    Component.onDestruction: {
        cavaProcess.running = false
    }
}