import Foundation
import SwiftUI

protocol DisplayLinkManagement {
    func setupDisplayLink()
    func startGame()
    func stopGame()
    func updateGame(timeStep: TimeInterval)
}

extension MainViewModel: DisplayLinkManagement {

    func setupDisplayLink() {
        DisplayLink.sharedInstance.onUpdate = { [weak self] frameDuration in
            self?.updateGame(timeStep: frameDuration)
        }
    }

    func startGame() {
        isPaused = false
        peggleGameEngine.startGame()
        DisplayLink.sharedInstance.setupDisplayLink()
    }

    func updateGame(timeStep: TimeInterval) {
        DispatchQueue.main.async { self.objectWillChange.send() }
        if !isPaused { peggleGameEngine.updateGame(timeStep: timeStep) }
    }

    func stopGame() {
        DisplayLink.sharedInstance.invalidate()
    }

}
