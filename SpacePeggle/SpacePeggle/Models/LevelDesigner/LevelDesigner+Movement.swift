import SwiftUI

/// This extension allows the LevelDesigner to handle the movement of level objects
/// around the level board.
extension LevelDesigner {
    func updateObjectPosition(_ object: any GameObject, with position: Vector) {
        if var object = levelObjects[object.id] {
            object.centerPosition = position
            handleBoundaryMovementCollision(object: &object)
        }
    }

    func handleObjectMovement(_ object: any GameObject, with drag: DragGesture.Value) {
        let stopLocation = drag.location
        var isMovingAway = false
        var isOverlap = false

        for gameObject in levelObjects.values where object.id != gameObject.id {
            if let distance = object.overlap(with: gameObject) {
                isOverlap = true
                let normalVector = (object.centerPosition - gameObject.centerPosition).normalized
                let correction = normalVector * (distance + 0.0000000001)
                let correctedPosition = object.centerPosition + correction
                updateObjectPosition(object, with: correctedPosition)

                let dragVector = Vector(with: stopLocation) - object.centerPosition
                let dotProduct = Vector.dot(normalVector, dragVector)
                isMovingAway = dotProduct > 0
                break
            }
        }

        if !isOverlap || isMovingAway {
            updateObjectPosition(object, with: Vector(with: stopLocation))
        }
    }

    /// Modifies a gameObject's centerposition in place
    private func handleBoundaryMovementCollision(object: inout any GameObject) {
        let objectX = object.centerPosition.x
        let objectY = object.centerPosition.y
        let widthX = object.width.half
        let heightY = object.height.half

        let screenBounds = domain.size
        let screenXStart = domain.origin.x
        let screenYStart = domain.origin.y
        let screenXEnd = screenBounds.width + screenXStart
        let screenYEnd = screenBounds.height + screenYStart

        // Check for left or right boundary collision
        if objectX < (screenXStart + widthX) || objectX > (screenXEnd - widthX) {
            if objectX < (screenXStart + widthX) {
                object.centerPosition.x = (screenXStart + widthX)
            }
            if objectX > (screenXEnd - widthX) {
                object.centerPosition.x = (screenXEnd - widthX)
            }
        }

        // Check for top or bottom collision
        if objectY < (screenYStart + heightY) || objectY > (screenYEnd - heightY) {
            if objectY < (screenYStart + heightY) {
                object.centerPosition.y = (screenYStart + heightY)
            }
            if objectY > (screenYEnd - heightY) {
                object.centerPosition.y = (screenYEnd - heightY)
            }
        }
    }
}
