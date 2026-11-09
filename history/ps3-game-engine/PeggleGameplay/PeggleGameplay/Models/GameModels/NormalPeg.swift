import Foundation
import SwiftUI

/// Active is used instead of Glowing as Active is a semantic name as opposed to Glowing
/// which can be tied up with the View. Since active pegs can have different properties, for
/// example if active pegs were required to wiggle around or something, they might have other
/// properties, thus they are modelled as a Subclass and not a simple boolean flag.
class NormalPeg: Peg {
    required init(centerPosition: Vector, id: UUID = UUID(), gameObjectType: String = "NormalPeg") {
        super.init(centerPosition: centerPosition, id: id, gameObjectType: gameObjectType)
    }

    required init(mass: Double, velocity: Vector, centerPosition: Vector, force: Vector, id: UUID) {
        super.init(mass: mass, velocity: velocity, centerPosition: centerPosition, force: force, id: id)
    }

    override func activateGameObject() {
        self.gameObjectType = "NormalPegActive"
        isActive = true
    }
}
