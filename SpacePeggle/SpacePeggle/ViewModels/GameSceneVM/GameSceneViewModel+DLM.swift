import Foundation
import SwiftUI

protocol DisplayLinkManager {
    func setupDisplayLink()
    func startGame()
    func stopGame()
    func updateGame(timeStep: TimeInterval)
}

extension GameSceneViewModel: DisplayLinkManager {

    func setupDisplayLink() {
        DisplayLink.sharedInstance.onUpdate = { [weak self] frameDuration in
            self?.updateGame(timeStep: frameDuration)
        }
    }

    func startGame() {
        Logger.log("Game has started from MainViewModel", self)
        isPaused = false
        DisplayLink.sharedInstance.setupDisplayLink()
        peggleGameEngine.startGame()
    }

    func updateGame(timeStep: TimeInterval) {
        DispatchQueue.main.async { self.objectWillChange.send() }
        if !isPaused { peggleGameEngine.updateGame(timeStep: timeStep) }
    }

    func stopGame() {
        Logger.log("Game has been stopped from MainViewModel", self)
        peggleGameEngine.delegate = nil
        DisplayLink.sharedInstance.invalidate()
        print("game stopped from viewmodel")
    }

}
