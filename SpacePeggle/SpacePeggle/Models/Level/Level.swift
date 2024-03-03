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

    var name: String
    var gameObjects: [UUID: any GameObject]
    var domain: CGRect = Constants.getDefaultFullScreen()

    init(name: String, gameObjects: [UUID: any GameObject],
         domain: CGRect = Constants.getDefaultFullScreen()) {
        defer { Logger.log("Level is initialized with \(gameObjects.count)", self) }
        self.name = name
        self.gameObjects = gameObjects
        self.domain = domain
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

    func updateLevel(_ gameObjects: [UUID: any GameObject]) {
        if verify() {
            self.gameObjects = gameObjects
        }
    }

    /// Implicit checkRep
    func verify() -> Bool {
        gameObjects.allSatisfy({ (key: UUID, value: GameObject) in
            key == value.id
        })
    }

}
