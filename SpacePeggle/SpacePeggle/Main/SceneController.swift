import SwiftUI

final class SceneController: ObservableObject {
    static let defaultSceneName: String = "StartScene"
    static let shared = SceneController()

    @Published private(set) var currentSceneName: String = SceneController.defaultSceneName

    // Make the initializer private to prevent instantiation
    private init() {}

    deinit {
        Logger.log("SceneController has been deinitialized", self)
    }

    // A dictionary mapping strings to closures that return some View
    lazy var sceneCollection: [String: (GeometryProxy) -> AnyView] = [
        "StartScene": { geometry in AnyView(StartScreenView(proxy: geometry)) },
        "GameScene": { geometry in AnyView(MainView(forGeometry: geometry)) }
    ]

    func currentScene(geometry: GeometryProxy) -> some View {
        guard let viewClosure = sceneCollection[currentSceneName] else {
            return AnyView(StartScreenView(proxy: geometry))
        }
        return viewClosure(geometry)
    }

    private func updateScene(to sceneName: String) {
        guard sceneCollection.keys.contains(sceneName) else {
            return
        }
        currentSceneName = sceneName
    }

}

/// This extension allows for safe, pre-defined transitions between scenes.
///
/// As opposed to having views call the `updateScene` method directly, the
/// call predefined transition triggers that encapsulate the calling of
/// the `updateScene` method with the appropriate scene name.
///
/// This approach allows for the retention of the dictionary's cyclomatic
/// simplicity as opposed to a non-extendable enum while preserving the
/// sub-type safety offered by enums. Essentially, the scene collection can be
/// extended with more scenes (via a simple store method) and this new scene
/// can be safely retrieved from the dictionary by adding an extension to the
/// `SceneController` class that includes a method to transition to this new
/// state.
///
/// Unlike enums whose cases need to be modified to add scenes, this
/// approach respects the open-closed principle. Additionally, unlike dictionaries
/// whose retrieval mechanisms are entirely open-ended as compared to enums,
/// this approach enforces a certain restriction on the transitions available.
extension SceneController {

    func transitionToStartScene() {
        updateScene(to: "StartScene")
    }

    func transitionToGameScene() {
        updateScene(to: "GameScene")
    }
}
