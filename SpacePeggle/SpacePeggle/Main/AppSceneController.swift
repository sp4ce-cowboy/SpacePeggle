import SwiftUI

/// The controller of the
final class AppSceneController: ObservableObject {
    @Published private(set) var currentSceneName: String = "StartScene"
    static let shared = AppSceneController() // Singleton instance

    /// A dictionary mapping strings to closures that return some View
    private(set) static var sceneCollection: [String: (GeometryProxy) -> AnyView] = [:]

    // Make the initializer private to prevent instantiation
    private init() { }

    @ViewBuilder
    func currentScene(geometry: GeometryProxy) -> some View {
        if let viewClosure = AppSceneController.sceneCollection[currentSceneName] {
            viewClosure(geometry) // ViewBuilder infers returned view type
        } else {
            StartScene(forGeometry: geometry)
        }
    }

    func updateScene(to sceneName: String) {
        guard AppSceneController.sceneCollection.keys.contains(sceneName) else {
            return
        }
        currentSceneName = sceneName
    }

    static func uploadScene(withName name: String,
                            withViewClosure viewClosure: @escaping (GeometryProxy) -> AnyView) {
        AppSceneController.sceneCollection[name] = viewClosure
    }

}
