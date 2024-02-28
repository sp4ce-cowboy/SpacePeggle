import SwiftUI

@main
struct SpacePeggleApp: App {
    @StateObject var sceneController = SceneController.shared

    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                sceneController.currentScene(geometry: geometry)
                    .id(sceneController.currentSceneName)
            }
            .animation(.default, value: sceneController.currentSceneName)
        }
    }
}
