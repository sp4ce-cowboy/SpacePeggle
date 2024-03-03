import Foundation
import SwiftUI

extension LevelDesigner: AbstractLevelDesigner { }

protocol AbstractLevelDesigner {
    var levelObjects: [UUID: any GameObject] { get set }
    var domain: CGRect { get set }

    func handleObjectResizing(_ value: DragGesture.Value, _ levelObject: any GameObject)
    func handleObjectAddition(_ object: any GameObject)
    func handleObjectRemoval(_ object: any GameObject)
    func updateObjectPosition(_ gameObject: any GameObject, with position: Vector)
    func handleObjectMovement(_ object: any GameObject, with drag: DragGesture.Value)
}

/// The level designer class encapsulates a Level and exposes certain methods
/// required for level manipulation
class LevelDesigner {

    var currentLevel: AbstractLevel
    var domain: CGRect = Constants.getDefaultFullScreen()
    var levelName: String { currentLevel.name }
    var levelObjects: [UUID: any GameObject] {
        get { currentLevel.gameObjects }
        set { currentLevel.updateLevel(newValue) }
    }

    init(currentLevel: AbstractLevel = LevelDesigner.getEmptyLevel(),
         domain: CGRect = Constants.getDefaultFullScreen()) {
        defer { Logger.log("LevelDesigner is initialized with \(levelName)", self) }

        self.currentLevel = currentLevel
        self.domain = domain
    }

    deinit {
        Logger.log("Level Designer is deinitialized with \(levelName)", self)
    }

    /// Returns an empty level
    static func getEmptyLevel() -> Level {
        Level(name: "LevelName", gameObjects: [:])
    }
}

/// This extension allows the LevelDesigner to handle tap gestures for
/// object creation.
extension LevelDesigner {
    func handleObjectAddition(_ object: any GameObject) {
        guard isValidPosition(object) && !isOverlapping(object) else {
            return
        }
        currentLevel.storeGameObject(object)
        Logger.log("GameObject \(object.gameObjectType) stored at \(object.centerPosition)", self)
    }

    private func isValidPosition(_ object: any GameObject) -> Bool {
        domain.containsAllVectors(object.edgeVectors)
    }

    private func isOverlapping(_ object: any GameObject) -> Bool {
        levelObjects.values
            .filter { $0.id != object.id }
            .contains { $0.overlap(with: object) != nil }
    }
}

/// This extension allows the level designer to handle the drag gesture associated
/// with scaling and rotation of level objects.
extension LevelDesigner {
    func handleObjectResizing(_ value: DragGesture.Value, _ levelObject: any GameObject) {
        let width = levelObject.trueWidth + value.translation.width
        let height = levelObject.trueHeight + value.translation.height

        let newScale = calculateNewScale(width: width, height: height, levelObject)
        Logger.log("New scale is \(newScale)", self)
        handleObjectMagnification(levelObject, scale: newScale.0, isDecreasing: newScale.1)

        let rotationAngle = calculateRotationAngle(from: value, levelObject)
        Logger.log("Rotation angle is \(rotationAngle)", self)
        updateObjectRotation(levelObject, value: rotationAngle)
    }

    private func calculateNewScale(width: CGFloat, height: CGFloat, _ levelObject: any GameObject) -> (Double, Bool) {
        let originalDiagonal = sqrt(pow(levelObject.trueHeight, 2) + pow(levelObject.trueWidth, 2))
        let newDiagonal = sqrt(pow(width, 2) + pow(height, 2))
        let finalScale = min(max(newDiagonal / originalDiagonal, 1.0), 4.0)
        let isDecreasing = finalScale <= levelObject.scale
        return (finalScale, isDecreasing)
    }

    private func calculateRotationAngle(from value: DragGesture.Value, _ levelObject: any GameObject) -> Angle {
        let center = levelObject.centerPosition
        let startAngle = atan2(value.startLocation.y - center.y, value.startLocation.x - center.x)
        let currentAngle = atan2(value.location.y - center.y, value.location.x - center.x)
        let angleDifference = currentAngle - startAngle
        return Angle(radians: Double(angleDifference))
    }
}

/// This extension allows the LevelDesigner to handle resizing and rotating of level objects.
extension LevelDesigner {
    func updateObjectRotation(_ object: any GameObject, value: Angle) {
        levelObjects[object.id]?.rotation = value
    }

