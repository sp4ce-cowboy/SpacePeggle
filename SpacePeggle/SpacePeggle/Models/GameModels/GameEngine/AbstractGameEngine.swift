import Foundation
import SwiftUI

/// The `AbstractGameEngine` is the point of interface between the Renderer
/// and any concrere implementations of a Game Engine.
///
/// This way, the Renderer (View or ViewM/C/P) is not reliant on any specific Game
/// Engine. A common interface acts as a contract between the Renderer and the Game
/// Engine, effectively decoupling the Renderer from any concrete Game Engine class.
///
/// Also see `AbstractPhysicsEngine`
protocol AbstractGameEngine {
    var delegate: GameEngineDelegate? { get set }

    var launcher: Launcher { get set }
    var isBallLaunched: Bool { get set }
    var currentBallPosition: Vector { get }

    var currentLevel: any AbstractLevel { get }
    var gameObjects: [UUID: any GameObject] { get }
    var isGameActive: Bool { get set }

    mutating func startGame()
    func stopGame()
    func updateGame(timeStep: TimeInterval)
    func loadLevel(with level: AbstractLevel)
    func handleGameObjectRemoval(id: UUID)

    func updateLauncherRotation(with dragValue: DragGesture.Value, for size: CGSize)
    func launchBall()

}