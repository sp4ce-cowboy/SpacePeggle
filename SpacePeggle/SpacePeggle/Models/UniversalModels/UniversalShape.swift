import SwiftUI

/// The UnivershalShape contains basic information about a given
/// object
protocol UniversalShape {
    var shapeType: String { get set }
    var height: Double { get set }
    var width: Double { get set }

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
