import SwiftUI

protocol GameObjectManager {
    func getCurrentBallPosition() -> Vector
    func handleGameObjectRemoval(_ view: GameObjectView)
}

extension GameSceneViewModel: GameObjectManager {

    // Communication intermediary method between BallView and GameEngine
    func getCurrentBallPosition() -> Vector {
        peggleGameEngine.currentBallPosition
    }

    // Communication intermediary method between BallView and GameEngine
    func getCurrentBallShape() -> UniversalShape {
        peggleGameEngine.currentBallShape
    }

    // Communication intermediary method between BucketView and GameEngine
    var bucket: Bucket {
        peggleGameEngine.bucket
    }

    var bucketImage: String {
        ObjectSet.defaultGameObjectSet["Bucket"]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB
    }

    var bucketImageAspectRatio: CGSize {
        ObjectSet.defaultGameObjectSet["Bucket"]?.size ?? ObjectSet.CONSTANT_SIZE
    }

    func handleGameObjectRemoval(_ view: GameObjectView) {
        peggleGameEngine.handleGameObjectRemoval(id: view.gameObject.id)
    }

}
