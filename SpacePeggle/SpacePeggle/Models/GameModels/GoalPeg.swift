import Foundation
import SwiftUI

class GoalPeg: Peg {
    required init(centerPosition: Vector, id: UUID = UUID(), gameObjectType: String = "GoalPeg") {
        super.init(centerPosition: centerPosition, id: id, gameObjectType: gameObjectType)
    }

    required init(mass: Double, velocity: Vector, centerPosition: Vector, force: Vector, id: UUID) {
        super.init(mass: mass, velocity: velocity, centerPosition: centerPosition, force: force, id: id)
    }

    override func activateGameObject() {
        self.gameObjectType = "GoalPegActive"
        isActive = true
    }
}
