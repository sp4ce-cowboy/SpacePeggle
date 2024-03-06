import SwiftUI

struct LevelScene: View {
    @StateObject var viewModel: LevelSceneViewModel

    init(forGeometry geometryState: GeometryProxy, with sceneController: AppSceneController) {
        _viewModel = StateObject(wrappedValue: LevelSceneViewModel(geometryState, sceneController))
    }

    // @ViewBuilder
    var body: some View {
        ZStack {
            PlayableAreaView()
            LevelObjectsBoardView()
            LauncherStubView()
            LevelPauseButtonView()
            ActionBarView()
        }
        .if(viewModel.isLevelDesignerPaused) { view in
            view.overlay { LevelMenuView() }
                .onAppear { Logger.log("Level menu triggered", self) }
        }
        .background { LevelBackgroundView() }
        .environmentObject(viewModel)
        // .environmentObject(sceneController)
    }
}
