import SwiftUI

extension Level: AbstractLevel {
}

/// The Level Model encapsulates information about the level name
/// and contains a collection of GameObjects. This collection is represented
/// with a hashmap to provide for quick access. UUID is Hashable, and GameObjects
/// are implicitly equatable. The chances of a UUID collision is infinitesimal.
///
/// This allows for O(1) average access time.
///
/// Additionally, the Level Model also plays the role of the "Level Engine" equivalent,
/// directly handling game objects movement and collision resolution.
final class Level {

    var name: String = "DefaultLevel"
    var gameObjects: [UUID: any GameObject] = [:]

    init(name: String = "DefaultLevel",
         gameObjects: [UUID: any GameObject] = [:] ) {
        defer { Logger.log("Level is initialized with \(gameObjects.count)", self) }
        self.name = name
        self.gameObjects = gameObjects
    }

    deinit {
        Logger.log("Level is deinitialized with \(gameObjects.count)", self)
    }

    func getGameObject(id: UUID) -> (any GameObject)? {
        let gameObject = gameObjects[id]
        // Ensures no UUID corruption
        guard gameObject?.id == id else {
            return nil
        }
        return gameObject
    }

    /// Stores game object if it doesn't exist and overwrites if it does
    func storeGameObject(_ gameObject: any GameObject) {
        gameObjects[gameObject.id] = gameObject
        // assert(verify())
    }

    func updateLevel(fromDictionary gameObjects: [UUID: any GameObject]) {
        if verify() {
            self.gameObjects = gameObjects
        }
    }

    func updateLevel(fromArray gameObjects: [any GameObject]) {
        self.gameObjects = Level.generateGameObjectsCollection(gameObjects)
    }

    static func generateGameObjectsCollection(_ gameObjects: [any GameObject]) -> [UUID: any GameObject] {
        var gameObjectsMap: [UUID: any GameObject] = [:]

        for gameObject in gameObjects {
            gameObjectsMap[gameObject.id] = gameObject
        }

        return gameObjectsMap
    }

    /// Implicit checkRep
    func verify() -> Bool {
        gameObjects.allSatisfy({ (key: UUID, value: GameObject) in
            key == value.id
        })
    }

    func encode(to encoder: Encoder) throws {
        Logger.log("Level encoded called", "Level+Storage")
        var container = encoder.container(keyedBy: Enums.LevelCodingKeys.self)
        try container.encode(name, forKey: .name)

        // Encode each GameObject with type discrimination
        // var objectsContainer = container.nestedUnkeyedContainer(forKey: .gameObjects)
        var objectsContainer = container.nestedUnkeyedContainer(forKey: .gameObjects)

        for object in gameObjects.values {
            let gameObjectType = object.gameObjectType

            switch gameObjectType {
            case .NormalPeg, .NormalPegActive:
                try objectsContainer.encode(object)
            case .GoalPeg, .GoalPegActive:
                try objectsContainer.encode(object as? GoalPeg)
            case .SpookyPeg, .SpookyPegActive:
                break
            case .KaboomPeg, .KaboomPegActive:
                break
            case .StubbornPeg:
                break
            case .BlockPeg:
                break
            }
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Enums.LevelCodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)

        var objectsArrayForType = try container.nestedUnkeyedContainer(forKey: .gameObjects)
        var objects: [any GameObject] = []

        while !objectsArrayForType.isAtEnd {
            let gameObjectDict = try objectsArrayForType.nestedContainer(keyedBy: Enums.GameObjectCodingKeys.self)
            if let gameObject = try decodeObject(gameObjectDict) {
                objects.append(gameObject)
            }
        }

        Logger.log("Loaded level with \(objects.count)")
        let gameObjectsMap = Level.generateGameObjectsCollection(objects)
        Logger.log("New loaded level now contains \(gameObjectsMap)", "Level+Storage")
        self.name = name
        self.gameObjects = gameObjectsMap
    }

    private func decodeObject(_ gameObjectDict: KeyedDecodingContainer<Enums.GameObjectCodingKeys>)
    throws -> (any GameObject)? {

        let gameObjectType = try gameObjectDict.decode(Enums.GameObjectType.self, forKey: .gameObjectType)
        let id = try gameObjectDict.decode(UUID.self, forKey: .id)
        let center = try gameObjectDict.decode(Vector.self, forKey: .center)
        let shapeWidth = try gameObjectDict.decode(Double.self, forKey: .shapeWidth)
        let shapeHeight = try gameObjectDict.decode(Double.self, forKey: .shapeHeight)
        let shapeRotation = try gameObjectDict.decode(Double.self, forKey: .shapeRotation)
        let shapeScale = try gameObjectDict.decode(Double.self, forKey: .shapeScale)
        let shapeType = try gameObjectDict.decode(Enums.ShapeType.self, forKey: .shapeType)

        var decodedShape: UniversalShape

        switch shapeType {
        case Enums.ShapeType.circle:
            decodedShape = CircularShape(diameter: shapeWidth, rotation: shapeRotation, scale: shapeScale)

        case Enums.ShapeType.rectangle:
            decodedShape = RectangularShape(height: shapeHeight, width: shapeWidth,
                                            rotation: shapeRotation, scale: shapeScale)
        }

        let gameObject = ObjectSet.fullGameObjectCreation[gameObjectType]?(center, id, decodedShape)
        return gameObject
    }

}
