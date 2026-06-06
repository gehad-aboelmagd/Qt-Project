import QtQuick

Rectangle {
    width: 110
    height: 35
    radius: 8
    color: "#0f1722"
    border.color: "#1f2a3a"

    property string title: ""
    property string value: ""

    Row {
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: title
            color: "#6b7c93"
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: value
            color: "#00e5ff"
            font.pixelSize: 12
            font.bold: true
        }
    }
}
