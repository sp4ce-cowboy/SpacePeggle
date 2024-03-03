import SwiftUI

final class StubbornPeg: Peg {
    var id: UUID
    var centerPosition: Vector
    var shape: UniversalShape

    var mass: Double = 10_000_000
    var velocity: Vector = .zero
    var force: Vector = .zero

    var gameObjectType: String = "StubbornPeg"
    var isActive = false

    init(centerPosition: Vector,
         id: UUID = UUID(),
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

    func activateGameObject() {
        self.gameObjectType = "StubbornPegActive"
        isActive = true
    }
}
