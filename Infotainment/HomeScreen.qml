// HomeScreen.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: root

    property color accent: "#2f80ff"
    property int batteryLevel: 91
    property bool charging: false
    property date currentTime: new Date()

    Component.onCompleted: {
        WeatherService.onUpdate(function() {
            // nothing needed — bindings already reactive
        })

        WeatherService.fetchWeather()
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            root.currentTime = new Date()
        }
    }

    function greeting() {
        const hour = currentTime.getHours()

        if (hour < 12)
            return "Good morning"

        if (hour < 18)
            return "Good afternoon"

        return "Good evening"
    }

    // ==========================================================
    // NAVIGATION
    // ==========================================================
    property int currentPage: 0

    property var navigationModel: [
        {
            icon_light: "qrc:/icons/light/home.png",
            icon_dark: "qrc:/icons/dark/home.png",
            page: "pages/DashboardPage.qml",
        },
        {
            icon_light: "qrc:/icons/light/tune.png",
            icon_dark: "qrc:/icons/dark/tune.png",
            page: "pages/MusicPage.qml",
        },
        {
            icon_light: "qrc:/icons/light/phone.png",
            icon_dark: "qrc:/icons/dark/phone.png",
            page: "pages/PhonePage.qml",
        },
        {
            icon_light: "qrc:/icons/thunder.png",
            icon_dark: "qrc:/icons/thunder.png",
            page: "pages/WeatherPage.qml",
        },
        {
            icon_light: "qrc:/icons/light/compass.png",
            icon_dark: "qrc:/icons/dark/compass.png",
            page: "pages/NavigationPage.qml",
        },        {
            icon_light: "qrc:/icons/light/settings.png",
            icon_dark: "qrc:/icons/dark/settings.png",
            page: "pages/SettingsPage.qml",
        }
    ]

    function navigateTo(index)
    {
        if(root.currentPage !== index)
        {
            root.currentPage = index
            stackView.replace(navigationModel[index].page)
        }
    }

    Connections {
        target: myNavigator
        function onNavigateToPage(index) {
            navigateTo(index)
        }
    }

    // ==========================================================
    // HAVC
    // ==========================================================
    property int hvacLevel: 0   // 0..4
    property var hvacModes: ["AUTO", "LOW", "MED", "HIGH", "MAX"]

    // ==========================================================
    // TOP BAR
    // ==========================================================

    Rectangle {
        id: topBar
        height: 64
        width: parent.width
        color: Theme.bg("#12161c", "#f3f6f9")
        anchors.top: parent.top

        border.color: Theme.bg("#1f2a35", "#d7dde5")
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            spacing: 20

            // LEFT
            Row {
                spacing: 14

                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: Theme.bg("#1f2a35", "#e8edf3")

                    Image {
                        id: mode_icon
                        anchors.centerIn: parent
                        width: 18
                        height: 18
                        source: darkMode ?
                                    "qrc:/icons/dark/moon.png" :
                                    "qrc:/icons/light/brightness.png"

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                toggleTheme()
                            }
                        }
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter

                    Label {
                        text: greeting()
                        color: Theme.bg("#9aa6b2", "#6b7683")
                        font.pixelSize: 13
                    }

                    Label {
                        text: "Driver 1"
                        color: Theme.bg("#ffffff", "#1a1f26")
                        font.pixelSize: 20
                        font.bold: true
                    }
                }
            }

            Item { Layout.fillWidth: true }

            // CENTER STATUS
            Rectangle {
                height: 38
                radius: 19
                color: Theme.bg("#1f2a35", "#e8edf3")

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: "#34c759"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label {
                        text: "Vehicle Connected"
                        color: Theme.bg("#cfd8e3", "#243040")
                        font.pixelSize: 14
                    }
                }
            }

            Item { Layout.fillWidth: true }

            // RIGHT ICONS
            Row {
                spacing: 12

                Repeater {
                    model: [
                        {
                            icon_dark: "qrc:/icons/dark/bell.png",
                            icon_light: "qrc:/icons/light/bell.png"
                        },
                        {
                            icon_dark: "qrc:/icons/dark/wifi.png",
                            icon_light: "qrc:/icons/light/wifi.png"
                        }
                    ]

                    delegate: Rectangle {
                        width: 36
                        height: 36
                        radius: 18
                        color: Theme.bg("#1f2a35", "#e8edf3")

                        Image {
                            anchors.centerIn: parent
                            width: 18
                            height: 18
                            source: darkMode? modelData.icon_dark: modelData.icon_light
                            opacity: 0.85
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {

                            }
                        }
                    }
                }

                // BATTERY
                Rectangle {
                    width: 88
                    height: 36
                    radius: 18
                    color: Theme.bg("#1f2a35", "#e8edf3")

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Item {
                            width: 26
                            height: 14

                            Rectangle {
                                width: 22
                                height: 14
                                radius: 3
                                border.width: 1
                                border.color: Theme.bg("#cfd8e3", "#243040")
                                color: "transparent"
                            }

                            Rectangle {
                                x: 23
                                y: 4
                                width: 3
                                height: 6
                                radius: 1
                                color: Theme.bg("#cfd8e3", "#243040")
                            }

                            Rectangle {
                                x: 2
                                y: 2
                                width: (batteryLevel / 100) * 18
                                height: 10
                                radius: 2
                                color: batteryLevel > 60 ? "#34c759"
                                                         : batteryLevel > 20 ? "#ffcc00"
                                                                             : "#ff3b30"
                            }
                        }

                        Label {
                            text: batteryLevel + "%"
                            color: Theme.bg("#cfd8e3", "#243040")
                            font.pixelSize: 14
                            font.bold: true
                        }
                    }
                }

                // CLOCK
                Rectangle {
                    width: 86
                    height: 36
                    radius: 18
                    color: Theme.bg("#e8edf3", "#1f2a35")

                    Label {
                        anchors.centerIn: parent
                        text: Qt.formatTime(root.currentTime, "hh:mm")
                        color: Theme.bg("#243040", "#cfd8e3")
                        font.pixelSize: 14
                        font.bold: true
                    }
                }
            }
        }
    }

    // ==========================================================
    // SIDEBAR
    // ==========================================================

    Rectangle {
        id: sidebar
        width: 70
        color: Theme.bg("#1f2a35", "#dde5ee")
        border.color: Theme.bg("#1f2a35", "#d7dde5")
        border.width: 1

        anchors {
            top: topBar.bottom
            bottom: bottomBar.top
            left: parent.left
        }

        Column {
            anchors.centerIn: parent
            spacing: 22

            Repeater {
                model: navigationModel

                delegate: Rectangle {
                    width: 46
                    height: 46
                    radius: 10

                    property bool hovered: false

                    color: index === root.currentPage
                           ? Theme.bg("#43536d", "#c9d8ea")
                           : (hovered ? Theme.hovering() : "transparent")

                    Image {
                        anchors.centerIn: parent
                        width: 22
                        height: 22
                        source: darkMode ? modelData.icon_dark : modelData.icon_light
                        opacity: hovered || index === root.currentPage ? 1.0 : 0.75
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false

                        onClicked: {
                            navigateTo(index)
                        }
                    }
                }
            }
        }
    }

    // ==========================================================
    // MAIN AREA
    // ==========================================================

    Rectangle {
        anchors {
            top: topBar.bottom
            left: sidebar.right
            right: parent.right
            bottom: bottomBar.top
        }

        color: Theme.background()

        StackView {
            id: stackView
            anchors.fill: parent
            initialItem: "pages/DashboardPage.qml"
        }
    }

    // ==========================================================
    // BOTTOM BAR
    // ==========================================================

    Rectangle {
        id: bottomBar
        height: 82
        color: Theme.bg("#0f1318", "#eef3f8")

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        border.width: 1
        border.color: Theme.bg("#1f2a35", "#d7dde5")

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 22
            anchors.rightMargin: 22

            // // LEFT STATUS
            // Label {
            //     text: "Lo"
            //     color: Theme.bg("#cfd8e3", "#243040")
            // }

            Item { Layout.fillWidth: true }

            // CENTER HVAC CONTROLS
            Row {
                spacing: 14
                Layout.alignment: Qt.AlignVCenter

                // DECREASE
                Rectangle {
                    width: 34
                    height: 34
                    radius: 17
                    color: Theme.bg("#1f2a35", "#e8edf3")

                    Image {
                        anchors.centerIn: parent
                        width: 16
                        height: 16
                        source: darkMode
                                ? "qrc:/icons/dark/fan.png"
                                : "qrc:/icons/light/fan.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            hvacLevel = Math.max(0, hvacLevel - 1)
                        }
                    }
                }

                // LEVEL BARS
                Row {
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Repeater {
                        model: 5

                        Rectangle {
                            width: 10
                            height: index <= hvacLevel ? 18 : 10
                            radius: 3

                            color: index <= hvacLevel
                                   ? Theme.accent()
                                   : Theme.bg("#2a3442", "#d7dde5")
                        }
                    }
                }

                // CENTER LABEL
                Rectangle {
                    width: 80
                    height: 34
                    radius: 17
                    color: Theme.bg("#1f2a35", "#e8edf3")

                    Label {
                        anchors.centerIn: parent
                        text: hvacModes[hvacLevel]
                        font.pixelSize: 12
                        font.bold: true
                        color: Theme.bg("#cfd8e3", "#243040")
                    }
                }

                // INCREASE
                Rectangle {
                    width: 34
                    height: 34
                    radius: 17
                    color: Theme.bg("#1f2a35", "#e8edf3")

                    Image {
                        anchors.centerIn: parent
                        width: 24
                        height: 24
                        source: darkMode
                                ? "qrc:/icons/dark/fan.png"
                                : "qrc:/icons/light/fan.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            hvacLevel = Math.min(4, hvacLevel + 1)
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true }

            // // RIGHT STATUS
            // Label {
            //     text: "Lo"
            //     color: Theme.bg("#cfd8e3", "#243040")
            // }
        }
    }
}
