import SwiftUI

protocol GameObjectManagement {
    func getCurrentBallPosition() -> Vector
    func handleGameObjectRemoval(_ view: GameObjectView)
}

extension MainViewModel: GameObjectManagement {

    // Communication intermediary method between BallView and GameEngine
    func getCurrentBallPosition() -> Vector {
        peggleGameEngine.currentBallPosition
    }

    func handleGameObjectRemoval(_ view: GameObjectView) {
        peggleGameEngine.handleGameObjectRemoval(id: view.gameObject.id)
    }
}
