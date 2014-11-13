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

    function containsSquare(list, square) {
        for(var i in list) {
            var otherSquare = list[i]
            if(square.i === otherSquare.i && square.j === otherSquare.j) {
                return otherSquare
            }
        }
        return false
    }

    function square(i,j) {
        return {i: i, j: j, G: 0, H: 0, F: 0, cameFrom: null}
    }

    function findPath() {
        mapImage.clearPath()
        var target = square(10,10)
        var start = square(0,0)
        var current = square(start.i, start.j)
        var openList = []
        var closedList = []
        openList.push(current)
        while(openList.length > 0) {
            if(current.i === target.i && current.j === target.j) {
                break
            }
            for(var di = -1; di < 2; di++) {
                for(var dj = -1; dj < 2; dj++) {
                    var i = current.i + di
                    var j = current.j + dj
                    var adjacent = square(i,j)
                    adjacent.cameFrom = current
                    if(!mapImage.inBounds(i,j)) {
                        continue
                    }
                    if(containsSquare(closedList, adjacent)) {
                        continue
                    }
                    if(mapImage.cost(i,j) > 1) {
                        continue
                    }

                    adjacent.G = current.G + Math.sqrt(di*di + dj*dj)
                    var deltaRow = target.i - adjacent.i
                    var deltaColumn = target.j - adjacent.j
                    adjacent.H = Math.sqrt(deltaRow*deltaRow + deltaColumn*deltaColumn)
                    adjacent.F = adjacent.G + adjacent.H
                    var existingSquare = containsSquare(openList, adjacent)
                    if(existingSquare) {
                        if(adjacent.F < existingSquare.F) {
                            openList.splice(openList.indexOf(existingSquare), 1)
                            openList.push(adjacent)
                        }
                    } else {
                        openList.push(adjacent)
                    }
                }
            }
            openList.splice(openList.indexOf(current), 1)
            closedList.push(current)
            if(openList.length > 0) {
                current = openList[0]
            }
        }

        var path = []
        mapImage.setTraveled(current.i, current.j)
        while(current.cameFrom !== null) {
            current = current.cameFrom
            path.push(current)
            mapImage.setTraveled(current.i, current.j)
        }
        return path
    }

    Timer {
        interval: 200
        repeat: true
        running: true
        onTriggered: findPath()
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
        rows: 20
        columns: 20
        anchors.centerIn: parent
        traversable: radioButton1.checked
    }
}


