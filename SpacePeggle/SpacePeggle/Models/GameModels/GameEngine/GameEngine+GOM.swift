import SwiftUI

/// This extension adds game object manipulation capabilities to the
/// Game engine. This includes handling gestures of the game objects
/// such as rotation and magnification.
///
/// This is a temporary measure to finalize the gestures before moving
/// them into an equivalent level engine class.
extension GameEngine {
    func handleGameObjectRotation(id: UUID, value: Angle) {
        gameObjects[id]?.rotation = value
    }

    func handleGameObjectMagnification(id: UUID, scale: Double) {
        /*if let centerPosition = gameObjects[id]?.centerPosition {
            gameObjects[id]?.centerPosition = centerPosition * scale
        }*/
        gameObjects[id]?.magnification = scale
    }
}
