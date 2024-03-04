import SwiftUI

final class BlockPeg: Peg {

    var id: UUID
    var centerPosition: Vector
    var shape: UniversalShape

    var mass: Double = .infinity
    var velocity: Vector = .zero
    var force: Vector = .zero

    var gameObjectType: Enums.GameObjectType = .BlockPeg
    var isActive = false

    init(centerPosition: Vector,
         id: UUID = UUID(),
         gameObjectType: Enums.GameObjectType = .BlockPeg,
         shape: UniversalShape = Constants.DEFAULT_RECTANGULAR_SHAPE) {

        self.centerPosition = centerPosition
        self.id = id
        self.shape = shape
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
