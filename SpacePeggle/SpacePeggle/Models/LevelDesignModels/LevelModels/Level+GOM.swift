import SwiftUI

/// Level conformance with the protocol that specifies additional
/// functionality for the Abstract Level.
extension Level: AbstractLevelAdvanced { }

/// This extension adds game object manipulation capabilities to the
/// Level Model. This includes handling gestures of the game objects
/// such as rotation and magnification.
///
/// This is a temporary measure to finalize the gestures before moving
/// them into an equivalent level engine class.
extension Level {
    func handleObjectRotation(id: UUID, value: Angle) {
        Logger.log("New angle is \(value)", self)
        gameObjects[id]?.rotation = value
    }

    func handleObjectMagnification(id: UUID, scale: Double) {
        gameObjects[id]?.scale = scale
    }

    func handleObjectRemoval(id: UUID) {
        gameObjects.removeValue(forKey: id)
    }
}
