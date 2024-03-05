import SwiftUI

/// See {@code PhysicsEngine.swift}. Externally imposed conformance
/// allows `GameEngine` to be its own standalone GameEngine, and if
/// a Renderer requires a GameImplementation type specifically, and
/// then this extension space can be used to configure GameEngine to
/// conform to GameImplementation.
///
/// Also see `PhysicsEngine`
extension GameEngine: AbstractGameEngine {

    /// As an example:
    /// ```
    ///    func updateGame(timeSte: TimeInterval) {
    ///        // Insert GameImplementation Specific Logic
    ///    }
    /// ```
    /// This function would allow this Game Engine to conform to
    /// invocations requiring an `AbstractGameEngine` type.
}

/// The concrete Game Engine Model.
///
/// Handles all game logic. Conforms by extension to the AbstractGameEngine
/// protocol, allowing it to function as a Game Engine for different games,
/// including Peggle.
///
/// Making the `Game Engine` final prevents any sub-classing and overriding
/// of core game elements that are needed to work together. To apply different
/// sets of game logic, a new `AbstractGameEngine` sub-type must be created.
final class GameEngine {
    weak var delegate: GameEngineDelegate?
    var physicsEngine: AbstractPhysicsEngine
    var currentScreenGeometry: GeometryProxy

    var currentLevel: AbstractLevel = LevelStub().getLevelStub()
    var isGameActive = false

    var launcher: Launcher  // Can be swapped for a [UUID : Launcher] map if needed
    @Published var ball: Ball          // Can be swapped for a [UUID : Ball] map if needed
    var isBallLaunched = false // Can be swapped for a [UUID : Bool] if needed

    var velocityCheckTimer: Timer?
    var timeBelowThreshold: TimeInterval = 0
    let checkInterval: TimeInterval = 0.5
    var ballIsStuck = false

    var physicsObjects: [UUID: any PhysicsObject] {
        get { physicsEngine.physicsObjects }
        set { physicsEngine.physicsObjects = newValue }
    }

    var gameObjects: [UUID: any GameObject] {
        get { currentLevel.gameObjects }
        set { currentLevel.gameObjects = newValue }
    }

    init(geometry: GeometryProxy) {
        Logger.log("Game Engine is initialized")
        self.launcher = Launcher(layoutSize: geometry.size)
        self.ball = Ball()
        self.currentScreenGeometry = geometry
        self.physicsEngine = PhysicsEngine(
            domain: Constants.getFullScreen(from: geometry))
        self.physicsEngine.delegate = self
    }

    deinit {
        Logger.log("Game Engine is deinitialized.")
    }

}
