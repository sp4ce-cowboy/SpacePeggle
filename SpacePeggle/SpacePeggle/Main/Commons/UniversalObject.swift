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

    var rightMostPosition: Vector {
        Vector(x: centerPosition.x + width.half, y: centerPosition.y)
    }

    var leftMostPosition: Vector {
        Vector(x: centerPosition.x - width.half, y: centerPosition.y)
    }

    var topMostPosition: Vector {
        Vector(x: centerPosition.x, y: centerPosition.y - height.half)
    }

    var bottomMostPosition: Vector {
        Vector(x: centerPosition.x, y: centerPosition.y + height.half)
    }

    var sideVectors: [Vector] {
        [rightMostPosition, leftMostPosition, topMostPosition, bottomMostPosition]
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

}

/// This extension adds basic object detection measures to an object
extension UniversalObject {
    func contains(_ vector: Vector) -> Bool {
        let withinXAxis = vector.x >= rightMostPosition.x && vector.x <= leftMostPosition.x
        let withinYAxis = vector.y >= topMostPosition.y && vector.y <= bottomMostPosition.y
        return withinXAxis && withinYAxis
    }
}
