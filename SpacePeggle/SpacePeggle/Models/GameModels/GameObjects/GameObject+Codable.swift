import SwiftUI

/// This provides a default implementation for a GameObject to be coded and decoded
extension GameObject {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Enums.CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let x = try container.decode(Double.self, forKey: .centerPositionX)
        let y = try container.decode(Double.self, forKey: .centerPositionY)
        let type = try container.decode(String.self, forKey: .gameObjectType)

        let shapeWidth = try container.decode(Double.self, forKey: .shapeWidth)
        let shapeHeight = try container.decode(Double.self, forKey: .shapeHeight)
        // let shapeRotation = try container.decode(Double.self, forKey: .shapeRotation)
        let shapeRotation = try container.decode(Double.self, forKey: .shapeRotation)
        let shapeScale = try container.decode(Double.self, forKey: .shapeScale)
        let shapeType = try container.decode(String.self, forKey: .shapeType)

        var shape: UniversalShape

        switch shapeType {
        case Enums.ShapeType.circle.rawValue:
            shape = CircularShape(radius: shapeWidth,
                                  rotation: shapeRotation,// Angle(radians: shapeRotation),
                                  scale: shapeScale)

        case Enums.ShapeType.rectangle.rawValue:
            shape = RectangularShape(height: shapeHeight, width: shapeWidth,
                                     rotation: shapeRotation, // Angle(radians: shapeRotation),
                                     scale: shapeScale)
        default:
            shape = RectangularShape(height: shapeHeight, width: shapeWidth,
                                     rotation: shapeRotation, // Angle(radians: shapeRotation),
                                     scale: shapeScale)
        }

        self.init(centerPosition: Vector(x: x, y: y), id: id,
                  gameObjectType: type, shape: shape)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Enums.CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(centerPosition.x, forKey: .centerPositionX)
        try container.encode(centerPosition.y, forKey: .centerPositionY)
        try container.encode(gameObjectType, forKey: .gameObjectType)

        try container.encode(shape.trueWidth, forKey: .shapeWidth)
        try container.encode(shape.trueHeight, forKey: .shapeHeight)
        // try container.encode(shape.rotation.radians, forKey: .shapeRotation)
        try container.encode(shape.rotation, forKey: .shapeRotation)
        try container.encode(shape.scale, forKey: .shapeScale)
        try container.encode(shape.shapeType, forKey: .shapeType)
    }
}
