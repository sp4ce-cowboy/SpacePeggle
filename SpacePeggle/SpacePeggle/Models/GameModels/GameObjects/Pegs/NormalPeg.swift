import Foundation
import SwiftUI

/// Active is used instead of Glowing as Active is a semantic name as opposed to Glowing
/// which can be tied up with the View. Since active pegs can have different properties, for
/// example if active pegs were required to wiggle around or something, they might have other
/// properties, thus they are modelled as a Subclass and not a simple boolean flag.
final class NormalPeg: Peg {
    var id: UUID
    var centerPosition: Vector
    var shape: UniversalShape

    var mass: Double = .infinity
    var velocity: Vector = .zero
    var force: Vector = .zero

    var gameObjectType: Enums.GameObjectType = .NormalPeg
    var isActive = false

    /// Initializer for Peg as a GameObject
    init(centerPosition: Vector,
         id: UUID = UUID(),
         gameObjectType: Enums.GameObjectType = .NormalPeg,
         shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {

        self.centerPosition = centerPosition
        self.id = id
        self.shape = shape

    }

    /// Initializer for Peg as a PhysicsObject
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

    func activateGameObject() {
        self.gameObjectType = .NormalPegActive
        isActive = true
    }

}
