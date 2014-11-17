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

    function findPath(startPoint, targetPoint) {
        var start = square(startPoint.x, startPoint.y)
        var target = square(targetPoint.x, targetPoint.y)
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
                    // Disallow corner crossing
                    if(!(di === 0 || dj === 0)) {
                        var alti = current.i + di
                        var altj = current.j
                        if(mapImage.cost(alti, altj) > 1) {
                            continue
                        }
                        alti = current.i
                        altj = current.j + dj
                        if(mapImage.cost(alti, altj) > 1) {
                            continue
                        }
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
            path.push(Qt.point(current.i, current.j))
            mapImage.setTraveled(current.i, current.j)
        }
        return path
    }

    Timer {
        interval: 16
        repeat: true
        running: true
//        onTriggered: findPath()
        onTriggered: mapImage.step()
    }

    Timer {
        interval: 500
        repeat: true
        running: true
        onTriggered: {
            if(mapImage.pathsDirty) {
                mapImage.refreshPaths()
                mapImage.pathsDirty = false
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
        rows: 20
        columns: 20
        anchors.centerIn: parent
        traversable: radioButton1.checked

        property var entities: []
        property bool pathsDirty: true

        Component.onCompleted: {
            for(var i = 0; i < 1; i++) {
                var component = Qt.createComponent("Entity.qml")
                var properties = {
                    target: Qt.point(rows / 2, columns / 2),
                    mapImage: mapImage
                }

                var entity = component.createObject(mapImage, properties)
                entities.push(entity)
            }
        }

        function positionFromCoordinate(coordinate) {
            if(columns < 1 || rows < 1) {
                return Qt.point(0,0)
            }
            return Qt.point(coordinate.y * width / columns, coordinate.x * height / rows)
        }

        function coordinateFromPosition(position) {
            return Qt.point(parseInt(position.y / height * rows), parseInt(position.x / width * columns))
        }

        function step() {
            for(var i in entities) {
                var entity = entities[i]
                entity.move()
            }
        }

        function refreshPaths() {
            mapImage.clearPath()
            for(var i in entities) {
                var entity = entities[i]
                entity.updatePath()
            }
        }

        MouseArea {
            anchors.fill: parent
            function changeSquare(mouse) {
                var coordinate = mapImage.coordinateFromPosition(Qt.point(mouse.x, mouse.y))
                console.log(coordinate)
                mapImage.changeTraversable(coordinate.x, coordinate.y)
                mapImage.pathsDirty = true
            }

            onPressed: {
                changeSquare(mouse)
            }

            onPositionChanged: {
                changeSquare(mouse)
            }
        }
    }
}


