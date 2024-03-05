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
        Logger.log("Game has started from MainViewModel", self)
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
        Logger.log("Game has been stopped from MainViewModel", self)
        peggleGameEngine.delegate = nil
        gameLoop.invalidate()
        print("game stopped from viewmodel")
    }

    func uploadLevel(to level: AbstractLevel) {
        peggleGameEngine.currentLevel = level
    }

}
