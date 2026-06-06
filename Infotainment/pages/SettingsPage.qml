// SettingsPage.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Theme.js" as Theme

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: Theme.background()
    }

    Flickable {
        anchors.fill: parent
        contentHeight: column.implicitHeight
        clip: true

        Item {
            width: parent.width
            implicitHeight: column.implicitHeight

            ColumnLayout {
                id: column
                width: parent.width - 48
                x: 24
                spacing: 16

                // ======================================================
                // HEADER (same style as WeatherPage)
                // ======================================================
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50

                    Label {
                        text: "Settings"
                        color: Theme.textPrimary()
                        font.pixelSize: 22
                        font.bold: true
                        anchors.centerIn: parent
                    }
                }

                // ======================================================
                // CONNECTIVITY
                // ======================================================
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 160
                    radius: 20
                    color: Theme.card()
                    border.color: Theme.border()

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 10

                        Label {
                            text: "Connectivity"
                            color: Theme.textPrimary()
                            font.bold: true
                            font.pixelSize: 16
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                text: "Wi-Fi"
                                Layout.fillWidth: true
                                color: Theme.textPrimary()
                            }

                            Switch {
                                checked: true
                                Material.accent: Theme.accent()
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                text: "Bluetooth"
                                Layout.fillWidth: true
                                color: Theme.textPrimary()
                            }

                            Switch {
                                checked: false
                                Material.accent: Theme.accent()
                            }
                        }
                    }
                }

                // ======================================================
                // SOUND
                // ======================================================
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 160
                    radius: 20
                    color: Theme.card()
                    border.color: Theme.border()

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 12

                        Label {
                            text: "Sound"
                            color: Theme.textPrimary()
                            font.bold: true
                            font.pixelSize: 16
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                text: "Mute"
                                Layout.fillWidth: true
                                color: Theme.textPrimary()
                            }

                            Slider {
                                // Layout.fillWidth: true   // 🔥 FIXED (was fixed width)
                                value: 0.6
                                Material.accent: Theme.accent()
                            }


                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                text: "Volume"
                                Layout.fillWidth: true
                                color: Theme.textPrimary()
                            }

                            Switch {
                                Material.accent: Theme.accent()
                            }
                        }
                    }
                }

                // ======================================================
                // APPEARANCE
                // ======================================================
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    radius: 20
                    color: Theme.card()
                    border.color: Theme.border()

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18

                        Label {
                            text: "Appearance"
                            color: Theme.textPrimary()
                            font.bold: true
                            font.pixelSize: 16
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                text: "Dark Mode"
                                Layout.fillWidth: true
                                color: Theme.textPrimary()
                            }

                            Switch {
                                checked: false
                                onToggled: toggleTheme()
                                Material.accent: Theme.accent()
                            }
                        }
                    }
                }

                // ======================================================
                // SECTION: SYSTEM
                // ======================================================
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    radius: 20
                    color: Theme.card()
                    border.color: Theme.border()

                    Column {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 10

                        Label {
                            text: "System"
                            font.pixelSize: 18
                            font.bold: true
                            color: Theme.textPrimary()
                        }

                        Label {
                            text: "Software version: 1.0.0"
                            color: Theme.textSecondary()
                        }

                        Label {
                            text: "Build: Infotainment Alpha"
                            color: Theme.textSecondary()
                        }
                    }
                }


                Item { Layout.fillHeight: true }
            }
        }
    }
}
