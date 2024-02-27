import SwiftUI

/// The Ball model extends the PhysicsObject protocol
class Ball: PhysicsObject {

    /// The Ball's physics radius is tied to the same radius as the view of the ball,
    /// without the ball depending on the view nor vice versa. This allows physics
    /// interactions to be synchronized with the visual representations without
    /// them being dependent on each other.
    static let BALL_RADIUS = Double(ObjectSet
        .defaultPhysicsObjectSet["Ball"]?.size.width ?? CGFloat(Constants.UNIVERSAL_LENGTH)) / 2

    var id: UUID
    var mass: Double
    var centerPosition: Vector
    var velocity: Vector
    var force: Vector
    var shape: PhysicsShape
    var isSubjectToGravity = false

    required init(mass: Double = 100,
                  velocity: Vector = Vector.zero,
                  centerPosition: Vector = .zero,
                  force: Vector = .zero,
                  id: UUID = UUID()) {

        self.mass = mass
        self.centerPosition = centerPosition
        self.velocity = velocity
        self.force = force
        self.id = id
        self.shape = CircleShape(center: centerPosition, radius: Ball.BALL_RADIUS)
    }

    func updatePosition(to finalLocation: Vector) {
        self.centerPosition = finalLocation
        self.shape.updateCenter(to: self.centerPosition)
    }

    func applyPhysics(timeStep: TimeInterval) {
        if !isSubjectToGravity {
            subjectToGravity()
        }
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
        let tempForce = force + (Constants.UNIVERSAL_GRAVITY * mass)
        force = tempForce
        isSubjectToGravity = true
    }

}
