import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string driveMode: "DRIVE"

    property real rpm: 2500
    property real speed: 80

    property real targetRpm: 2500
    property real targetSpeed: 80

    property int gear: 3

    property real simFuel: 60
    property real simTemp: 65

    property real odometer: 125483

    property int simulationTick: 0

    property var modeMap: ({
                               "IDLE": {
                                   rpmTarget: 900,
                                   speedTarget: 0,
                                   color: "#00e5ff"
                               },

                               "DRIVE": {
                                   rpmTarget: 2500,
                                   speedTarget: 80,
                                   color: "#00e5ff"
                               },

                               "SPORT": {
                                   rpmTarget: 4500,
                                   speedTarget: 160,
                                   color: "#00ff88"
                               },

                               "REDLINE": {
                                   rpmTarget: 7200,
                                   speedTarget: 240,
                                   color: "#ff3333"
                               }
                           })

    function setMode(mode)
    {
        driveMode = mode

        targetRpm =
                modeMap[mode].rpmTarget

        targetSpeed =
                modeMap[mode].speedTarget
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockText.text =
                     Qt.formatTime(new Date(), "hh:mm")
    }

    Timer {
        interval: 16
        running: true
        repeat: true

        onTriggered: {

            simulationTick++

            //-----------------------------------
            // RPM
            //-----------------------------------

            var rpmNoise =
                    Math.sin(simulationTick * 0.08) * 80 +
                    Math.sin(simulationTick * 0.17) * 40

            var desiredRpm =
                    targetRpm + rpmNoise

            rpm += (desiredRpm - rpm) * 0.05

            //-----------------------------------
            // SPEED
            //-----------------------------------

            var speedNoise =
                    Math.sin(simulationTick * 0.03) * 3

            var desiredSpeed =
                    targetSpeed + speedNoise

            speed += (desiredSpeed - speed) * 0.03

            //-----------------------------------
            // GEAR
            //-----------------------------------

            if (speed < 5)
                gear = 1
            else if (speed < 40)
                gear = 2
            else if (speed < 80)
                gear = 3
            else if (speed < 120)
                gear = 4
            else if (speed < 180)
                gear = 5
            else
                gear = 6

            //-----------------------------------
            // FUEL
            //-----------------------------------

            simFuel = Math.max(
                        0,
                        simFuel - 0.0004 * (rpm / 1000)
                        )

            //-----------------------------------
            // TEMP
            //-----------------------------------

            var targetTemp =
                    60 + (rpm / 8000) * 40

            simTemp +=
                    (targetTemp - simTemp) * 0.02

            //-----------------------------------
            // ODO
            //-----------------------------------

            odometer += speed / 360000
        }
    }

    Timer
    {
        interval: 50
        running: true
        repeat: true
        onTriggered: {
            simFuel = Math.max(0, simFuel - 0.02)
            var load = root.rpm / 8000
            simTemp += (50 + load * 40 - simTemp) * 0.1
            simTemp += (Math.random() - 0.5) * 0.05
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#05070d"
    }

    // LEFT RPM GAUGE
    CircularGauge {
        id: rpmGauge

        anchors.left: parent.left
        anchors.leftMargin: 220
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -75

        value: Math.round(root.rpm)
        maxValue: 8000
        rpmMode: true
        scaleThousands: true

        accentColor:
            root.modeMap[root.driveMode].color

        label: "RPM"
        unit: "×1000"
    }

    // RIGHT SPEED GAUGE
    CircularGauge {
        id: speedGauge

        anchors.right: parent.right
        anchors.rightMargin: 220
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -75

        value: Math.round(root.speed)
        maxValue: 260
        rpmMode: false
        scaleThousands: false

        accentColor:
            root.modeMap[root.driveMode].color

        label: "SPEED"
        unit: "km/h"
    }

    Column {
        id: centerCluster

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -125

        spacing: 15

        // ─────────────────────────────
        // Mini gauges
        // ─────────────────────────────
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 40

            MiniGauge {
                value: root.simTemp
                maxValue: 120
                radius: 50
                label: "TEMP"
                unit: "°"
            }

            MiniGauge {
                value: root.simFuel
                maxValue: 100
                radius: 50
                fillColor: "#00ff88"
                label: "FUEL"
                unit: "%"
            }
        }

        Rectangle {
            width: 220
            height: 1
            color: "#00e5ff"
            opacity: 0.25
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // ─────────────────────────────
        // Clock
        // ─────────────────────────────
        Text {
            id: clockText
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatTime(new Date(), "hh:mm")
            color: "#6b7c93"
            font.pixelSize: 14
        }

        // ─────────────────────────────
        // Drive mode
        // ─────────────────────────────
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 120
            height: 40
            radius: 4
            color: "#101826"
            border.width: 1
            border.color: "#6b7c93"

            Text {
                anchors.centerIn: parent
                text: root.driveMode
                color: "#00e5ff"
                font.pixelSize: 16
                font.bold: true
            }
        }
    }

    Row {
        id: statusRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: centerCluster.bottom
        anchors.topMargin: 100
        spacing: 210

        Column {
            spacing: 2

            Text {
                text: root.gear
                color: "#00e5ff"
                font.pixelSize: 48
                font.bold: true

                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "GEAR"
                color: "#6b7c93"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Column {
            spacing: 2

            Text {
                text: Math.round(root.speed)
                color: "white"
                font.pixelSize: 48
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "KM/H"
                color: "#6b7c93"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Column {
            spacing: 2

            Text {
                text: "ODO"
                color: "#6b7c93"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: Math.round(root.odometer)
                color: "white"
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    // BOTTOM INFO TILES
    Row {
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 150

        InfoTile { title: "TEMP"; value: Math.round(root.simTemp) + "°C" }
        InfoTile { title: "FUEL"; value: Math.round(root.simFuel) + "%" }
        InfoTile { title: "BAT"; value: "12.1V" }
        InfoTile { title: "OIL"; value: "39 PSI" }
    }

    Row {
        spacing: 15
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80

        Repeater {
            model: ["IDLE", "DRIVE", "SPORT", "REDLINE"]

            delegate: Rectangle {
                width: 110
                height: 35
                radius: 6

                property bool active: root.driveMode === modelData

                color: active ? "#416d7a" : "#101826"
                border.color: active ? "#00e5ff" : "#6b7c93"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: modelData
                    color: parent.active ? "#00e5ff" : "#6b7c93"
                    font.pixelSize: 12
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.setMode(modelData)
                }
            }
        }
    }
}
