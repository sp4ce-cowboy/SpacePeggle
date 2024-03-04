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
        let translatedCircleCenter = Vector(x: thisPosition.x - otherPosition.x, y: thisPosition.y - otherPosition.y)

        // Step 2: Rotate the circle's center by the negative of the rectangle's rotation angle
        let rotatedCircleX = translatedCircleCenter.x * cos(-rectangle.rotation)
        - translatedCircleCenter.y * sin(-rectangle.rotation)

        let rotatedCircleY = translatedCircleCenter.x * sin(-rectangle.rotation)
        + translatedCircleCenter.y * cos(-rectangle.rotation)

        let rotatedCircleCenter = Vector(x: rotatedCircleX, y: rotatedCircleY)

        // Calculate axis-aligned rectangle's edge positions relative to its center (now at the origin)
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

    func intersectss(withRectangle rectangle: RectangularShape,
                     at thisPosition: Vector,
                     and otherPosition: Vector) -> Double? {

        // Calculate the rectangle's edge positions based on its center, width, and height
        let leftMostPosition = Vector(x: otherPosition.x - rectangle.width / 2, y: otherPosition.y)
        let rightMostPosition = Vector(x: otherPosition.x + rectangle.width / 2, y: otherPosition.y)
        let topMostPosition = Vector(x: otherPosition.x, y: otherPosition.y - rectangle.height / 2)
        let bottomMostPosition = Vector(x: otherPosition.x, y: otherPosition.y + rectangle.height / 2)

        // Find the closest point on the rectangle to the circle's center by
        // clamping the circle's center coordinates to the edge of the rectangle
        let closestX = max(leftMostPosition.x, min(thisPosition.x, rightMostPosition.x))
        let closestY = max(topMostPosition.y, min(thisPosition.y, bottomMostPosition.y))

        // Calculate the distance from the circle's center to the closest point on the rectangle
        let deltaX = thisPosition.x - closestX
        let deltaY = thisPosition.y - closestY
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)

        // Check for collision
        if distance < self.radius {
            Logger.log("Overlap is \(self.radius - distance)", self)
            return self.radius - distance
        }

        return nil
    }

    // Find the closest point on the rectangle to the circle's center
    /*var topRightCorner: Vector {
     let x: Double = width / 2
     let y: Double = -height / 2
     return Vector(x: otherPosition.x + (x * cos(rotation) - y * sin(rotation)),
     y: otherPosition.y + (x * sin(rotation) + y * cos(rotation)))
     }
     
     var bottomRightCorner: Vector {
     let x: Double = width / 2
     let y: Double = height / 2
     let adjustedWidth = (x * cos(rotation) - y * sin(rotation))
     let adjustedHeight = (x * sin(rotation) + y * cos(rotation))
     return Vector(x: otherPosition.x + adjustedWidth,
     y: otherPosition.y + adjustedHeight)
     }
     
     var topLeftCorner: Vector {
     let x: Double = -width / 2
     let y: Double = height / 2
     return Vector(x: otherPosition.x + (x * cos(rotation) - y * sin(rotation)),
     y: otherPosition.y + (x * sin(rotation) + y * cos(rotation)))
     }
     
     var bottomLeftCorner: Vector {
     let x: Double = -width / 2
     let y: Double = -height / 2
     return Vector(x: otherPosition.x + (x * cos(rotation) - y * sin(rotation)),
     y: otherPosition.y + (x * sin(rotation) + y * cos(rotation)))
     }
     
     /* let deltaX = max(leftMostPosition.x - thisPosition.x,
      0, thisPosition.x - rightMostPosition.x)
      let deltaY = max(topMostPosition.y - thisPosition.y,
      0, thisPosition.y - bottomMostPosition.y)
      */
     
     let deltaX = max(leftMostCorner.x - thisPosition.x,
     0, thisPosition.x - rightMostPosition.x)
     let deltaY = max(topMostPosition.y - thisPosition.y,
     0, thisPosition.y - bottomMostPosition.y)
     
     // Calculate the distance from the circle's center to the closest point
     let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
     
     // Check for collision
     if distance < self.radius {
     Logger.log("Overlap is \(self.radius - distance)", self)
     return self.radius - distance
     }
     
     return nil
     }*/
}
