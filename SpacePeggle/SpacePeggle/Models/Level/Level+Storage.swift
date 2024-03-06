import SwiftUI

/// This extension adds encoding and decoding functionality to a given level
extension Level {
    func encode(to encoder: Encoder) throws {
        Logger.log("Level encoded called", "Level+Storage")
        var container = encoder.container(keyedBy: Enums.LevelCodingKeys.self)
        try container.encode(name, forKey: .name)
        var objectsContainer = container.nestedUnkeyedContainer(forKey: .gameObjects)
        try gameObjects.values.forEach { try objectsContainer.encode($0) }
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Enums.LevelCodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        var objectsArrayForType = try container.nestedUnkeyedContainer(forKey: .gameObjects)
        var objects: [any GameObject] = []

        while !objectsArrayForType.isAtEnd {
            let gameObjectDict = try objectsArrayForType.nestedContainer(keyedBy: Enums.GameObjectCodingKeys.self)
            if let gameObject = try Level.decodeObject(gameObjectDict) {
                objects.append(gameObject)
            }
        }

        Logger.log("Loaded level with \(objects.count)")
        let gameObjectsMap = Level.generateGameObjectsCollection(objects)

        self.init(name: name, gameObjects: gameObjectsMap)
    }

    private static func decodeObject(_ gameObjectDict: KeyedDecodingContainer<Enums.GameObjectCodingKeys>)
    throws -> (any GameObject)? {

        let gameObjectType = try gameObjectDict.decode(Enums.GameObjectType.self, forKey: .gameObjectType)
        let id = try gameObjectDict.decode(UUID.self, forKey: .id)
        let center = try gameObjectDict.decode(Vector.self, forKey: .center)
        let shapeWidth = try gameObjectDict.decode(Double.self, forKey: .shapeWidth)
        let shapeHeight = try gameObjectDict.decode(Double.self, forKey: .shapeHeight)
        let shapeRotation = try gameObjectDict.decode(Double.self, forKey: .shapeRotation)
        let shapeScale = try gameObjectDict.decode(Double.self, forKey: .shapeScale)
        let shapeType = try gameObjectDict.decode(Enums.ShapeType.self, forKey: .shapeType)
        let hp = try gameObjectDict.decode(Enums.ShapeType.self, forKey: .shapeType)

        let decodedShape: UniversalShape = ObjectSet
            .fullShapeCreation[shapeType]?(shapeHeight, shapeWidth, shapeRotation, shapeScale) ??
        Constants.DEFAULT_CIRCULAR_SHAPE

        let gameObject = ObjectSet.fullGameObjectCreation[gameObjectType]?(center, id, decodedShape)
        return gameObject
    }
}
