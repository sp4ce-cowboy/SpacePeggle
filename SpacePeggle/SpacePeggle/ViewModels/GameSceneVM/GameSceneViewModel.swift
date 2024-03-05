import SwiftUI
/// This scene allows any internal game engine to weakly refer to the
/// parent ViewModel in order to provide for callback functions like
/// updating the views of game object states.
protocol GameEngineDelegate: AnyObject {
    func processActiveGameObjects(withID id: UUID)
}

class GameSceneViewModel: ObservableObject, GameEngineDelegate {

    var sceneController: AppSceneController
    @Published var gameObjectOpacities: [UUID: Double] = [:]
    var peggleGameEngine: AbstractGameEngine
    var geometryState: GeometryProxy
    var currentViewSize: CGSize { geometryState.size }
    var gameLoop = DisplayLink()
    var isPaused = false

    init(_ geometryState: GeometryProxy, _ sceneController: AppSceneController) {
        self.geometryState = geometryState
        self.sceneController = sceneController
        self.peggleGameEngine = GameEngine(geometry: geometryState)
        peggleGameEngine.delegate = self
        setupGameLoop()
    }

    deinit {
        peggleGameEngine.delegate = nil
        Logger.log("ViewModel is deinitialized from \(self)", self)
    }

    func triggerRefresh() {
        DispatchQueue.main.async { self.objectWillChange.send() }
    }

    /// The main liasion between the game objects renderer and the game engine that
    /// contains game objects. The penultimate function for all final UI renderings.
    /// Pre-sorting ensures that the dictionary values are only sorted when needed
    var gameObjects: [UUID: any GameObject] {
        peggleGameEngine.gameObjects
    }

    func processActiveGameObjects(withID id: UUID) {
        withAnimation(.easeInOut(duration: Constants.TRANSITION_INTERVAL)) {
            gameObjectOpacities[id] = 0
        }
        // After the fade-out duration, remove the GameObject from the dictionary
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.TRANSITION_INTERVAL + 0.5) {
            self.gameObjectOpacities[id] = nil
        }
    }

    func handlePause() {
        triggerRefresh()
        isPaused.toggle()
        AudioManager.shared.toggle()
    }

    func handleReturnButton() {
        isPaused.toggle()
        AudioManager.shared.toggle()
    }

    func handleExitButton() {
        handleReturnButton()
        sceneController.transitionToStartScene()
    }

}