    func handleObjectMagnification(_ object: any GameObject, scale: Double, isDecreasing: Bool) {
        var isOverlap = false
        for gameObject in levelObjects.values where object.id != gameObject.id {
            if let distance = object.overlap(with: gameObject) {
                isOverlap = true
                let correctedScale = object.scale - (distance * 0.001)
                updateObjectScale(object, scale: correctedScale, isDecreasing: isDecreasing)
                break
            }
        }

        if !isOverlap || isDecreasing {
            updateObjectScale(object, scale: scale, isDecreasing: isDecreasing)
        }
    }

    func updateObjectScale(_ object: any GameObject, scale: Double, isDecreasing: Bool) {
        if var object = levelObjects[object.id] {
            if !handleBoundaryScalingCollision(object: &object) || isDecreasing {
                object.scale = scale
            }
        }
    }

    /// Modifies a gameObject's scale in place
    private func handleBoundaryScalingCollision(object: inout any GameObject) -> Bool {
        let objectX = object.centerPosition.x
        let objectY = object.centerPosition.y

        let widthX = object.width.half
        let heightY = object.height.half

        let objectRightMost = objectX + widthX
        let objectLeftMost = objectX - widthX
        let objectTopMost = objectY - heightY
        let objectBottomMost = objectY + heightY

        let screenBounds = domain.size

        let screenXStart = domain.origin.x
        let screenYStart = domain.origin.y
        let screenXEnd = screenBounds.width + screenXStart
        let screenYEnd = screenBounds.height + screenYStart

        // Check for left or right boundary collision
        if objectLeftMost < screenXStart || objectRightMost > screenXEnd {
            if objectLeftMost < screenXStart {
                object.width = widthX.twice
                return true
            }
            if objectRightMost > screenXEnd {
                object.width = widthX.twice
                return true
            }
        }

        // Check for top or bottom collision
        if objectTopMost < screenYStart || objectBottomMost > screenYEnd {
            if objectY < screenYStart {
                object.height = heightY.twice
                return true
            }
            if objectY > screenYEnd {
                object.height = heightY.twice
                return true
            }
        }

        return false
    }

}

/// This extension allows the LevelDesigner to handle the movement of level objects
/// around the level board.
extension LevelDesigner {
    func updateObjectPosition(_ object: any GameObject, with position: Vector) {
        guard var object = levelObjects[object.id] else {
            return
        }

        object.centerPosition = position
        handleBoundaryMovementCollision(object: &object)
    }

    func handleObjectRemoval(_ object: any GameObject) {
        levelObjects.removeValue(forKey: object.id)
    }

    func handleObjectMovement(_ object: any GameObject, with drag: DragGesture.Value) {
        let stopLocation = drag.location
        var isMovingAway = false
        Logger.log("Drag gesture triggered with location \(stopLocation)", self)

        var isOverlap = false
        for gameObject in levelObjects.values where object.id != gameObject.id {
            if let distance = object.overlap(with: gameObject) {
                isOverlap = true
                let normalVector = (object.centerPosition - gameObject.centerPosition).normalized
                let correction = normalVector * (distance + 0.0000000001)
                let correctedPosition = object.centerPosition + correction
                updateObjectPosition(object, with: correctedPosition)

                let dragVector = Vector(with: stopLocation) - object.centerPosition
                let dotProduct = Vector.dot(normalVector, dragVector)
                isMovingAway = dotProduct > 0
                break
            }
        }

        if !isOverlap || isMovingAway {
            Logger.log("Moving object while boolean is: \(isOverlap)", self)
            updateObjectPosition(object, with: Vector(with: stopLocation))
        }
    }

    /// Modifies a gameObject's centerposition in place
    private func handleBoundaryMovementCollision(object: inout any GameObject) {
        let objectX = object.centerPosition.x
        let objectY = object.centerPosition.y
        let widthX = object.width.half
        let heightY = object.height.half

        let screenBounds = domain.size
        let screenXStart = domain.origin.x
        let screenYStart = domain.origin.y
        let screenXEnd = screenBounds.width + screenXStart
        let screenYEnd = screenBounds.height + screenYStart

        // Check for left or right boundary collision
        if objectX < (screenXStart + widthX) || objectX > (screenXEnd - widthX) {
            if objectX < (screenXStart + widthX) {
                object.centerPosition.x = (screenXStart + widthX)
            }
            if objectX > (screenXEnd - widthX) {
                object.centerPosition.x = (screenXEnd - widthX)
            }
        }

        // Check for top or bottom collision
        if objectY < (screenYStart + heightY) || objectY > (screenYEnd - heightY) {
            if objectY < (screenYStart + heightY) {
                object.centerPosition.y = (screenYStart + heightY)
            }
            if objectY > (screenYEnd - heightY) {
                object.centerPosition.y = (screenYEnd - heightY)
            }
        }
    }
}
