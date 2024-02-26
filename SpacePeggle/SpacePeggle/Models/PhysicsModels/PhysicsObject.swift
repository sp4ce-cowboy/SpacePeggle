import Foundation
import SwiftUI

/// Model of a PhysicsObject. Every physics object will involve itself in the laws of physics.
///
/// Every physics object will have a mass, a velocity (even if that velocity is zero) and a
/// center position. Every physics object will have a function to
protocol PhysicsObject: UniversalObject {
    var mass: Double { get set }
    var velocity: Vector { get set }
    var force: Vector { get set }
    var acceleration: Vector { get }
    var shape: PhysicsShape { get }

    init(mass: Double, velocity: Vector,
         centerPosition: Vector, force: Vector, id: UUID)

    mutating func applyPhysics(timeStep: TimeInterval)

    func intersects(with object: any PhysicsObject) -> Bool
}

/// The default implementation of a Physics Object.
///
/// This allows for PhysicsObjects to have the manipulation of
/// their physical properties to be abstracted away.
extension PhysicsObject {
    var acceleration: Vector {
        force / mass
    }

    var isMovable: Bool {
        mass.isFinite
    }

    mutating func applyPhysics(timeStep: TimeInterval) {
        let accelerationVector = self.force / self.mass
        let changeInVelocity = accelerationVector * timeStep
        let finalVelocity = velocity + changeInVelocity
        velocity = finalVelocity
        // centerPosition = centerPosition +c
    }

    mutating func applyVelocityOnPosition(timeStep: TimeInterval) {
        // Displacement = Velocity * Time
        let newPosition = centerPosition + (velocity * timeStep)
        centerPosition = newPosition
    }

    mutating func applyAccelerationOnVelocity(timeStep: TimeInterval) {
        let newVelocity = velocity + (acceleration * timeStep)
        velocity = newVelocity
    }

    mutating func subjectToGravity() {
        force = Constants.UNIVERSAL_GRAVITY * mass
    }
}

/// Default collision resolution for PhysicsObjects
extension PhysicsObject {
    func intersects(with object: any PhysicsObject) -> Bool {
        self.shape.intersects(with: object.shape)
    }
}