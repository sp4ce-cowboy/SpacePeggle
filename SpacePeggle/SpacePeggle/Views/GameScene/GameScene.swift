import SwiftUI

struct GameScene: View {
    @StateObject var viewModel: GameSceneViewModel
    // @EnvironmentObject var sceneController: AppSceneController

    init(forGeometry geometryState: GeometryProxy, with sceneController: AppSceneController) {
        _viewModel = StateObject(wrappedValue:
                                    GameSceneViewModel(geometryState, sceneController))
    }

    // @ViewBuilder
    var body: some View {
        ZStack {
            GameAreaView()
            GamePauseButtonView()
            BallView()
            LauncherView()
            GameObjectsBoardView()
            BucketView()
            ScoreBoardView()
        }
        .if(viewModel.isPaused) { view in
            view.overlay { GameMenuView() }
        }
        .if(viewModel.isWin) { view in
            view.overlay { GameWonView() }
        }
        .if(viewModel.isLose) { view in
            view.overlay { GameOverView() }
        }
        .background { GameBackgroundView() }
        .environmentObject(viewModel)
        // .environmentObject(sceneController)
        .onAppear {
            viewModel.startGame()
        }
        .onDisappear {
            viewModel.stopGame()
        }
    }
}
