import QtQuick 2.0
import Pathfinder 0.1

Rectangle {
    id: body

    property MapImage mapImage: null
    property point target: Qt.point(5,5)
    property point nextPosition: Qt.point(1,1)
    property point targetPosition: Qt.point(10,10)
    property var path: []

    color: "purple"
    width: mapImage.width / mapImage.columns - 2
    height: mapImage.height / mapImage.rows - 2
    smooth: true
    antialiasing: true

    function updatePath() {
        var currentCoordinate = mapImage.coordinateFromPosition(Qt.point(x,y))
        var target = Qt.point(10,10)
        console.log("Requesting path from " + currentCoordinate + " to " + target)
        path = findPath(currentCoordinate, target)
        nextPosition = path.pop()
    }

    function move() {
        targetPosition = mapImage.positionFromCoordinate(nextPosition)
        var diffX = targetPosition.x - x
        var diffY = targetPosition.y - y
        if(Math.sqrt(diffX*diffX + diffY*diffY) < 1) {
            if(path.length === 0) {
                x = Math.random() * mapImage.width
                y = Math.random() * mapImage.height
                updatePath()
                return
            } else {
                nextPosition = path.pop()
                return
            }
        }

        var vector = Qt.vector2d(diffX, diffY).normalized()
        x += vector.x
        y += vector.y
    }
}
