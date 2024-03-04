import SwiftUI

struct CircularShape: UniversalShape {

    var shapeType: Enums.ShapeType = .circle
    let trueRadius: Double
    var rotation: Double
    var scale: Double

    var trueHeight: Double {
        trueRadius * 2
    }

    var trueWidth: Double {
        trueRadius * 2
    }

    var radius: Double {
        trueRadius * scale
    }

    init(diameter: Double = Constants.UNIVERSAL_LENGTH,
         rotation: Double = 0.0,
         scale: Double = 1.0) {
        self.trueRadius = diameter / 2
        self.rotation = rotation
        self.scale = scale
    }

    // Function to calculate the corners of the object
    // For circular objects, this is simply the
    func corners(centerPosition: Vector) -> [Vector] {
        let halfWidth = width / 2
        let halfHeight = height / 2
        let corners = [
            Vector(x: 0, y: -halfHeight),    // Top
            Vector(x: halfWidth, y: 0),      // Right
            Vector(x: -halfWidth, y: 0),     // Left
            Vector(x: 0, y: halfHeight)      // Bottom
        ]

        return corners.map { corner in
            Vector(x: corner.x + centerPosition.x, y: corner.y + centerPosition.y)
        }
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

        // Step 1: Translate the system to the rectangle's center
        let translatedCircleCenter = Vector(x: thisPosition.x - otherPosition.x,
                                            y: thisPosition.y - otherPosition.y)

        // Step 2: Rotate the circle's center by the negative of the rectangle's rotation angle
        let rotatedCircleX = translatedCircleCenter.x * cos(-rectangle.rotation)
        - translatedCircleCenter.y * sin(-rectangle.rotation)

        let rotatedCircleY = translatedCircleCenter.x * sin(-rectangle.rotation)
        + translatedCircleCenter.y * cos(-rectangle.rotation)

        let rotatedCircleCenter = Vector(x: rotatedCircleX, y: rotatedCircleY)

        // Calculate axis-aligned rectangle's edge positions relative to its center
        let leftMostX = -rectangle.width / 2
        let rightMostX = rectangle.width / 2
        let topMostY = -rectangle.height / 2
        let bottomMostY = rectangle.height / 2

        // Step 3: Check for overlap with the axis-aligned rectangle
        let closestX = max(leftMostX, min(rotatedCircleCenter.x, rightMostX))
        let closestY = max(topMostY, min(rotatedCircleCenter.y, bottomMostY))

        let distanceX = rotatedCircleCenter.x - closestX
        let distanceY = rotatedCircleCenter.y - closestY
        let distance = sqrt(distanceX * distanceX + distanceY * distanceY)

        if distance < self.radius {
            Logger.log("Overlap is \(self.radius - distance)", self)
            return self.radius - distance
        }

        return nil
    }
}
