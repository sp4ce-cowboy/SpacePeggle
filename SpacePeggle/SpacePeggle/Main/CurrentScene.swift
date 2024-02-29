import SwiftUI

struct CurrentScene: View {
    @EnvironmentObject var sceneController: AppSceneController

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                sceneController
                    .currentScene(geometry: geometry)
                    .id(sceneController.currentSceneName)
            }
            .animation(.default, value: sceneController.currentSceneName)
            .onAppear {
                Logger.log("UIScreen size is \(Constants.UI_SCREEN_SIZE)", self)

                let edges = geometry.safeAreaInsets
                let totalWidth = geometry.size.width + edges.leading + edges.trailing
                let totalHeight = geometry.size.height + edges.top + edges.bottom
                let fullSize = CGSize(width: totalWidth, height: totalHeight)
                Constants.UI_SCREEN_SIZE = fullSize
                Logger.log("Geometry screen size is \(Constants.UI_SCREEN_SIZE)", self)
            }
        }

    }
}
