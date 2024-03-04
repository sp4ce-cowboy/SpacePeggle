import SwiftUI

/// This extension adds encoding and decoding functionality to a given level
extension Level {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Enums.LevelCodingKeys.self)
        try container.encode(name, forKey: .name)

        // Encode each GameObject with type discrimination
        var objectsContainer = container.nestedUnkeyedContainer(forKey: .gameObjects)

        for object in gameObjects.values {
            let gameObjectType = object.gameObjectType

            switch gameObjectType {
            case .NormalPeg, .NormalPegActive:
                try objectsContainer.encode(object as? NormalPeg)
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

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Enums.LevelCodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)

        var objectsArrayForType = try container.nestedUnkeyedContainer(forKey: .gameObjects)

        var objects: [any GameObject] = []
        while !objectsArrayForType.isAtEnd {
            let gameObjectDict = try objectsArrayForType.nestedContainer(keyedBy: Enums.GameObjectCodingKeys.self)

            let gameObjectType = try gameObjectDict.decode(Enums.GameObjectType.self,
                                                           forKey: .gameObjectType)
            switch gameObjectType {
            case .NormalPeg, .NormalPegActive:
                let object = try objectsArrayForType.decode(NormalPeg.self)
                Logger.log("Loaded \(object)", "Level+Storage")
                Logger.log("Loaded object type is \(object.self)", "Level+Storage")
                objects.append(object)
            case .GoalPeg, .GoalPegActive:
                let object = try objectsArrayForType.decode(GoalPeg.self)
                objects.append(object)
                Logger.log("Loaded \(object)", "Level+Storage")
                Logger.log("Loaded object type is \(object.self)", "Level+Storage")
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

        let gameObjectsMap = Level.generateGameObjectsCollection(objects)
        Logger.log("New loaded level now contains \(gameObjectsMap)", "Level+Storage")

        self.init(name: name, gameObjects: gameObjectsMap)
    }
}
