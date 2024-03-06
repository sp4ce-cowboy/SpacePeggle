import SwiftUI

final class StubbornPeg: Peg {

    var id: UUID
    var centerPosition: Vector
    var shape: UniversalShape

    var mass: Double = Constants.UNIVERSAL_LENGTH * Constants.STUBBORN_PEG_DENSITY

    var velocity: Vector = .zero
    var force: Vector = .zero

    var gameObjectType: Enums.GameObjectType = .StubbornPeg
    var isActive = false
    var hp: Double?

    init(centerPosition: Vector,
         id: UUID = UUID(),
         gameObjectType: Enums.GameObjectType = .StubbornPeg,
         shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE,
         hp: Double? = nil) {

        self.centerPosition = centerPosition
        self.id = id
        self.shape = shape
        self.hp = nil
    }

    init(mass: Double = .infinity,
         velocity: Vector = .zero,
         centerPosition: Vector,
         force: Vector = .zero,
         id: UUID = UUID(),
         shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {

        self.velocity = velocity
        self.centerPosition = centerPosition
        self.force = force
        self.id = id
        self.shape = shape
        self.mass = shape.width * Constants.STUBBORN_PEG_DENSITY
    }

    /// To override default implementation
    func activateGameObject() {  }

    func updatePosition(to finalLocation: Vector) {
        self.centerPosition = finalLocation
    }

    func applyPhysics(timeStep: TimeInterval) {
        // applyRestitution()
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

    func subjectToGravity() {  }

    func applyRestitution() {
        // Ensure no micro-movements
        if velocity.magnitude < Constants.STUCK_VELOCITY_THRESHOLD {
            velocity = .zero
            return
        }

        let newVelocity = velocity * (Constants.UNIVERSAL_RESTITUTION)
        velocity = newVelocity
    }

}
