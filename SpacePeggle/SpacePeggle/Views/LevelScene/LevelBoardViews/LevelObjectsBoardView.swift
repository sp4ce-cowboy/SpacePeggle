import SwiftUI

struct LevelObjectsBoardView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    var body: some View {
        ForEach(Array(viewModel.levelObjects.keys), id: \.self) { id in
            if let levelObject = viewModel.levelObjects[id] {
                LevelObjectView(levelObject: levelObject)
            }
        }
    }
}
