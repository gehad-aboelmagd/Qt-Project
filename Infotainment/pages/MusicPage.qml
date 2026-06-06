import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material

import "../Theme.js" as Theme

Item {
    id: root

    Component.onCompleted: {
        MediaService.setRadioSource(0)
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 18

        // =====================
        // ALBUM ART
        // =====================
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 320
            height: 320
            radius: 24
            color: Theme.card()

            Image {
                id: musicImg
                anchors.fill: parent
                source: MediaService.stationImage
                fillMode: Image.PreserveAspectCrop
                visible: false
            }

            MultiEffect {
                source: musicImg
                anchors.fill: musicImg
                maskEnabled: true
                maskSource: mask
            }

            Item {
                id: mask
                width: musicImg.width
                height: musicImg.height
                layer.enabled: true
                visible: false


                Rectangle {
                    width: musicImg.width
                    height: musicImg.height
                    radius: 20
                    color: Theme.card()
                }
            }
        }

        // =====================
        // TITLE
        // =====================
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter

            Label {
                text: MediaService.stationName
                font.pixelSize: 26
                font.bold: true
                color: Theme.textPrimary()
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                text: MediaService.stationArtist
                font.pixelSize: 16
                color: Theme.textSecondary()
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // =====================
        // PROGRESS BAR
        // =====================
        Rectangle {
            id: progressBar
            Layout.fillWidth: true
            height: 6
            radius: 3
            color: Theme.surface()

            Rectangle {
                id: pulse

                width: 80
                height: parent.height
                radius: 3
                color: Theme.accent()

                visible: MediaService.playing

                NumberAnimation on x {
                    running: MediaService.playing
                    loops: Animation.Infinite

                    from: 0
                    to: progressBar.width - pulse.width

                    duration: 2500
                }
            }
        }

        // =====================
        // CONTROLS
        // =====================
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 24

            Item {
                id: spacer1
                Layout.preferredWidth: 240
            }

            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: Theme.bg("#1f2a35", "#e8edf3")

                Image {
                    id: prevIcon
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    source: darkMode ?
                                "qrc:/icons/dark/play-prev.png" :
                                "qrc:/icons/light/play-prev.png"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: MediaService.playPrevStation()
                    }
                }
            }

            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: Theme.bg("#1f2a35", "#e8edf3")

                Image {
                    id: pausePlayIcon
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    source: MediaService.playing ?
                                (darkMode ?
                                     "qrc:/icons/dark/pause.png" :
                                     "qrc:/icons/light/pause.png")
                              :(darkMode ?
                                    "qrc:/icons/dark/play.png" :
                                    "qrc:/icons/light/play.png")
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: MediaService.togglePlayPause()
                    }
                }
            }

            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: Theme.bg("#1f2a35", "#e8edf3")

                Image {
                    id: nextIcon
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    source: darkMode ?
                                "qrc:/icons/dark/play-next.png" :
                                "qrc:/icons/light/play-next.png"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            onClicked: MediaService.playNextStation()
                        }
                    }
                }
            }

            Image {
                id: mute
                width: 18
                height: 18

                source: MediaService.muted
                        ? (darkMode
                            ? "qrc:/icons/dark/volume-mute.png"
                            : "qrc:/icons/light/volume-mute.png")
                        : (darkMode
                            ? "qrc:/icons/dark/volume.png"
                            : "qrc:/icons/light/volume.png")

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        MediaService.muted = !MediaService.muted
                    }
                }
            }

            Slider {
                id: volumeControl
                from: 0
                to: 1
                value: MediaService.volume
                Material.accent: Theme.accent()

                onMoved: {
                    MediaService.volume = value
                }
            }
        }
    }
}
