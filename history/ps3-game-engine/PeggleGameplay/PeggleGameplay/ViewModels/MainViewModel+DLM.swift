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
        peggleGameEngine.startGame()
        DisplayLink.sharedInstance.setupDisplayLink()
    }

    func stopGame() {
        DisplayLink.sharedInstance.invalidate()
    }

    func updateGame(timeStep: TimeInterval) {
        peggleGameEngine.updateGame(timeStep: timeStep)
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}
