import Foundation
import SwiftUI

class GoalPeg: Peg {

    required init(mass: Double, velocity: Vector, centerPosition: Vector,
                  force: Vector, id: UUID = UUID(),
                  shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {

        super.init(mass: mass, velocity: velocity, centerPosition: centerPosition, force: force, id: id, shape: shape)
    }

    required init(centerPosition: Vector, id: UUID = UUID(),
                  gameObjectType: String = "GoalPeg",
                  shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {

        super.init(centerPosition: centerPosition, id: id, gameObjectType: gameObjectType, shape: shape)
    }

    override func activateGameObject() {
        self.gameObjectType = "GoalPegActive"
        isActive = true
    }
}
