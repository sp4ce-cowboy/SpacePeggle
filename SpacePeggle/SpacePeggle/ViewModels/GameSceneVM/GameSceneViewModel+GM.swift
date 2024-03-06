import SwiftUI

/// This extension adds Game state management abilities to the GSVM.
extension GameSceneViewModel {
    func getLevel() -> AbstractLevel {
        Logger.log("Get level is triggered from GameSceneViewModel", self)
        Logger.log("Current level is \(String(describing: sceneController.currentLevel?.gameObjects))", self)

        if let level = sceneController.currentLevel {
            return level
        }

        return LevelStub().getLevelOneStub()
    }
}
