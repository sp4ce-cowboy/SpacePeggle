import SwiftUI

struct MainView: View {
    /// StateObject becauses MainView owns this ViewModel
    @StateObject var viewModel: MainViewModel
    // @EnvironmentObject var sceneController: SceneController

    init(forGeometry geometryState: GeometryProxy) {
        _viewModel = StateObject(wrappedValue: MainViewModel(geometryState))
    }

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
            view.overlay { MenuView() }
        }
        .background { BackgroundView() }
        .environmentObject(viewModel)
        .onAppear { viewModel.startGame() }
        .onDisappear { viewModel.stopGame() }
    }
}

#Preview {
    GeometryReader { proxy in
        MainView(forGeometry: proxy)
    }
}
