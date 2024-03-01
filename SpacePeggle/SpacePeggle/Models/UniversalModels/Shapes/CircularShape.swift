import SwiftUI

class CircularShape: UniversalShape {

    var shapeType: String = Constants.ShapeType.circle.rawValue
    var radius: Double
    var rotation: Double
    var scale: Double

    var height: Double {
        get { radius }
        set { radius = newValue }
    }

    var width: Double {
        get { radius }
        set { radius = newValue }
    }

    init(radius: Double = Constants.UNIVERSAL_LENGTH,
         rotation: Double = 0.0,
         scale: Double = 1.0) {
        self.radius = radius
        self.rotation = rotation
        self.scale = scale
    }

}

extension CircularShape {

    func intersects(with shape: UniversalShape,
                    at thisPosition: Vector,
                    and otherPosition: Vector) -> Double? {

        shape.intersects(withCircle: self, at: thisPosition, and: otherPosition)
    }
}

extension CircularShape {

    func intersects(withCircle circle: CircularShape,
                    at thisPosition: Vector,
                    and otherPosition: Vector) -> Double? {

        let distance = (thisPosition - otherPosition).magnitude
        let totalRadius = self.radius + circle.radius

        if distance < totalRadius {
            Logger.log("Overlap is \((totalRadius - distance) / 2.0)", self)
            return (totalRadius - distance) / 2.0
        }

        return nil
    }
}

extension CircularShape {
    func intersects(withRectangle rectangle: RectangularShape,
                    at thisPosition: Vector,
                    and otherPosition: Vector) -> Double? {
        nil
    }
}
