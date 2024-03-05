import SwiftUI

/// This extension adds collision resolution to the PhysicsEngine.
extension PhysicsEngine {

    func detectAndHandleCollisions() {

        let physicsObjectsArray = Array(physicsObjects.values)
        for i in 0..<physicsObjectsArray.count {
            var object1 = physicsObjectsArray[i]

            for j in (i + 1)..<physicsObjectsArray.count {
                var object2 = physicsObjectsArray[j]

                if let collideDistance = isColliding(object1: object1, object2: object2) {
                    handleCollisionBetween(object1: &object1, object2: &object2, with: collideDistance)
                    physicsObjects[object1.id] = object1
                    physicsObjects[object2.id] = object2
                }

            }
        }
    }

    private func isColliding(object1: any PhysicsObject,
                             object2: any PhysicsObject) -> Double? {
        object1.collide(with: object2)
    }

    private func handleCollisionBetween(object1: inout any PhysicsObject,
                                        object2: inout any PhysicsObject,
                                        with distance: Double) {

        // Assuming object1 is always the moving object for simplicity.
        // This function now checks for collisions between any two physics objects
        // and handles them based on their properties rather than their types.
        if object1.mass.isFinite {
            handleCollision(movingObject: &object1, stationaryObject: &object2, with: distance)
        } else if object2.mass.isFinite {
            handleCollision(movingObject: &object2, stationaryObject: &object1, with: distance)
        }

    }

    private func handleCollision(movingObject: inout any PhysicsObject,
                                 stationaryObject: inout any PhysicsObject,
                                 with distance: Double) {

        let normalVector = (movingObject.centerPosition - stationaryObject.centerPosition).normalized
        let correction = normalVector * distance
        let correctedPosition = movingObject.centerPosition + correction
        movingObject.centerPosition = correctedPosition
        Logger.log("Correction is \(correction.magnitude)", self)

        let dotProduct = Vector.dot(movingObject.velocity, normalVector)
        let reflection = (normalVector * 2.0) * dotProduct
        let finalVelocity = movingObject.velocity - reflection
        movingObject.velocity = finalVelocity

        delegate?.handleCollision(withID: stationaryObject.id)

    }

    /// Rectangle collision
    func closestPointOnRect(to circleCenter: Vector, rect: CGRect) -> Vector {
        let clampedX = max(rect.minX, min(circleCenter.x, rect.maxX))
        let clampedY = max(rect.minY, min(circleCenter.y, rect.maxY))
        return Vector(x: clampedX, y: clampedY)
    }
}
