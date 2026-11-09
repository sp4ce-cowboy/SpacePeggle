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

        let normalVector = (movingObject.centerPosition - stationaryObject.centerPosition).normalized()
        let dotProduct = Vector.dot(movingObject.velocity, normalVector)
        let reflection = (normalVector * 2.0) * dotProduct

        let finalVelocity = movingObject.velocity - reflection
        movingObject.velocity = finalVelocity

        if let gameObject = stationaryObject as? (any GameObject) {
            gameObject.activateGameObject()
        }
    }
}
