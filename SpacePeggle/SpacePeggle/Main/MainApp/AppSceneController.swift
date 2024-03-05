import SwiftUI

/// Controls the current `AppScene`.
///
/// Equivalent somewhat to a ViewModel in the MVVM architecture, but named as
/// such as the AppScene in question does not own the scene controller. The App itself
/// owns the scene controller at the entry point, and propagates this to app scene
/// that it draws. This way, the app's scene states can be initialized before they
/// are drawn on screen. 
///
/// In this way, the scene controller is both the controller and the model, and it
/// follows the singleton design patterns so that only one instance of it can
/// exist at any time.
final class AppSceneController: ObservableObject {
    @Published private(set) var currentSceneName: String = "StartScene"
    @Published var currentLevel: AbstractLevel?
    // static let shared = AppSceneController() // Singleton instance

    /// A dictionary mapping strings to closures that return some View. The
    /// required views are manually loaded at the application's entry point.
    /// This allows for this scene controller to be used as a base for different
    /// application configurations, for example, a version meant for testing purposes.
    private static var sceneCollection:
    [String: (GeometryProxy, AppSceneController) -> AnyView] = [:]

    init() {
        Logger.log("AppSceneController initialized", self)
    }

    deinit {
        Logger.log("AppSceneController deinitialized", self)
    }

    @ViewBuilder
    func currentScene(geometry: GeometryProxy, sceneController: AppSceneController) -> some View {
        if let viewClosure = AppSceneController.sceneCollection[currentSceneName] {
            viewClosure(geometry, sceneController) // ViewBuilder infers returned view type
        } else {
            StartScene(forGeometry: geometry, with: sceneController)
        }
    }

    // func newGameScene(geometry: GeometryProxy)
    func updateScene(to sceneName: String) {
        guard AppSceneController.sceneCollection.keys.contains(sceneName) else {
            return
        }
        currentSceneName = sceneName
    }

    func updateLevel(to level: AbstractLevel) {
        currentLevel = level
    }

    static func uploadScene(withName name: String,
                            withViewClosure viewClosure:
                            @escaping (GeometryProxy, AppSceneController) -> AnyView) {
        AppSceneController.sceneCollection[name] = viewClosure
    }

}
