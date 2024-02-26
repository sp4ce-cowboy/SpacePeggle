import SwiftUI

/// This extension adds core game logic to `GameEngine`, like
/// starting, stopping, and updating the game or loading a new level
extension GameEngine {
    func startGame() {
        self.isGameActive = true
        self.loadLevel()
    }

    func updateGame(timeStep: TimeInterval) {
        physicsEngine.updatePhysics(timeStep: timeStep)
        updateGameObjectState()
        updateBallState()
        updateGameState()
    }

    func stopGame() {
        // MARK: - Game stop point. Can be used for post-game clean up 
        isGameActive = false
    }

    func loadLevel(with level: AbstractLevel = LevelStub.levelStub) {
        self.currentLevel = level
        self.updatePhysicsObjectsFromGameObjects()
    }

    func updateGameState() {
        Logger.log("number of game objects = \(gameObjects.values.count)")
        if gameObjects.values.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // MARK: - Level restart/progress point. Can be used to load other levels in the future.
                self.startGame()    // These are commented out to comply with PS3 requirements
            }
        }
    }

}