import SwiftUI

struct GameScene: View {
    /// StateObject becauses MainView owns this ViewModel
    @StateObject var viewModel: GameSceneViewModel

    init(forGeometry geometryState: GeometryProxy) {
        _viewModel = StateObject(wrappedValue: GameSceneViewModel(geometryState))
    }

    // @ViewBuilder
    var body: some View {
        ZStack {
            GameAreaView()
            GamePauseButtonView()
            BallView()
            LauncherView()
            BucketView()
            GameObjectsBoardView()
        }
        .if(viewModel.isPaused) { view in
            view.overlay { GameMenuView() }
        }
        .background { GameBackgroundView() }
        .environmentObject(viewModel)
        .onAppear {
            viewModel.startGame()
        }
        .onDisappear {
            viewModel.stopGame()
        }
    }
}

#Preview {
    GeometryReader { proxy in
        GameScene(forGeometry: proxy)
    }
}
