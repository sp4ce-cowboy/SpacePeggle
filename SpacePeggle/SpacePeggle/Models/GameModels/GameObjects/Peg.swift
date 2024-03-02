import SwiftUI
import Foundation

class Peg: GameObject, PhysicsObject {

    var id: UUID
    var centerPosition: Vector

    var mass: Double = .infinity
    var velocity: Vector = .zero
    var force: Vector = .zero
    var shape: UniversalShape

    var gameObjectType: String = "DefaultPeg"
    var isActive = false

    /// Initializer for Peg as a GameObject
    required init(centerPosition: Vector,
                  id: UUID = UUID(),
                  gameObjectType: String,
                  shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {
        self.centerPosition = centerPosition
        self.id = id
        self.gameObjectType = gameObjectType
        self.mass = .infinity
        self.velocity = .zero
        self.shape = shape
    }

    /// Initializer for Peg as a PhysicsObject
    required init(mass: Double = .infinity,
                  velocity: Vector,
                  centerPosition: Vector,
                  force: Vector,
                  id: UUID = UUID(),
                  shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {
        self.mass = mass
        self.velocity = velocity
        self.force = force
        self.centerPosition = centerPosition
        self.id = id
        self.gameObjectType = "DefaultPeg"
        self.shape = shape
    }

    func activateGameObject() {
        isActive = true
    }

    /*
    static var powerMap: [String: (any GameObject) -> Void] {
        ["DefaultPeg": { object in object.defaultAbility(...) }]
    }

    func gameObjectAbility() {
        /// fade out after ball disappears
        /// - Tell viewmodel to fade out and game engine to remove
        // processActiveGameObjects(withID: self.id)
        ///
    }
    
    func spookyAbility() {
        /// Tell game engine to change boundary for a while until game enters bucket
    }
    
    func kaboomAbility() {
        /// if active, apply a normal velocity to all objects in the region
    }
     */

}
