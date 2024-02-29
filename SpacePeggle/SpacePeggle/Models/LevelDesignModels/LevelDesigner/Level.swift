import SwiftUI

extension Level: AbstractLevel { }

/// The Level Model encapsulates information about the level name
/// and contains a collection of GameObjects. This collection is represented
/// with a hashmap to provide for quick access. UUID is Hashable, and GameObjects
/// are implicitly equatable. The chances of a UUID collision is infinitesimal.
///
/// This allows for O(1) average access time. The representation invariant (kind of)
/// here is that all UUID keys must correspond to the UUID contained within the
final class Level {

    var name: String
    var gameObjects: [UUID: any GameObject]

    init(name: String, gameObjects: [UUID: any GameObject]) {
        self.name = name
        self.gameObjects = gameObjects
        Logger.log("Level is initialized with \(gameObjects.count)", self)
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

    /// Implicit checkRep
    func verify() -> Bool {
        gameObjects.allSatisfy({ (key: UUID, value: GameObject) in
            key == value.id
        })
    }
}
