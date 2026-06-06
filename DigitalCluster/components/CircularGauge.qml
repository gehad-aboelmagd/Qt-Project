import QtQuick
import QtQuick.Shapes

Item {
    id: root
    width: 320
    height: 320
    clip: false

    property real value: 0
    property real minValue: 0
    property real maxValue: 100
    property color accentColor: "#00e5ff"

    property real smoothValue: value
    property string label: ""
    property string unit: ""

    readonly property int gaugeRadius: 120
    readonly property int tickRadius: gaugeRadius - 28
    readonly property real progress:
        Math.max(0, Math.min(1, smoothValue / maxValue))

    property real simTime: 0          // drives the sine simulation

    property real animatedSweep: 0

    readonly property real driveSweep:
        rpmMode
            ? (3500 / 8000) * 280
            : (120 / 260) * 280

    readonly property real sportSweep:
        rpmMode
            ? ((6000 - 3500) / 8000) * 280
            : ((200 - 120) / 260) * 280

    readonly property real redlineSweep:
        280 - driveSweep - sportSweep

    property bool rpmMode: false

    property bool scaleThousands: false

    onValueChanged: smoothValue = value

    Behavior on smoothValue {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    onProgressChanged: {
        sweepAnimation.to = progress * 280
        sweepAnimation.restart()
    }

    NumberAnimation {
        id: sweepAnimation
        target: root
        property: "animatedSweep"
        duration: 300
        easing.type: Easing.OutCubic
    }

    // ──────────────────────────────────────────────────────────────

    function angleForValue(v) {
        return -140 + ((v / maxValue) * 280)
    }

    // background arc
    Shape {
        anchors.fill: parent
        ShapePath {
            strokeWidth: 14
            strokeColor: "#1a2233"
            fillColor: "transparent"
            PathAngleArc {
                centerX: 160; centerY: 160
                radiusX: root.gaugeRadius; radiusY: root.gaugeRadius
                startAngle: 130
                sweepAngle: 280
            }
        }
    }


    // DRIVE Zone — dark navy → cyan gradient
    Repeater {
        model: 30
        delegate: Shape {
            anchors.fill: parent
            visible: {
                var zoneStart = 0
                var zoneEnd = root.driveSweep
                var sliceStart = zoneStart + index * (zoneEnd / 30)
                return root.animatedSweep > sliceStart
            }
            ShapePath {
                strokeWidth: 14
                fillColor: "transparent"
                strokeColor: {
                    var t = index / 29
                    var r = Math.round(0 + t * 0)
                    var g = Math.round(80 + t * (229 - 80))
                    var b = Math.round(120 + t * (255 - 120))
                    return Qt.rgba(r/255, g/255, b/255, 1)
                }
                PathAngleArc {
                    centerX: 160; centerY: 160
                    radiusX: root.gaugeRadius; radiusY: root.gaugeRadius
                    startAngle: 130 + index * (root.driveSweep / 30)
                    sweepAngle: Math.min(
                        root.driveSweep / 30,
                        root.animatedSweep - index * (root.driveSweep / 30)
                    )
                }
            }
        }
    }

    // SPORT Zone — cyan → green gradient
    Repeater {
        model: 30
        delegate: Shape {
            anchors.fill: parent
            visible: root.animatedSweep > root.driveSweep + index * (root.sportSweep / 30)
            ShapePath {
                strokeWidth: 14
                fillColor: "transparent"
                strokeColor: {
                    var t = index / 29
                    var r = Math.round(0 + t * 0)
                    var g = Math.round(229 + t * (255 - 229))
                    var b = Math.round(255 + t * (136 - 255))
                    return Qt.rgba(r/255, g/255, b/255, 1)
                }
                PathAngleArc {
                    centerX: 160; centerY: 160
                    radiusX: root.gaugeRadius; radiusY: root.gaugeRadius
                    startAngle: 130 + root.driveSweep + index * (root.sportSweep / 30)
                    sweepAngle: Math.min(
                        root.sportSweep / 30,
                        root.animatedSweep - root.driveSweep - index * (root.sportSweep / 30)
                    )
                }
            }
        }
    }

    // REDLINE Zone — green → red gradient
    Repeater {
        model: 30
        delegate: Shape {
            anchors.fill: parent
            visible: root.animatedSweep > root.driveSweep + root.sportSweep + index * (root.redlineSweep / 30)
            ShapePath {
                strokeWidth: 14
                fillColor: "transparent"
                strokeColor: {
                    var t = index / 29
                    var r = Math.round(0 + t * 255)
                    var g = Math.round(255 + t * (51 - 255))
                    var b = Math.round(136 + t * (51 - 136))
                    return Qt.rgba(r/255, g/255, b/255, 1)
                }
                PathAngleArc {
                    centerX: 160; centerY: 160
                    radiusX: root.gaugeRadius; radiusY: root.gaugeRadius
                    startAngle: 130 + root.driveSweep + root.sportSweep + index * (root.redlineSweep / 30)
                    sweepAngle: Math.min(
                        root.redlineSweep / 30,
                        root.animatedSweep - root.driveSweep - root.sportSweep - index * (root.redlineSweep / 30)
                    )
                }
            }
        }
    }

    // START cap — nudged back by 3°
    Shape {
        z: 10
        anchors.fill: parent
        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillColor: Qt.rgba(0, 80/255, 120/255, 1)
            PathAngleArc {
                centerX: 160 + root.gaugeRadius * Math.cos((130 - 3) * Math.PI / 180)
                centerY: 160 + root.gaugeRadius * Math.sin((130 - 3) * Math.PI / 180)
                radiusX: 7; radiusY: 7
                startAngle: 0; sweepAngle: 360
            }
        }
    }

    // END cap — nudged forward by 3° to appear beyond the arc tip
    Shape {
        z: 10
        anchors.fill: parent
        visible: root.animatedSweep > 1
        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillColor: {
                var s = root.animatedSweep
                if (s <= root.driveSweep) {
                    var t = s / root.driveSweep
                    return Qt.rgba(0, (80 + t*149)/255, (120 + t*135)/255, 1)
                } else if (s <= root.driveSweep + root.sportSweep) {
                    var t = (s - root.driveSweep) / root.sportSweep
                    return Qt.rgba(0, (229 + t*26)/255, (255 + t*(136-255))/255, 1)
                } else {
                    var t = (s - root.driveSweep - root.sportSweep) / root.redlineSweep
                    return Qt.rgba(t, (255 + t*(51-255))/255, (136 + t*(51-136))/255, 1)
                }
            }
            PathAngleArc {
                centerX: 160 + root.gaugeRadius * Math.cos((130 + root.animatedSweep + 3) * Math.PI / 180)
                centerY: 160 + root.gaugeRadius * Math.sin((130 + root.animatedSweep + 3) * Math.PI / 180)
                radiusX: 7; radiusY: 7
                startAngle: 0; sweepAngle: 360
            }
        }
    }

    // END cap background — static dark circle at max sweep position
    Shape {
        z: 9
        anchors.fill: parent
        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillColor: "#1a2233"
            PathAngleArc {
                centerX: 160 + root.gaugeRadius * Math.cos((130 + 280 + 3) * Math.PI / 180)
                centerY: 160 + root.gaugeRadius * Math.sin((130 + 280 + 3) * Math.PI / 180)
                radiusX: 7; radiusY: 7
                startAngle: 0; sweepAngle: 360
            }
        }
    }

    // ticks
    Repeater {
        model: 21

        Rectangle {
            readonly property bool majorTick: index % 2 === 0

            width: 2
            height: majorTick ? 14 : 8
            radius: 1

            color: majorTick ? "#3a4354" : "#242c38"

            x: parent.width / 2 - width / 2
            y: parent.height / 2 - root.tickRadius - height

            transform: Rotation {
                origin.x: width / 2
                origin.y: root.tickRadius + height

                // 280° sweep / 20 intervals = 14°
                angle: -140 + (index * 14)
            }
        }
    }

    // needle
    Item {
        id: needleRoot

        anchors.centerIn: parent
        width: 1
        height: 1

        rotation: root.angleForValue(root.smoothValue)

        Behavior on rotation {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            width: 2
            height: 50
            radius: 1
            color: "white"

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: 45
        }
    }

    Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 8
        text: scaleThousands
                  ? (root.smoothValue / 1000).toFixed(1)
                  : Math.round(root.smoothValue)
        color: "white"
        font.pixelSize: 42
        font.bold: true
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: 35
        text: root.unit
        color: "#6b7c93"
        font.pixelSize: 10
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: 55
        text: root.label
        color: "#6b7c93"
        font.pixelSize: 14
    }
}
