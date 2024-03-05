import SwiftUI
/// This scene allows any internal game engine to weakly refer to the
/// parent ViewModel in order to provide for callback functions like
/// updating the views of game object states.
protocol GameEngineDelegate: AnyObject {
    func processActiveGameObjects(withID id: UUID)
    func transferScores(scores: ScoreBoard)
    func triggerLoss()
}

class GameSceneViewModel: ObservableObject, GameEngineDelegate {

    @Published var gameObjectOpacities: [UUID: Double] = [:]
    @Published var scores = ScoreBoard()

    var sceneController: AppSceneController
    var peggleGameEngine: AbstractGameEngine
    var geometryState: GeometryProxy
    var currentViewSize: CGSize { geometryState.size }
    var gameLoop = DisplayLink()
    var isPaused = false
    var isWin = false
    var isLose = false

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
        AudioManager.shared.stop()
        sceneController.transitionToStartScene()
    }

    func transferScores(scores: ScoreBoard) {
        triggerRefresh()
        self.scores = scores

        if scores.getWinState {
            self.stopGame()
            self.isWin = true
            AudioManager.shared.stop()
            AudioManager.shared.playWinSoundEffect()
            return
        }

        if scores.getLoseState {
            triggerLoss()
        }
    }

    func triggerLoss() {
        triggerRefresh()
        self.stopGame()
        self.isLose = true
        AudioManager.shared.stop()
        AudioManager.shared.playLoseSoundEffect()
        return
    }

    func getHighScore() -> Int {
        triggerRefresh()
        return scores.currentScore
    }

}
