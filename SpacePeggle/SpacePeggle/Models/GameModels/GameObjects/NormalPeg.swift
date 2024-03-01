import Foundation
import SwiftUI

/// Active is used instead of Glowing as Active is a semantic name as opposed to Glowing
/// which can be tied up with the View. Since active pegs can have different properties, for
/// example if active pegs were required to wiggle around or something, they might have other
/// properties, thus they are modelled as a Subclass and not a simple boolean flag.
class NormalPeg: Peg {

    required init(mass: Double = .infinity, velocity: Vector,
                  centerPosition: Vector, force: Vector, id: UUID = UUID(),
                  shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {

        super.init(mass: mass, velocity: velocity,
                   centerPosition: centerPosition, force: force, id: id)
    }

    required init(centerPosition: Vector, id: UUID = UUID(),
                  gameObjectType: String = "NormalPeg",
                  shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {

        super.init(centerPosition: centerPosition, id: id, gameObjectType: gameObjectType)
    }

    override func activateGameObject() {
        self.gameObjectType = "NormalPegActive"
        isActive = true
    }
}
