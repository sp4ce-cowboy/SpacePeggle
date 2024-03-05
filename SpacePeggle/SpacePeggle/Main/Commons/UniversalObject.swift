import SwiftUI
import Foundation

/// The UniversalObject protocol contains an identifier, and
/// a UniversalShape.
protocol UniversalObject: Identifiable {
    var id: UUID { get set }
    var centerPosition: Vector { get set }
    var shape: any UniversalShape { get set }
}

/// This extension adds computed properties that provide quicker access to the
/// properties of the UniversalObject's shape
extension UniversalObject {
    var trueWidth: Double { shape.trueWidth }
    var trueHeight: Double { shape.trueHeight }

    var height: Double {
        get { shape.height }
        set { shape.height = newValue }
    }

    var width: Double {
        get { shape.width }
        set { shape.width = newValue }
    }

    var scale: Double {
        get { shape.scale }
        set { shape.scale = newValue }
    }

    var rotation: Angle {
        get { Angle(radians: shape.rotation) }
        set { shape.rotation = newValue.radians }
    }

    var rotationRadians: Double {
        get { shape.rotation }
        set { shape.rotation = newValue }
    }

    var rotationDegrees: Double {
        get { shape.rotation }
        set { shape.rotation = Angle(degrees: newValue).radians }
    }
}

/// This extension adds even more computed properties to simplify arthimetic operations
/// on objects.
extension UniversalObject {

    var sideVectors: [Vector] {
        [rightCenter, leftCenter, topCenter, bottomCenter]
    }

    var rightCenter: Vector {
        Vector(x: centerPosition.x + width.half, y: centerPosition.y)
    }

    var leftCenter: Vector {
        Vector(x: centerPosition.x - width.half, y: centerPosition.y)
    }

    var topCenter: Vector {
        Vector(x: centerPosition.x, y: centerPosition.y - height.half)
    }

    var bottomCenter: Vector {
        Vector(x: centerPosition.x, y: centerPosition.y + height.half)
    }

    var topRightCorner: Vector {
        let x: Double = width / 2
        let y: Double = height / 2
        return Vector(x: centerPosition.x + (x * cos(rotationRadians) - y * sin(rotationRadians)),
                      y: centerPosition.y + (x * sin(rotationRadians) + y * cos(rotationRadians)))
    }

    var bottomRightCorner: Vector {
        let x: Double = width / 2
        let y: Double = height / 2
        let adjustedWidth = (x * cos(rotationRadians) - y * sin(rotationRadians))
        let adjustedHeight = (x * sin(rotationRadians) + y * cos(rotationRadians))
        return Vector(x: centerPosition.x + adjustedWidth,
                      y: centerPosition.y + adjustedHeight)
    }

    var topLeftCorner: Vector {
        let x: Double = -width / 2
        let y: Double = height / 2
        return Vector(x: centerPosition.x + (x * cos(rotationRadians) - y * sin(rotationRadians)),
                      y: centerPosition.y + (x * sin(rotationRadians) + y * cos(rotationRadians)))
    }

    var bottomLeftCorner: Vector {
        let x: Double = -width / 2
        let y: Double = -height / 2
        return Vector(x: centerPosition.x + (x * cos(rotationRadians) - y * sin(rotationRadians)),
                      y: centerPosition.y + (x * sin(rotationRadians) + y * cos(rotationRadians)))
    }

    var edgeVectors: [Vector] {
        [topRightCorner, bottomRightCorner, topLeftCorner, bottomLeftCorner]
    }

    // Function to find the right-most position of the object
    var rightMostPosition: Vector {
        let corners = shape.corners(centerPosition: centerPosition)
        // Find the corner with the largest x-value
        if let rightMost = corners.max(by: { $0.x < $1.x }) {
            return rightMost
        } else {
            return centerPosition
        }
    }

    var leftMostPosition: Vector {
        let corners = shape.corners(centerPosition: centerPosition)
        if let leftMost = corners.min(by: { $0.x < $1.x }) {
            return leftMost
        } else {
            return centerPosition // Fallback
        }
    }

    // Function to find the bottom-most position of object
    var bottomMostPosition: Vector {
        let corners = shape.corners(centerPosition: centerPosition)
        if let bottomMost = corners.max(by: { $0.y < $1.y }) {
            return bottomMost
        } else {
            return centerPosition // Fallback
        }
    }

    // Function to find the top-most position of object
    var topMostPosition: Vector {
        let corners = shape.corners(centerPosition: centerPosition)
        if let topMost = corners.min(by: { $0.y < $1.y }) {
            return topMost
        } else {
            return centerPosition // Fallback
        }
    }

}

/// This extension adds basic object detection measures to an object
extension UniversalObject {
    func contains(_ vector: Vector) -> Bool {
        let withinXAxis = vector.x >= rightCenter.x && vector.x <= leftCenter.x
        let withinYAxis = vector.y >= topCenter.y && vector.y <= bottomCenter.y
        return withinXAxis && withinYAxis
    }

    func containsObject(_ object: any UniversalObject) -> Bool {
        let withinXAxis = object.rightMostPosition.x <= rightMostPosition.x
        && object.leftMostPosition.x >= rightMostPosition.x

        let withinYAxis = object.topMostPosition.y >= topMostPosition.y
        && object.bottomMostPosition.y <= bottomMostPosition.y
        return withinXAxis && withinYAxis
    }
}
