import SwiftUI

struct GameScene: View {
    /// StateObject becauses MainView owns this ViewModel
    @StateObject var viewModel: GameSceneViewModel

    init(forGeometry geometryState: GeometryProxy) {
        _viewModel = StateObject(wrappedValue: GameSceneViewModel(geometryState))
    }

    @ViewBuilder
    var body: some View {
        ZStack {
            GameAreaView()
            PauseButtonView()
            BallView()
            LauncherView()
            BucketView()
            LevelView()
        }
        .if(viewModel.isPaused) { view in
            view.overlay { GameMenuView() }
        }
        .background { BackgroundView() }
        .environmentObject(viewModel)
        .onAppear { viewModel.startGame() }
        .onDisappear { viewModel.stopGame() }
    }
}

#Preview {
    GeometryReader { proxy in
        GameScene(forGeometry: proxy)
    }
}
