import SwiftUI

class RectangularShape: NSObject, UniversalShape {

    var shapeType: String = Constants.ShapeType.rectangle.rawValue

    var height: Double

    var width: Double

    var rotation: Double

    var scale: Double

    init(height: Double, width: Double, rotation: Double, scale: Double) {
        self.height = height
        self.width = width
        self.rotation = rotation
        self.scale = scale
    }

}

extension RectangularShape {
    func intersects(with shape: UniversalShape,
                    at thisPosition: Vector,
                    and otherPosition: Vector) -> Double? {
        shape.intersects(withRectangle: self, at: thisPosition,
                         and: otherPosition)
    }
}

extension RectangularShape {

    func intersects(withCircle circle: CircularShape,
                    at thisPosition: Vector,
                    and otherPosition: Vector) -> Double? {

        nil
    }
}

extension RectangularShape {
    func intersects(withRectangle rectangle: RectangularShape,
                    at thisPosition: Vector,
                    and otherPosition: Vector) -> Double? {
        nil
    }
}
