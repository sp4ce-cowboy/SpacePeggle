import SwiftUI

/// A block is not a peg, but for convenience reasons
final class BlockPeg: GameObject, PhysicsObject {

    var id: UUID
    var centerPosition: Vector
    var shape: UniversalShape

    var mass: Double = .infinity
    var velocity: Vector = .zero
    var force: Vector = .zero

    var hp: Double?

    var gameObjectType: Enums.GameObjectType = .BlockPeg
    var isActive = false

    init(centerPosition: Vector,
         id: UUID = UUID(),
         gameObjectType: Enums.GameObjectType = .BlockPeg,
         shape: UniversalShape = Constants.DEFAULT_RECTANGULAR_SHAPE,
         hp: Double? = nil) {

        self.centerPosition = centerPosition
        self.id = id
        self.shape = shape
        self.hp = hp
    }

    init(mass: Double = .infinity,
         velocity: Vector = .zero,
         centerPosition: Vector,
         force: Vector = .zero,
         id: UUID = UUID(),
         shape: UniversalShape = Constants.DEFAULT_RECTANGULAR_SHAPE) {

        self.mass = mass
        self.velocity = velocity
        self.centerPosition = centerPosition
        self.force = force
        self.id = id
        self.shape = shape
    }

    func activateGameObject() {  }
}
