import SwiftUI
import Foundation

protocol Peg: GameObject, PhysicsObject {

    var id: UUID { get set }
    var centerPosition: Vector { get set }

    var mass: Double { get set }
    var velocity: Vector { get set }
    var force: Vector { get set }
    var shape: any UniversalShape { get set }
    var hp: Int { get set }

    var gameObjectType: Enums.GameObjectType { get set }
    var isActive: Bool { get set }

}
