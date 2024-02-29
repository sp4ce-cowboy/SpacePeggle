import SwiftUI

/// Displays the current app scene as indicated by the observed
/// `AppSceneController`.
///
/// Changes to the current app scene will be registered within
/// the scene controller, and these changes will cause SwiftUI to
/// redraw this view based on the current app scene indicated within
/// the scene controller.
///
/// These changes will also be drawn with an animation.
struct AppScene: View {
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
                Constants.UI_SCREEN_SIZE = Constants.getFullScreen(from: geometry).size
            }
        }

    }
}
