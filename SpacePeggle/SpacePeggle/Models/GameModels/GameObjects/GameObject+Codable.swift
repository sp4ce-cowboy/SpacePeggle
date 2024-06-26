import SwiftUI

/// This provides a default implementation for a GameObject to be coded and decoded

extension GameObject {

    init(from decoder: Decoder) throws {
        Logger.log("GameObject decoder init", (any GameObject).self)
        let container = try decoder.container(keyedBy: Enums.GameObjectCodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let center = try container.decode(Vector.self, forKey: .center)
        let gameObjectType = try container.decode(Enums.GameObjectType.self, forKey: .gameObjectType)

        let shapeWidth = try container.decode(Double.self, forKey: .shapeWidth)
        let shapeHeight = try container.decode(Double.self, forKey: .shapeHeight)
        let shapeRotation = try container.decode(Double.self, forKey: .shapeRotation)
        let shapeScale = try container.decode(Double.self, forKey: .shapeScale)
        let shapeType = try container.decode(Enums.ShapeType.self, forKey: .shapeType)
        let hp = try container.decode(Int.self, forKey: .hp)

        var decodedShape: UniversalShape

        switch shapeType {
        case Enums.ShapeType.circle:
            decodedShape = CircularShape(diameter: shapeWidth,
                                         rotation: shapeRotation,
                                         scale: shapeScale)

        case Enums.ShapeType.rectangle:
            decodedShape = RectangularShape(height: shapeHeight,
                                            width: shapeWidth,
                                            rotation: shapeRotation,
                                            scale: shapeScale)
        }

        self.init(centerPosition: center, id: id,
                  gameObjectType: gameObjectType,
                  shape: decodedShape, hp: hp)
    }

    func encode(to encoder: Encoder) throws {
        Logger.log("GameObject encoder func", (any GameObject).self)
        var container = encoder.container(keyedBy: Enums.GameObjectCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(centerPosition, forKey: .center)
        try container.encode(gameObjectType, forKey: .gameObjectType)

        try container.encode(shape.trueWidth, forKey: .shapeWidth)
        try container.encode(shape.trueHeight, forKey: .shapeHeight)

        try container.encode(shape.rotation, forKey: .shapeRotation)
        try container.encode(shape.scale, forKey: .shapeScale)
        try container.encode(shape.shapeType, forKey: .shapeType)
        try container.encode(hp, forKey: .hp)
    }
}
