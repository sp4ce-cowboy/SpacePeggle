import SwiftUI
/// This scene allows any internal game engine to weakly refer to the
/// parent ViewModel in order to provide for callback functions like
/// updating the views of game object states.
protocol GameEngineDelegate: AnyObject {
    func removeActiveGameObjects(withId id: UUID)
    func processSpecialGameObjects(withId id: UUID)
    func notifyEffect(withId id: UUID)
    func notifySpecialEffect()
    func transferScores(scores: ScoreBoard, state: Bool)
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

    func removeActiveGameObjects(withId id: UUID) {
        /*guard gameObjects[id]?.gameObjectType != .SpookyPegActive else {
         return
         }*/

        withAnimation(.easeInOut(duration: Constants.TRANSITION_INTERVAL)) {
            gameObjectOpacities[id] = 0
        }
        // After the fade-out duration, remove the GameObject from the dictionary
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.TRANSITION_INTERVAL + 0.5) {
            self.gameObjectOpacities[id] = nil
        }

    }

    /// Remove exploding pegs
    func processSpecialGameObjects(withId id: UUID) {
        // for (id, value) in gameObjects where value.gameObjectType == .KaboomPegActive {

        withAnimation(.easeInOut(duration: Constants.TRANSITION_INTERVAL)) {
            gameObjectOpacities[id] = 0
        }
        // After the fade-out duration, remove the GameObject from the dictionary
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.TRANSITION_INTERVAL + 2.0) {
            self.gameObjectOpacities[id] = nil
        }

        peggleGameEngine.handleObjectRemoval(id: id)
        // }
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

    func handleRetryLevelButton() {
        triggerRefresh()
        self.resetAll()
        // sceneController.transitionToGameScene(with: sceneController.currentLevel ?? peggleGameEngine.currentLevel)
        if let level = sceneController.currentLevel {
            self.peggleGameEngine.currentLevel = level
        }
        self.startGame()
    }

    private func resetAll() {
        self.isPaused = false
        self.isWin = false
        self.isLose = false
        self.peggleGameEngine = GameEngine(geometry: geometryState)
        peggleGameEngine.delegate = self
        self.gameLoop = DisplayLink()
        self.setupGameLoop()
    }

    func transferScores(scores: ScoreBoard, state: Bool) {
        triggerRefresh()
        if scores.currentScore > self.scores.currentScore + Constants.SCORE_COMBO_THRESHOLD {
            self.scores = scores
            self.scores.scoreBonus += Constants.SCORE_COMBO_THRESHOLD
            self.scores.status = "\(Constants.SCORE_COMBO_THRESHOLD) COMBO BONUS!"
        } else {
            self.scores = scores
        }

        if scores.getWinState && state {
            self.scores.status = "YOU WIN!"
            triggerWin()
        }

        if scores.getLoseState && state {
            self.scores.status = "YOU LOSE!"
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

    func triggerWin() {
        self.stopGame()
        self.isWin = true
        AudioManager.shared.stop()
        AudioManager.shared.playWinSoundEffect()
        return
    }

    func getHighScore() -> Int {
        triggerRefresh()
        return scores.currentScore
    }

    func notifyEffect(withId id: UUID) {
        switch self.gameObjects[id]?.gameObjectType {
        case .GoalPeg, .SpookyPeg:
            AudioManager.shared.playHitEffect()
            // case .NormalPeg, .BlockPeg, .StubbornPeg:
            // AudioManager.shared.playBeepEffect()
        case .KaboomPeg:
            AudioManager.shared.playSpecialEffect()
        default:
            break
        }
    }

    func notifySpecialEffect() {
        AudioManager.shared.playSpecialEffect()
    }

    func handleGetCurrentPowerUpImage() -> String {
        switch Constants.UNIVERSAL_POWER_UP {
        case .Kaboom:
            return "KaboomPeg"
        case .Spooky:
            return "SpookyPeg"
        }
    }

    func getObjectAnimation(_ view: GameObjectView) -> Bool {
        view.gameObject.gameObjectType == .KaboomPegActive
    }

    func getObjectScale(_ view: GameObjectView) -> Double {
        view.gameObject.height.twice
    }

}
