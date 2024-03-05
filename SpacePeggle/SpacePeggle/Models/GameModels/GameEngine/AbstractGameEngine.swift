import Foundation
import SwiftUI

/// Allows the physics engine to communicate with the game engine via a
/// delegate without knowing about the game engine is, allowing for game
/// objects to be "activated" without violating the physics-game layer.
protocol PhysicsEngineDelegate: AnyObject {
    func handleCollision(withID id: UUID)
}

/// The `AbstractGameEngine` is the point of interface between the Renderer
/// and any concrere implementations of a Game Engine.
///
/// This way, the Renderer (View or ViewM/C/P) is not reliant on any specific Game
/// Engine. A common interface acts as a contract between the Renderer and the Game
/// Engine, effectively decoupling the Renderer from any concrete Game Engine class.
///
/// Also see `AbstractPhysicsEngine`
protocol AbstractGameEngine: PhysicsEngineDelegate, GameMechanic {
    var delegate: GameEngineDelegate? { get set }

    var currentLevel: any AbstractLevel { get set }
    var gameObjects: [UUID: any GameObject] { get }
    var isGameActive: Bool { get set }

    func startGame(with level: AbstractLevel)
    func stopGame()
    func updateGame(timeStep: TimeInterval)
    func handleGameObjectRemoval(id: UUID)
    func handleObjectRemoval(id: UUID)

    func updateLauncherRotation(with dragValue: DragGesture.Value, for size: CGSize)
    func launchBall()
}

protocol GameMechanic {
    var scores: ScoreBoard { get set }
    var launcher: Launcher { get set }
    var isBallLaunched: Bool { get set }
    var currentBallPosition: Vector { get }
    var currentBallShape: UniversalShape { get }
    var bucket: Bucket { get set }
}
