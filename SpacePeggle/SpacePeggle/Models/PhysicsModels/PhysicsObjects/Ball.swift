import SwiftUI

/// The Ball model extends the PhysicsObject protocol
final class Ball: PhysicsObject {

    static let DEFAULT_DIAMETER: Double =
        Double(ObjectSet.defaultPhysicsObjectSet["Ball"]?.size.width ??
               CGFloat(Constants.UNIVERSAL_LENGTH))

    var id: UUID
    var mass: Double
    var centerPosition: Vector
    var velocity: Vector
    var force: Vector
    var shape: UniversalShape = CircularShape(diameter: Ball.DEFAULT_DIAMETER)

    var isSubjectToGravity = false

    init(mass: Double = 100,
         velocity: Vector = Vector.zero,
         centerPosition: Vector = .zero,
         force: Vector = .zero,
         id: UUID = UUID()) {

        self.mass = mass
        self.centerPosition = centerPosition
        self.velocity = velocity
        self.force = force
        self.id = id
    }

    func updatePosition(to finalLocation: Vector) {
        self.centerPosition = finalLocation
    }

    func applyPhysics(timeStep: TimeInterval) {
        // if !isSubjectToGravity {
        subjectToGravity()
        // }
        applyAccelerationOnVelocity(timeStep: timeStep)
        applyVelocityOnPosition(timeStep: timeStep)
    }

    func applyVelocityOnPosition(timeStep: TimeInterval) {
        // Displacement = Velocity * Time
        let newPosition = centerPosition + (velocity * timeStep)
        updatePosition(to: newPosition)
    }

    func applyAccelerationOnVelocity(timeStep: TimeInterval) {
        let newVelocity = velocity + (acceleration * timeStep)
        velocity = newVelocity
    }

    func subjectToGravity() {
        // let tempForce = force + (Constants.UNIVERSAL_GRAVITY * mass)
        force.y = Constants.UNIVERSAL_GRAVITY.y * mass
        isSubjectToGravity = true
    }

}
