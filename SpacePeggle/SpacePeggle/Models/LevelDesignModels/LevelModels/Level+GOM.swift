import SwiftUI

/// Level conformance with the protocol that specifies additional
/// functionality for the Abstract Level.
extension Level: AbstractLevelAdvanced {

}

/// This extension adds game object manipulation capabilities to the
/// Level Model. This includes handling gestures of the game objects
/// such as rotation and magnification.
///
/// This is a temporary measure to finalize the gestures before moving
/// them into an equivalent level engine class.
extension Level {
    func handleObjectRotation(id: UUID, value: Angle) {
        gameObjects[id]?.rotation = value
    }

    func handleObjectMagnification(id: UUID, scale: Double) {
        gameObjects[id]?.scale = scale
    }

    func handleObjectRemoval(id: UUID) {
        gameObjects.removeValue(forKey: id)
    }

    func handleObjectMovement(_ object: any GameObject, with drag: DragGesture.Value) {

        let stopLocation = drag.location

        Logger.log("Drag gesture triggered with location \(stopLocation)", self)

        var isOverlap = false
        for gameObject in gameObjects.values where object.id != gameObject.id {
            if let distance = object.overlap(with: gameObject) {
                let normalVector = (object.centerPosition - gameObject.centerPosition).normalized
                let correction = normalVector * (distance + 0.000000001)
                let correctedPosition = object.centerPosition + correction
                updateObjectPosition(object, with: correctedPosition)
                Logger.log("Overlapping", self)
                isOverlap = true
                break
            }
        }

        if !isOverlap {
            Logger.log("Moving object while boolean is: \(isOverlap)", self)
            updateObjectPosition(object, with: Vector(with: stopLocation))
        }
    }

}
