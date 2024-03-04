import SwiftUI

/// The UnivershalShape contains basic information about a given object's
/// contained shape. The height and width of the shape refers to the
protocol UniversalShape {
    var shapeType: Enums.ShapeType { get }
    var trueHeight: Double { get }
    var trueWidth: Double { get }

    var rotation: Double { get set }
    var scale: Double { get set }

    func intersects(with shape: any UniversalShape,
                    at position: Vector,
                    and otherPosition: Vector) -> Double?

    func intersects(withCircle circle: CircularShape,
                    at thisPosition: Vector,
                    and otherPosition: Vector) -> Double?

    func intersects(withRectangle rectangle: RectangularShape,
                    at thisPosition: Vector,
                    and otherPosition: Vector) -> Double?

    func corners(centerPosition: Vector) -> [Vector]
}

extension UniversalShape {
    var height: Double {
        get { trueHeight * scale }
        set { scale = newValue / trueHeight }
    }

    var width: Double {
        get { trueWidth * scale }
        set { scale = newValue / trueWidth }
    }

}
