import SwiftUI
import Foundation

protocol Peg: GameObject, PhysicsObject {

    var id: UUID { get set }
    var centerPosition: Vector { get set }

    var mass: Double { get set }
    var velocity: Vector { get set }
    var force: Vector { get set }
    var shape: any UniversalShape { get set }

    var gameObjectType: Enums.GameObjectType { get set }
    var isActive: Bool { get set }

    /*
    init(centerPosition: Vector,
         id: UUID,
         gameObjectType: Enums.GameObjectType,
         shape: UniversalShape)

    init(mass: Double, velocity: Vector,
         centerPosition: Vector, force: Vector,
         id: UUID, shape: UniversalShape)
     */

}

/// Adds default methods for Peg struct

/*
 extension Peg {
 
 /// Initializer for Peg as a GameObject
 init(centerPosition: Vector,
 id: UUID = UUID(),
 gameObjectType: Enums.GameObjectType = .NormalPeg,
 shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {
 
 self.init(centerPosition: centerPosition, id: id,
 gameObjectType: gameObjectType, shape: shape)
 }
 
 /// Initializer for Peg as a PhysicsObject
 init(mass: Double = .infinity,
 velocity: Vector,
 centerPosition: Vector,
 force: Vector,
 id: UUID = UUID(),
 shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {
 
 self.init(mass: mass, velocity: velocity,
 centerPosition: centerPosition, force: force,
 id: id, shape: shape)
 }
 
 mutating func activateGameObject() {
 isActive = true
 }
 
 }
 */
