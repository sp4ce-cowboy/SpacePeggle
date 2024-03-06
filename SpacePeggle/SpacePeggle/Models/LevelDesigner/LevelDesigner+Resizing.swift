import SwiftUI

/// This extension allows the level designer to handle the drag gesture associated
/// with scaling and rotation of level objects.
extension LevelDesigner {
    func handleObjectResizing(_ value: DragGesture.Value, _ levelObject: any GameObject) {
        let width = levelObject.trueWidth + value.translation.width
        let height = levelObject.trueHeight + value.translation.height

        let newScale = calculateNewScale(width: width, height: height, levelObject)
        handleObjectMagnification(levelObject, scale: newScale.0, isDecreasing: newScale.1)

        let rotationAngle = calculateRotationAngle(from: value, levelObject)
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
        // levelObjects[object.id]?.rotation = value

        if var object = levelObjects[object.id] {
            if !handleBoundaryScalingCollision(object: &object) {
                object.rotation = value
            }
        }
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

        let objectRightMost = object.rightMostPosition.x // objectX + widthX
        let objectLeftMost = object.leftMostPosition.x // objectX - widthX
        let objectTopMost = object.topMostPosition.y // objectY - heightY
        let objectBottomMost = object.bottomMostPosition.y // objectY + heightY

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
            if objectTopMost < screenYStart {
                object.height = heightY.twice
                return true
            }
            if objectBottomMost > screenYEnd {
                object.height = heightY.twice
                return true
            }
        }

        return false
    }

}
