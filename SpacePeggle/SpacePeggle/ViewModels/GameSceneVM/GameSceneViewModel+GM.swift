import SwiftUI

/// This extension adds some Game state transition abilities to the GSVM.
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
