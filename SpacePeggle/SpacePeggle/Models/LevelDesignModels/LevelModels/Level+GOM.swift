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
    func handleObjectRotation(_ object: any GameObject, value: Angle) {
        gameObjects[object.id]?.rotation = value
    }

    func handleObjectMagnification(_ object: any GameObject, scale: Double) {
        var isOverlap = false
        for gameObject in gameObjects.values where object.id != gameObject.id {
            if let distance = object.overlap(with: gameObject) {
                isOverlap = true
                let correctedScale = object.scale - (distance * 0.001)
                gameObjects[object.id]?.scale = correctedScale
                Logger.log("Overlapping while scaling with \(correctedScale)", self)
                break
            }
        }

        if !isOverlap {
            gameObjects[object.id]?.scale = scale
        }
    }

    func handleObjectRemoval(_ object: any GameObject) {
        gameObjects.removeValue(forKey: object.id)
    }

    func handleObjectMovement(_ object: any GameObject, with drag: DragGesture.Value) {

        let stopLocation = drag.location

        Logger.log("Drag gesture triggered with location \(stopLocation)", self)

        var isOverlap = false
        for gameObject in gameObjects.values where object.id != gameObject.id {
            if let distance = object.overlap(with: gameObject) {
                isOverlap = true
                let normalVector = (object.centerPosition - gameObject.centerPosition).normalized
                let correction = normalVector * (distance + 0.0000000001)
                let correctedPosition = object.centerPosition + correction
                updateObjectPosition(object, with: correctedPosition)
                Logger.log("Overlapping while moving", self)
                break
            }
        }

        if !isOverlap {
            Logger.log("Moving object while boolean is: \(isOverlap)", self)
            updateObjectPosition(object, with: Vector(with: stopLocation))
        }
    }

}
