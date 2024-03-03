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
            .animation(.default.delay(0.5), value: sceneController.currentSceneName)
            .onAppear {
                Constants.UI_SCREEN_SIZE = Constants.getFullScreenWithSafeEdges(from: geometry).size
                Logger.log("Screen size is \(Constants.UI_SCREEN_SIZE)", self)
                Logger.log("Safe area total top + bottom is " +
                           "\(geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom)", self)
                Logger.log("Vector size is \(Vector.zero.widthScale) and \(Vector.zero.heightScale)", self)
            }
        }
        // .ignoresSafeArea()
        // .aspectRatio(3 / 4, contentMode: .fit) // MARK: This changes the UI_SCREEN_SIZE above!

    }

}

#Preview {
    AppScene()
        .environmentObject(AppSceneController.shared)
        .preferredColorScheme(.dark)
}
