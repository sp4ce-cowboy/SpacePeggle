import SwiftUI

struct GameObjectsBoardView: View {
    @EnvironmentObject var viewModel: GameSceneViewModel

    var body: some View {
        ForEach(Array(viewModel.gameObjects.keys), id: \.self) { id in
            if let gameObject = viewModel.gameObjects[id] {
                GameObjectView(gameObject: gameObject)
            }
        }
    }
}
