import Foundation
import SwiftUI

final class GoalPeg: Peg {
    var id: UUID
    var centerPosition: Vector
    var shape: UniversalShape

    var mass: Double = .infinity
    var velocity: Vector = .zero
    var force: Vector = .zero

    var gameObjectType: Enums.GameObjectType = .GoalPeg
    var isActive = false

    /// Initializer for Peg as a GameObject
    init(centerPosition: Vector,
         id: UUID = UUID(),
         gameObjectType: Enums.GameObjectType = .GoalPeg,
         shape: UniversalShape = Constants.DEFAULT_CIRCULAR_SHAPE) {

        self.centerPosition = centerPosition
        self.id = id
        self.shape = shape

    }

    /// Initializer for Peg as a PhysicsObject
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
        self.gameObjectType = .GoalPegActive
        isActive = true
    }

}

/// This provides an implementation for a GoalPeg to be coded and decoded
extension GoalPeg {

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Enums.GameObjectCodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let center = try container.decode(Vector.self, forKey: .center)
        let gameObjectType = try container.decode(Enums.GameObjectType.self, forKey: .gameObjectType)

        let shapeWidth = try container.decode(Double.self, forKey: .shapeWidth)
        let shapeHeight = try container.decode(Double.self, forKey: .shapeHeight)
        let shapeRotation = try container.decode(Double.self, forKey: .shapeRotation)
        let shapeScale = try container.decode(Double.self, forKey: .shapeScale)
        let shapeType = try container.decode(Enums.ShapeType.self, forKey: .shapeType)

        var decodedShape: UniversalShape

        switch shapeType {
        case Enums.ShapeType.circle:
            decodedShape = CircularShape(radius: shapeWidth,
                                         rotation: shapeRotation,
                                         scale: shapeScale)

        case Enums.ShapeType.rectangle:
            decodedShape = RectangularShape(height: shapeHeight,
                                            width: shapeWidth,
                                            rotation: shapeRotation,
                                            scale: shapeScale)
        }

        self.init(centerPosition: center, id: id,
                  gameObjectType: gameObjectType, shape: decodedShape)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Enums.GameObjectCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(centerPosition, forKey: .center)
        try container.encode(gameObjectType, forKey: .gameObjectType)

        try container.encode(shape.trueWidth, forKey: .shapeWidth)
        try container.encode(shape.trueHeight, forKey: .shapeHeight)
        // try container.encode(shape.rotation.radians, forKey: .shapeRotation)
        try container.encode(shape.rotation, forKey: .shapeRotation)
        try container.encode(shape.scale, forKey: .shapeScale)
        try container.encode(shape.shapeType, forKey: .shapeType)
    }
}
