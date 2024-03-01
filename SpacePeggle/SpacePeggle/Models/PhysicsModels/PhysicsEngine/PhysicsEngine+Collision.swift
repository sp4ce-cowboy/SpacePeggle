import SwiftUI

/// This extension adds collision resolution to the PhysicsEngine.
extension PhysicsEngine {

    func detectAndHandleCollisions() {

        let physicsObjectsArray = Array(physicsObjects.values)
        for i in 0..<physicsObjectsArray.count {
            var object1 = physicsObjectsArray[i]

            for j in (i + 1)..<physicsObjectsArray.count {
                var object2 = physicsObjectsArray[j]

                if isColliding(object1: object1, object2: object2) {
                    handleCollisionBetween(object1: &object1, object2: &object2)
                    physicsObjects[object1.id] = object1
                    physicsObjects[object2.id] = object2
                }

            }
        }
    }

    private func isColliding(object1: any PhysicsObject,
                             object2: any PhysicsObject) -> Bool {
        object1.intersects(with: object2)
    }

    private func handleCollisionBetween(object1: inout any PhysicsObject,
                                        object2: inout any PhysicsObject) {

        // Assuming object1 is always the moving object for simplicity.
        // This function now checks for collisions between any two physics objects
        // and handles them based on their properties rather than their types.
        if object1.mass.isFinite {
            handleCollision(movingObject: &object1, stationaryObject: &object2)
        } else if object2.mass.isFinite {
            handleCollision(movingObject: &object2, stationaryObject: &object1)
        }
        // If both objects are immovable or have infinite mass, no need to process further.
    }

    private func handleCollision(movingObject: inout any PhysicsObject,
                                 stationaryObject: inout any PhysicsObject) {

        let normalVector = (movingObject.centerPosition - stationaryObject.centerPosition).normalized
        let dotProduct = Vector.dot(movingObject.velocity, normalVector)
        let reflection = (normalVector * 2.0) * dotProduct

        let finalVelocity = movingObject.velocity - reflection
        movingObject.velocity = finalVelocity

        if let gameObject = stationaryObject as? (any GameObject) {
            gameObject.activateGameObject()
        }
    }

    /// Rectangle collision
    func closestPointOnRect(to circleCenter: Vector, rect: CGRect) -> Vector {
        let clampedX = max(rect.minX, min(circleCenter.x, rect.maxX))
        let clampedY = max(rect.minY, min(circleCenter.y, rect.maxY))
        return Vector(x: clampedX, y: clampedY)
    }

    /*
    func resolveCircleRectangleCollision(circle: inout Circle, rect: CGRect) {
        let closestPoint = closestPointOnRect(to: circle.center, rect: rect)
        let direction = (circle.center - closestPoint)
        let distance = direction.magnitude

        if distance < circle.radius {
            // Collision detected, resolve it
            let overlap = circle.radius - distance
            let correction = direction.normalized * overlap
            circle.center = circle.center + correction

            // Reflect velocity (simplified reflection for demonstration)
            let normal = direction.normalized
            let dotProduct = Vector.dot(circle.velocity, normal)
            let reflection = (normal * 2.0) * dotProduct
            circle.velocity = circle.velocity - reflection

            // Activate the game object if needed
            // if let gameObject = rect as? (any GameObject) {
            //     gameObject.activateGameObject()
            // }
        }
    }
     */
}
