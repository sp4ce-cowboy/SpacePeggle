import SwiftUI

struct StartScene: View {
    @StateObject var viewModel: StartSceneViewModel

    init(forGeometry geometryState: GeometryProxy, with sceneController: AppSceneController) {
        _viewModel = StateObject(wrappedValue: StartSceneViewModel(geometryState, sceneController))
    }

    var width: Double { viewModel.geometryState.size.width }
    var height: Double { viewModel.geometryState.size.height }

    var body: some View {
            ZStack {
                StyleSheet
                    .getRectangleOverlay()
                    .overlay {
                        StartMenuView()
                    }
            }
            .frame(width: width, height: height)
            .background { StartBackgroundView() }
            .environmentObject(viewModel)
    }
}
