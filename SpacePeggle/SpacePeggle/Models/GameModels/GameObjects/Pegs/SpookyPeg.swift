import SwiftUI

final class SpookyPeg: Peg {
    var id: UUID
    var centerPosition: Vector
    var shape: UniversalShape

    var mass: Double = .infinity
    var velocity: Vector = .zero
    var force: Vector = .zero

    var gameObjectType: Enums.GameObjectType = .SpookyPeg
    var isActive = false
    var hp: Int = 1

    init(centerPosition: Vector,
         id: UUID = UUID(),
         gameObjectType: Enums.GameObjectType = .SpookyPeg,
         shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE,
         hp: Int = 1) {

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
         shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {

        self.mass = mass
        self.velocity = velocity
        self.centerPosition = centerPosition
        self.force = force
        self.id = id
        self.shape = shape
    }

    func activateGameObject() {
        self.gameObjectType = .SpookyPegActive
        isActive = true
    }
}
