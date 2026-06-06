// DashboardPage.qml

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import "../Theme.js" as Theme
import "../WeatherService.js" as WeatherService

Item {
    id: root
    property int heroImageHeight: 260

    Component.onCompleted: {
        WeatherService.onUpdate(function() {
            // nothing needed — bindings already reactive
        })

        WeatherService.fetchWeather()
    }

    Flickable {
        id: flick
        anchors.fill: parent

        contentWidth: row.implicitWidth
        contentHeight: height
        clip: true
        interactive: true
        boundsBehavior: Flickable.StopAtBounds

        Row {
            id: row
            spacing: 18

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 18

            // ======================================================
            // Spotify Card
            // ======================================================

            Rectangle {
                width: 520
                height: 520
                radius: 8
                color: Theme.card()
                border.color: Theme.border()
                border.width: 1
                clip: true   // important

                Column {
                    anchors.fill: parent
                    spacing: 0

                    // =========================
                    // FULL-WIDTH IMAGE HEADER
                    // =========================
                    Rectangle
                    {
                        width: parent.width
                        height: root.heroImageHeight
                        color: Theme.background()

                        Image {
                            id: spotify_img
                            anchors.top: parent.top
                            width: parent.width
                            height: parent.height
                            source: "qrc:/images/spotify.jpeg"
                            fillMode: Image.PreserveAspectCrop
                            visible: false
                        }

                        MultiEffect {
                            source: spotify_img
                            anchors.fill: spotify_img
                            maskEnabled: true
                            maskSource: mask1
                        }

                        Item {
                            id: mask1
                            width: spotify_img.width
                            height: spotify_img.height
                            layer.enabled: true
                            visible: false


                            Rectangle {
                                width: spotify_img.width
                                height: spotify_img.height
                                radius: 8
                                color: Theme.card()
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: "#00000040"
                        }

                        Column {
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 18
                            spacing: 4

                            Label {
                                text: "Spotify"
                                color: "white"
                                font.pixelSize: 28
                                font.bold: true
                            }

                            Label {
                                text: "Song Name"
                                color: "#dce7ff"
                                font.pixelSize: 18
                            }
                        }
                    }

                    // =========================
                    // CONTENT AREA
                    // =========================

                    Column {

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 20
                        spacing: 18

                        Item { height: 6 }

                        Label {
                            text: "null"
                            color: Theme.textPrimary()
                            font.pixelSize: 50
                            font.bold: true
                            opacity: 0
                        }

                        Row {
                            spacing: 40

                            Column {
                                spacing: 4

                                Label {
                                    text: "03:12"
                                    color: Theme.textPrimary()
                                    font.pixelSize: 22
                                    font.bold: true
                                }

                                Label {
                                    text: "Elapsed"
                                    color: Theme.textSecondary()
                                    font.pixelSize: 14
                                }
                            }

                            Column {
                                spacing: 4

                                Label {
                                    text: "256"
                                    color: Theme.textPrimary()
                                    font.pixelSize: 22
                                    font.bold: true
                                }

                                Label {
                                    text: "Tracks"
                                    color: Theme.textSecondary()
                                    font.pixelSize: 14
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 54
                            radius: 12
                            color: Theme.surface2()

                            Label {
                                anchors.centerIn: parent
                                text: "Open Spotify"
                                color: Theme.textPrimary()
                                font.pixelSize: 18
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        myNavigator.navigateToPage(1)
                    }
                }
            }

            // ======================================================
            // DRIVE CARD
            // ======================================================
            Rectangle {
                width: 360
                height: 520
                radius: 8
                color: Theme.card()
                border.color: Theme.border()
                border.width: 1
                clip: true

                Column {
                    anchors.fill: parent
                    spacing: 0

                    // HERO IMAGE
                    Rectangle {
                        width: parent.width
                        height: root.heroImageHeight
                        color: Theme.background()

                        Image {
                            id: driver_img
                            anchors.top: parent.top
                            width: parent.width
                            height: parent.height
                            fillMode: Image.PreserveAspectCrop
                            source: "qrc:/images/driver-mode.jpg"
                            visible: false
                        }

                        MultiEffect {
                            source: driver_img
                            anchors.fill: driver_img
                            maskEnabled: true
                            maskSource: mask2
                        }

                        Item {
                            id: mask2
                            width: driver_img.width
                            height: driver_img.height
                            layer.enabled: true
                            visible: false

                            Rectangle {
                                width: driver_img.width
                                height: driver_img.height
                                radius: 8
                                color: Theme.card()
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: "#00000040"
                        }

                        Column {
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 18
                            spacing: 4

                            Label {
                                text: "Drive Mode"
                                color: "white"
                                font.pixelSize: 28
                                font.bold: true
                            }

                            Label {
                                text: "Normal"
                                color: "#dce7ff"
                                font.pixelSize: 18
                            }
                        }
                    }

                    // =========================
                    // CONTENT AREA
                    // =========================
                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 20
                        spacing: 18

                        Item { height: 6 }

                        Label {
                            text: "null"
                            color: Theme.textPrimary()
                            font.pixelSize: 50
                            font.bold: true
                            opacity: 0
                        }

                        Row {
                            spacing: 40

                            Column {
                                spacing: 4

                                Label {
                                    text: "227 mi"
                                    color: Theme.textPrimary()
                                    font.pixelSize: 22
                                    font.bold: true
                                }

                                Label {
                                    text: "Estimated range"
                                    color: Theme.textSecondary()
                                    font.pixelSize: 14
                                }
                            }

                            Column {
                                spacing: 4

                                Label {
                                    text: "91%"
                                    color: Theme.textPrimary()
                                    font.pixelSize: 22
                                    font.bold: true
                                }

                                Label {
                                    text: "Battery"
                                    color: Theme.textSecondary()
                                    font.pixelSize: 14
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 54
                            radius: 12
                            color: Theme.surface2()

                            Label {
                                anchors.centerIn: parent
                                text: "Vehicle Status"
                                color: Theme.textPrimary()
                                font.pixelSize: 18
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        myNavigator.navigateToPage(2)
                    }
                }
            }

            // ======================================================
            // WEATHER CARD
            // ======================================================
            Rectangle {
                width: 340
                height: 520
                radius: 8
                color: Theme.card()
                border.color: Theme.border()
                border.width: 1
                clip: true

                Column {
                    anchors.fill: parent
                    spacing: 0

                    // HERO IMAGE
                    Rectangle {
                        width: parent.width
                        height: root.heroImageHeight
                        radius: 8
                        color: Theme.background()

                        Image {
                            id: weather_img
                            anchors.fill: parent
                            height: parent.height
                            fillMode: Image.PreserveAspectCrop
                            source: "qrc:/images/weather.jpg"
                            visible: false
                        }

                        MultiEffect {
                            source: weather_img
                            anchors.fill: weather_img
                            maskEnabled: true
                            maskSource: mask3
                        }

                        Item {
                            id: mask3
                            width: weather_img.width
                            height: weather_img.height
                            layer.enabled: true
                            visible: false

                            Rectangle {
                                width: weather_img.width
                                height: weather_img.height
                                radius: 8
                                color: Theme.card()
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: "#00000040"
                        }

                        Column {
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 18
                            spacing: 4

                            Label {
                                text: WeatherService.cityName || "Cairo"
                                color: "white"
                                font.pixelSize: 28
                                font.bold: true
                            }

                            Label {
                                text: WeatherService.condition || "Partly Cloudy"
                                color: "#dce7ff"
                                font.pixelSize: 18
                            }
                        }
                    }

                    // =========================
                    // CONTENT AREA
                    // =========================
                    Column {

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 20
                        spacing: 18

                        Item { height: 6 }

                        Label {
                            text: "null"
                            color: Theme.textPrimary()
                            font.pixelSize: 50
                            font.bold: true
                            opacity: 0
                        }

                        Row {
                            spacing: 40

                            Column {
                                spacing: 4

                                Label {
                                    text: (WeatherService.highTemp !== "--"
                                          ? parseInt(WeatherService.highTemp)
                                          : 31) + "°"
                                    color: Theme.textPrimary()
                                    font.pixelSize: 22
                                    font.bold: true
                                }

                                Label {
                                    text: "High"
                                    color: Theme.textSecondary()
                                    font.pixelSize: 14
                                }
                            }

                            Column {
                                spacing: 4

                                Label {
                                    text: (WeatherService.lowTemp !== "--"
                                          ? parseInt(WeatherService.lowTemp)
                                          : 28) + "°"
                                    color: Theme.textPrimary()
                                    font.pixelSize: 22
                                    font.bold: true
                                }

                                Label {
                                    text: "Low"
                                    color: Theme.textSecondary()
                                    font.pixelSize: 14
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 54
                            radius: 12
                            color: Theme.surface2()

                            Label {
                                anchors.centerIn: parent
                                text: "AccuWeather"
                                color: Theme.textPrimary()
                                font.pixelSize: 18
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        myNavigator.navigateToPage(3)
                    }
                }
            }
        }
    }
}
