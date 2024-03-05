import SwiftUI

final class StubbornPeg: Peg {

    var id: UUID
    var centerPosition: Vector
    var shape: UniversalShape

    var mass: Double = 10_000_000
    var velocity: Vector = .zero
    var force: Vector = .zero

    var gameObjectType: Enums.GameObjectType = .StubbornPeg
    var isActive = false

    init(centerPosition: Vector,
         id: UUID = UUID(),
         gameObjectType: Enums.GameObjectType = .StubbornPeg,
         shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {

        self.centerPosition = centerPosition
        self.id = id
        self.shape = shape
    }

    init(mass: Double = .infinity,
         velocity: Vector = .zero,
         centerPosition: Vector,
         force: Vector = .zero,
         id: UUID = UUID(),
         shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {

        self.mass = mass
        self.velocity = velocity
        self.centerPosition = centerPosition
        self.force = force
        self.id = id
        self.shape = shape
    }

    func activateGameObject() {  }

    /*
    func updatePosition(to finalLocation: Vector) {
        self.centerPosition = finalLocation
    }

    func applyPhysics(timeStep: TimeInterval) {
        applyRestitution()
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

    }

    func applyRestitution() {
        let newVelocity = velocity * Constants.UNIVERSAL_RESTITUTION * 1_000
        velocity = newVelocity
    }
     */
}
