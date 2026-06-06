// pages/WeatherPage.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Theme.js" as Theme
import "../WeatherService.js" as WeatherService

Item {
    id: root
    property int weatherRevision: 0

    Component.onCompleted: {
        WeatherService.onUpdate(function() {
            weatherRevision++
        })

        WeatherService.fetchWeather()
    }

    // =========================
    // BACKGROUND
    // =========================
    Rectangle {
        anchors.fill: parent
        color: Theme.background()
    }

    // =========================
    // MAIN LAYOUT — mirrors home screen 3-col grid
    // =========================
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // ── HEADER ─────────────────────────────────────────
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 52

            Column {
                anchors.centerIn: parent
                spacing: 2

                Label {
                    text:
                    {
                        weatherRevision
                        return WeatherService.cityName
                    }
                    color: Theme.textPrimary()
                    font.pixelSize: 28
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Label {
                    text:
                    {
                        weatherRevision
                        return WeatherService.condition
                    }
                    color: Theme.textSecondary()
                    font.pixelSize: 13
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // ── ROW 1: Hero temp card + 2 detail cards ─────────
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 120
            spacing: 16

            // Hero temperature — wide card (like Spotify card on home)
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 2  // 2x weight
                radius: 20
                color: Theme.card()

                // Subtle top gradient accent — matches home card image-top style
                Rectangle {
                    width: parent.width
                    height: parent.height * 0.45
                    radius: 20
                    opacity: 0.18
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#4a90d9" }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 6

                    Label {
                        text: {
                            weatherRevision
                            return Math.round(WeatherService.temperature) + "°"
                        }
                        color: Theme.textPrimary()
                        font.pixelSize: 68
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text:
                        {
                            weatherRevision
                            return "H " + Math.round(parseFloat(WeatherService.highTemp)) +
                                    "°   L " + Math.round(parseFloat(WeatherService.lowTemp)) + "°"
                        }
                        color: Theme.textSecondary()
                        font.pixelSize: 13
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            // Right column — stacked detail cards
            ColumnLayout {
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                spacing: 16

                // Feels Like card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 20
                    color: Theme.card()

                    Column {
                        anchors.centerIn: parent
                        spacing: 4

                        Label {
                            text: "🌡️"
                            font.pixelSize: 22
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Label {
                            text:
                            {
                                weatherRevision
                                return Math.round(parseFloat(WeatherService.feelsLike)) + "°"
                            }
                            color: Theme.textPrimary()
                            font.pixelSize: 18
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Label {
                            text: "Feels Like"
                            color: Theme.textSecondary()
                            font.pixelSize: 11
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // UV Index card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 20
                    color: Theme.card()

                    Column {
                        anchors.centerIn: parent
                        spacing: 4

                        Label {
                            text: "☀️"
                            font.pixelSize: 22
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Label {
                            text:
                            {
                                weatherRevision
                                return WeatherService.uvIndex
                            }
                            color: Theme.textPrimary()
                            font.pixelSize: 18
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Label {
                            text: "UV Index"
                            color: Theme.textSecondary()
                            font.pixelSize: 11
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }

        // ── ROW 2: 3 stat cards — same grid as home ────────
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 75
            spacing: 16

            Repeater {
                model: [
                    {
                        icon: "💧",
                        value: WeatherService.humidity + "%",
                        label: "Humidity"
                    },
                    {
                        icon: "💨",
                        value: WeatherService.windSpeed + " km/h",
                        label: "Wind"
                    },
                    {
                        icon: "👁️",
                        value: WeatherService.vis + " km",
                        label: "Visibility"
                    }
                ]

                delegate: Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 20
                    color: Theme.card()

                    Column {
                        anchors.centerIn: parent
                        spacing: 4

                        Label {
                            text: modelData.icon
                            font.pixelSize: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Label {
                            text: modelData.value
                            color: Theme.textPrimary()
                            font.bold: true
                            font.pixelSize: 14
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Label {
                            text: modelData.label
                            color: Theme.textSecondary()
                            font.pixelSize: 11
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }

        // ── ROW 3: Forecast — 3 equal cards, same as home grid ──
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 75
            spacing: 16

            Repeater {
                model:
                {
                    weatherRevision
                    return WeatherService.forecastData
                }

                delegate: Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 20
                    color: Theme.card()

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Label {
                            text: modelData.day
                            color: Theme.textSecondary()
                            font.pixelSize: 12
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Label {
                            text: modelData.icon
                            font.pixelSize: 26
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Label {
                            text: modelData.avgTemp + "°"
                            color: Theme.textPrimary()
                            font.bold: true
                            font.pixelSize: 15
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Label {
                            text: "H " + modelData.high + "  L " + modelData.low
                            color: Theme.textSecondary()
                            font.pixelSize: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }

    } // end ColumnLayout
}
