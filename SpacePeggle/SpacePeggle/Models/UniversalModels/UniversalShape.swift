import SwiftUI

/// The UnivershalShape contains basic information about a given object's
/// contained shape. The height and width of the shape refers to the
protocol UniversalShape {
    var shapeType: String { get }
    var trueHeight: Double { get }
    var trueWidth: Double { get }

    var rotation: Double { get set }
    var scale: Double { get set }

    func intersects(with shape: UniversalShape,
                    at position: Vector,
                    and otherPosition: Vector) -> Double?

    func intersects(withCircle circle: CircularShape,
                    at thisPosition: Vector,
                    and otherPosition: Vector) -> Double?

    func intersects(withRectangle rectangle: RectangularShape,
                    at thisPosition: Vector,
                    and otherPosition: Vector) -> Double?
}

extension UniversalShape {
    var height: Double { trueHeight * scale }
    var width: Double { trueWidth * scale }
}
