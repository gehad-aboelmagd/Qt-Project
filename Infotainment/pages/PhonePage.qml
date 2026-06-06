// PhonePage.qml

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Theme.js" as Theme

Item {
    id: root

    Popup {
        id: dialPadPopup

        modal: true
        focus: true

        width: 420
        height: 420

        anchors.centerIn: Overlay.overlay

        closePolicy: Popup.CloseOnEscape |
                     Popup.CloseOnPressOutside

        background: Rectangle {
            radius: 24
            color: Theme.card()
            border.color: Theme.border()
        }

        property string dialNumber: ""

        Rectangle {
            width: 40
            height: 40
            radius: 20
            color: Theme.surface2()
            anchors {
                top: parent.top
                right: parent.right
                topMargin: 12
                rightMargin: 12
            }

            Label {
                anchors.centerIn: parent
                text: "✕"
                font.pixelSize: 12
                color: Theme.textPrimary()
            }

            MouseArea {
                anchors.fill: parent

                onClicked: dialPadPopup.close()
            }
        }


        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24

            spacing: 16

            Label {
                Layout.fillWidth: true

                horizontalAlignment: Text.AlignHCenter

                text: dialPadPopup.dialNumber.length
                      ? dialPadPopup.dialNumber
                      : "Enter Number"

                color: Theme.textPrimary()
                font.pixelSize: 20
                font.bold: true
            }

            // keypad
            GridLayout {
                Layout.alignment: Qt.AlignHCenter

                columns: 3
                rowSpacing: 12
                columnSpacing: 12

                Repeater {
                    model: [
                        "1","2","3",
                        "4","5","6",
                        "7","8","9",
                        "*","0","#"
                    ]

                    delegate: Rectangle {
                        width: 50
                        height: 50
                        radius: 25

                        color: Theme.surface2()

                        Label {
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: 16
                            font.bold: true
                            color: Theme.textPrimary()
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                dialPadPopup.dialNumber += modelData
                            }
                        }
                    }
                }
            }

            // action buttons
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Rectangle {
                    width: 40
                    height: 40
                    radius: 20

                    color: "#ff3b30"

                    Label {
                        anchors.centerIn: parent
                        text: "⌫"
                        color: "white"
                        font.pixelSize: 12
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            if (dialPadPopup.dialNumber.length > 0)
                                dialPadPopup.dialNumber =
                                        dialPadPopup.dialNumber.slice(0, -1)
                        }
                    }
                }

                Rectangle {
                    width: 40
                    height: 40
                    radius: 20

                    color: "#34c759"

                    Label {
                        anchors.centerIn: parent
                        text: "📞"
                        font.pixelSize: 12
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            console.log(
                                "Calling:",
                                dialPadPopup.dialNumber
                            )
                        }
                    }
                }
            }

            // // close Button
            // ToolButton {
            //     // Layout.right: parent.right
            //     // Layout.top: parent.top
            //     text: ""
            //     onClicked: dialPadPopup.close()
            // }

        }
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // =====================================================
        // HEADER
        // =====================================================

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            Label {
                anchors.centerIn: parent
                text: "Phone"
                color: Theme.textPrimary()
                font.pixelSize: 28
                font.bold: true
            }
        }

        // =====================================================
        // TOP ROW
        // =====================================================

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            // Recent Calls
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 2

                radius: 20
                color: Theme.card()

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 18

                    Label {
                        text: "Recent Calls"
                        color: Theme.textPrimary()
                        font.pixelSize: 18
                        font.bold: true
                    }

                    Repeater {
                        model: [
                            { name: "John Smith", time: "2 min ago" },
                            { name: "Diana Bob", time: "Yesterday" },
                            { name: "Sarah", time: "Monday" }
                        ]

                        delegate: Rectangle {
                            width: parent.width
                            height: 56
                            radius: 12
                            color: Theme.surface2()

                            Column {
                                anchors.centerIn: parent

                                Label {
                                    text: modelData.name
                                    color: Theme.textPrimary()
                                    font.bold: true
                                }

                                Label {
                                    text: modelData.time
                                    color: Theme.textSecondary()
                                    font.pixelSize: 12
                                }
                            }
                        }
                    }
                }
            }

            // Right Column
            ColumnLayout {
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                spacing: 16

                // Device Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    radius: 20
                    color: Theme.card()

                    Column {
                        anchors.centerIn: parent
                        spacing: 18

                        Label {
                            text: "📱"
                            font.pixelSize: 36
                            anchors.horizontalCenter:
                                parent.horizontalCenter
                        }

                        Label {
                            text: "Galaxy S24"
                            color: Theme.textPrimary()
                            font.bold: true
                            anchors.horizontalCenter:
                                parent.horizontalCenter
                        }

                        RowLayout
                        {
                            spacing: 6
                            anchors.horizontalCenter:
                                parent.horizontalCenter

                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: "#34c759"
                            }

                            Label {
                                text: "Connected"
                                color: "#34c759"
                            }
                        }

                        // dial pad
                        Rectangle {
                            width: 56
                            height: 56
                            radius: 28
                            color: Theme.surface2()
                            anchors.horizontalCenter:
                                parent.horizontalCenter

                            Image {
                                anchors.centerIn: parent
                                width: 24
                                height: 24
                                source: darkMode ?
                                            "qrc:/icons/dark/dialpad.png"
                                          : "qrc:/icons/light/dialpad.png"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: dialPadPopup.open()
                            }
                        }

                        // Rectangle {
                        //     width: 100
                        //     height: 40
                        //     radius: 20
                        //     anchors.horizontalCenter:
                        //         parent.horizontalCenter

                        //     color: Theme.accent()

                        //     Label {
                        //         anchors.centerIn: parent
                        //         text: "📞 Dial Pad"
                        //         color: "white"
                        //         // font.bold: true
                        //     }

                        //     MouseArea {
                        //         anchors.fill: parent
                        //         onClicked: dialPadPopup.open()
                        //     }
                        // }
                    }
                }

                // Favorites Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    radius: 20
                    color: Theme.card()

                    Column {
                        anchors.centerIn: parent
                        spacing: 8

                        Label {
                            text: "Favorites"
                            color: Theme.textPrimary()
                            font.bold: true
                        }

                        Label {
                            text: "🏠 Home"
                            color: Theme.textSecondary()
                        }

                        Label {
                            text: "💼 Office"
                            color: Theme.textSecondary()
                        }

                        Label {
                            text: "❤️ Sarah"
                            color: Theme.textSecondary()
                        }
                    }
                }
            }
        }
    }
}
