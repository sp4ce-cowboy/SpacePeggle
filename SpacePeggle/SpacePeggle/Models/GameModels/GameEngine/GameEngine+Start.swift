import SwiftUI

/// This extension adds core game logic to `GameEngine`, like
/// starting, stopping, and updating the game or loading a new level
extension GameEngine {
    func startGame() {
        self.isGameActive = true
        self.loadLevel()
        Logger.log("Start method: Game is loaded with \(currentLevel.gameObjects.count)", self)
    }

    func loadLevel() {
        self.currentLevel = LevelStub().getLevelStub()
        Logger.log("Load function: Game is loaded with"
                   + "\(currentLevel.gameObjects.count)", self)

        self.updatePhysicsObjectsFromGameObjects() // Add game objects from level to physics engine
    }

    func updateGame(timeStep: TimeInterval) {
        physicsEngine.updatePhysics(timeStep: timeStep) // Updates PhysicsObjects
        synchronizeGameObjects() // Updates GameObjects from PhysicsObjects
        updateGameState() // Checks if ball out of bounds
        updateLevelState() // Check if game board is empty
    }

    func stopGame() {
        // MARK: - Game stop point. Can be used for post-game clean up
        isGameActive = false
    }

    func updateLevelState() {
        // Logger.log("number of game objects = \(gameObjects.values.count)")
        if gameObjects.values.isEmpty {
            withAnimation(.easeOut(duration: Constants.TRANSITION_INTERVAL)) {
                self.startGame()
            }
        }
    }
}
