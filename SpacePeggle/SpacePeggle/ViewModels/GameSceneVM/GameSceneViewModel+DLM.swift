import Foundation
import SwiftUI

protocol DisplayLinkManager {
    func setupGameLoop()
    func startGame()
    func stopGame()
    func updateGame(timeStep: TimeInterval)
}

extension GameSceneViewModel: DisplayLinkManager {

    func setupGameLoop() {
        gameLoop.onUpdate = { [weak self] frameDuration in
            self?.updateGame(timeStep: frameDuration)
        }
    }

    func startGame() {
        isPaused = false
        // DisplayLink.sharedInstance.setupDisplayLink()
        gameLoop.setupDisplayLink()
        peggleGameEngine.startGame(with: self.getLevel())
    }

    func updateGame(timeStep: TimeInterval) {
        DispatchQueue.main.async { self.objectWillChange.send() }
        if !isPaused { peggleGameEngine.updateGame(timeStep: timeStep) }
    }

    func stopGame() {
        gameLoop.invalidate()
    }

    func uploadLevel(to level: AbstractLevel) {
        peggleGameEngine.currentLevel = level
    }

}
