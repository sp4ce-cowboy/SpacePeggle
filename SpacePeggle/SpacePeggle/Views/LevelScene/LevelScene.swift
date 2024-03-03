import SwiftUI

struct LevelScene: View {
    @StateObject var viewModel: LevelSceneViewModel

    init(forGeometry geometryState: GeometryProxy) {
        _viewModel = StateObject(wrappedValue: LevelSceneViewModel(geometryState))
    }

    // @ViewBuilder
    var body: some View {
        ZStack {
            PlayableAreaView()
            ActionBarView()
            LevelObjectsBoardView()
            LauncherStubView()
            LevelPauseButtonView()
        }
        .if(viewModel.isLevelDesignerPaused) { view in
            view.overlay { LevelMenuView() }
                .onAppear { Logger.log("Level menu triggered", self) }
        }
        .background { LevelBackgroundView() }
        .environmentObject(viewModel)
    }
}

#Preview {
    GeometryReader { proxy in
        LevelScene(forGeometry: proxy)
    }

}
