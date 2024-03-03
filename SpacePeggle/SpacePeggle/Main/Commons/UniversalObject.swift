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
        set {
            Logger.log("Scale for \(self.id) updated to \(newValue)")
            shape.scale = newValue
        }
    }

    var rotation: Angle {
        get { Angle(radians: shape.rotation) }
        set {
            Logger.log("Rotation for \(self.id) updated to \(newValue)", self)
            shape.rotation = newValue.radians
        }
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

    var edgeVectors: [Vector] {
        [rightMostPosition, leftMostPosition, topMostPosition, bottomMostPosition]
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
