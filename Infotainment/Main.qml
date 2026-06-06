import QtQuick
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 1280
    height: 720

    property bool darkMode: true

    function toggleTheme() {
        darkMode =! darkMode
        Theme.darkMode = darkMode
    }

    HomeScreen {
        anchors.fill: parent
    }
}
