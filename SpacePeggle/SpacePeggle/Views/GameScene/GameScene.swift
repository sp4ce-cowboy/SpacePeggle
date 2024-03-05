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
            BucketView()
            GameObjectsBoardView()
        }
        .if(viewModel.isPaused) { view in
            view.overlay { GameMenuView() }
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
