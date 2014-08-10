import QtQuick 2.2
import QtQuick.Controls 1.1
import Pathfinder 0.1

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    Column {
        id: column1
        x: 8
        y: 8
        width: 101
        height: 464

        Button {
            id: clearButton
            text: qsTr("Clear map")
            onClicked: mapImage.clearMap()
        }

        Button {
            id: randomizeButton
            text: qsTr("Randomize")
            onClicked: mapImage.randomizeMap()
        }
        ExclusiveGroup { id: group }
        RadioButton {
            id: radioButton1
            exclusiveGroup: group
            text: qsTr("Traversable")
        }

        RadioButton {
            id: radioutton2
            exclusiveGroup: group
            text: qsTr("Blocked")
            checked: true
        }

    }

    MapImage {
        id: mapImage
        width: 200
        height: 200
        anchors.centerIn: parent
        traversable: radioButton1.checked
    }
}


