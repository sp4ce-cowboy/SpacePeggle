import SwiftUI

/// This extension adds core game logic to `GameEngine`, like
/// starting, stopping, and updating the game or loading a new level
extension GameEngine {
    func startGame(with level: AbstractLevel) {
        self.isGameActive = true
        self.loadLevel(with: level)
        Logger.log("Start method: Game is loaded with \(currentLevel.gameObjects.count)", self)

        for object in gameObjects.values {
            switch object.gameObjectType {
            case .GoalPeg, .GoalPegActive:
                scores.totalGoalPegsCount += 1
            case .NormalPeg, .NormalPegActive:
                scores.totalNormalPegsCount += 1
            case .BlockPeg:
                break
            case .SpookyPeg, .SpookyPegActive:
                scores.totalSpookyPegsCount += 1
            case .KaboomPeg, .KaboomPegActive:
                break
            case .StubbornPeg:
                break
            }
        }
    }

    func loadLevel(with level: AbstractLevel = LevelStub().getLevelOneStub()) {
        self.currentLevel = level
        Logger.log("Load function: Game is loaded with "
                   + "\(currentLevel.gameObjects.count)", self)

        self.updatePhysicsObjectsFromGameObjects() // Add game objects to physics engine
        physicsEngine.addPhysicsObject(object: self.bucket.bucketLeft)
        physicsEngine.addPhysicsObject(object: self.bucket.bucketRight)
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
        // Logger.log("Bucket center = \(bucket.centerPosition) and velocity = \(bucket.velocity)", self)
        // self.startGame(with: currentLevel)
        // Logger.log("number of game objects = \(gameObjects.values.count)")
        /*if gameObjects.values.isEmpty {
         withAnimation(.easeOut(duration: Constants.TRANSITION_INTERVAL)) {
         self.startGame(with: level)
         }
         }*/
    }
}
