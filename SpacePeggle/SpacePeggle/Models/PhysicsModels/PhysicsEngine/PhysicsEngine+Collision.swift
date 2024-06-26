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
                    handleCollisionsBetween(object1: &object1, object2: &object2, with: collideDistance)
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

    func applySpecialPhysicsOn(objectId: UUID, at position: Vector, for radius: Double) {

        /// Explosion will only affect the velocities of objects with finite mass
        guard let physicsObject = physicsObjects[objectId], physicsObject.mass.isFinite else {
            Logger.log("Mass is not finite for \(String(describing: physicsObjects[objectId]))")
            return
        }

        let baseExplosionStrength = Constants.UNIVERSAL_EXPLOSION_STRENGTH
        let distanceVector = physicsObject.centerPosition - position
        let distance = distanceVector.magnitude
        let normalizedDirection = distanceVector.normalized

        let forceMagnitudeFactor = (1 - (distance / (radius * 4)))
        let explosionForceMagnitude = baseExplosionStrength * forceMagnitudeFactor * radius
        let explosionForce = normalizedDirection * explosionForceMagnitude

        let newVelocity = physicsObject.velocity + explosionForce
        physicsObjects[objectId]?.velocity = newVelocity

        Logger.log("Applied explosion force of magnitude \(explosionForce.magnitude) at distance \(distance)", self)

    }
}

/// Adds dynamic collision physics
extension PhysicsEngine {

    private func handleCollisionsBetween(object1: inout any PhysicsObject,
                                         object2: inout any PhysicsObject,
                                         with distance: Double) {

        // Correct positions taking overlap into account
        correctPositions(object1: &object1, object2: &object2, with: distance)

        // Calculate new velocities based on the conservation of momentum
        let (newVelocity1, newVelocity2) =
        calculateNewVelocities(object1: object1, object2: object2)

        object1.velocity = newVelocity1
        object2.velocity = newVelocity2
        // object1.applyRestitution()
        // object2.applyRestitution()

        // Notify delegate about collision
        delegate?.handleCollision(withID: object1.id)
        delegate?.handleCollision(withID: object2.id)
    }

    private func correctPositions(object1: inout any PhysicsObject,
                                  object2: inout any PhysicsObject,
                                  with distance: Double) {

        if object1.isMovable {
            let normalVector = (object1.centerPosition - object2.centerPosition).normalized
            let correction = normalVector * distance
            let correctedPosition = object1.centerPosition + correction
            object1.centerPosition = correctedPosition
        }

        if object2.isMovable {
            let normalVector2 = (object2.centerPosition - object1.centerPosition).normalized
            let correction2 = normalVector2 * distance
            let correctedPosition2 = object2.centerPosition + correction2
            object2.centerPosition = correctedPosition2
        }
    }

    private func calculateNewVelocities(object1: any PhysicsObject,
                                        object2: any PhysicsObject) -> (Vector, Vector) {
        if !object1.isMovable {
            // Object1 is stationary (infinite mass), only reflect object2's velocity
            let reflectedVelocity2 = reflectVelocity(movingObjectVelocity: object2.velocity,
                                                     normal: (object2.centerPosition
                                                              - object1.centerPosition).normalized)

            return (object1.velocity, reflectedVelocity2)

        } else if !object2.isMovable {
            // Object2 is stationary (infinite mass), only reflect object1's velocity
            let reflectedVelocity1 = reflectVelocity(movingObjectVelocity: object1.velocity,
                                                     normal: (object1.centerPosition
                                                              - object2.centerPosition).normalized)

            return (reflectedVelocity1, object2.velocity)
        }

        // Both objects have finite mass, calculate collision response with normals
        let mass1 = object1.mass
        let mass2 = object2.mass

        let velocity1 = object1.velocity
        let velocity2 = object2.velocity

        // Calculate the normal vector from the center of object1 to object2
        let collisionNormal = (object2.centerPosition - object1.centerPosition).normalized

        // Decompose the velocities into components parallel and perpendicular to the normal
        let velocity1Normal = Vector.project(this: velocity1, onto: collisionNormal)
        let velocity2Normal = Vector.project(this: velocity2, onto: collisionNormal)

        let velocity1Tangential = velocity1 - velocity1Normal
        let velocity2Tangential = velocity2 - velocity2Normal

        // Use the conservation of momentum to calculate the new normal components
        let newVelocity1Normal = ((mass1 - mass2) / (mass1 + mass2)) * velocity1Normal
        + ((2 * mass2) / (mass1 + mass2)) * velocity2Normal

        let newVelocity2Normal = ((2 * mass1) / (mass1 + mass2)) * velocity1Normal
        - ((mass1 - mass2) / (mass1 + mass2)) * velocity2Normal

        // Recombine the normal and tangential components
        let newVelocity1 = newVelocity1Normal + velocity1Tangential
        let newVelocity2 = newVelocity2Normal + velocity2Tangential

        return (newVelocity1, newVelocity2)

    }

    private func reflectVelocity(movingObjectVelocity: Vector, normal: Vector) -> Vector {
        let dotProduct = Vector.dot(movingObjectVelocity, normal)
        let reflection = normal * (2.0 * dotProduct)
        return movingObjectVelocity - reflection

    }

}
