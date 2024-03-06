import SwiftUI

struct RectangularShape: UniversalShape {

    var shapeType: Enums.ShapeType = .rectangle
    let trueHeight: Double
    let trueWidth: Double
    var rotation: Double
    var scale: Double

    init(height: Double, width: Double, rotation: Double = 0.0, scale: Double = 1.0) {
        self.trueHeight = height
        self.trueWidth = width
        self.rotation = rotation
        self.scale = scale
    }

    func corners(centerPosition: Vector) -> [Vector] {
        let halfWidth = width / 2
        let halfHeight = height / 2
        let corners = [
            Vector(x: -halfWidth, y: -halfHeight),  // Top-left
            Vector(x: halfWidth, y: -halfHeight),   // Top-right
            Vector(x: halfWidth, y: halfHeight),    // Bottom-right
            Vector(x: -halfWidth, y: halfHeight)    // Bottom-left
        ]

        return corners.map { corner in
            // Rotate corner around the origin (0, 0) then translate it
            let rotatedX = corner.x * cos(rotation) - corner.y * sin(rotation)
            let rotatedY = corner.x * sin(rotation) + corner.y * cos(rotation)
            return Vector(x: rotatedX + centerPosition.x, y: rotatedY + centerPosition.y)
        }
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

        circle.intersects(withRectangle: self, at: otherPosition, and: thisPosition)
    }
}

extension RectangularShape {

    /// APPROXIMATE METHOD
    func intersects(withRectangle rectangle: RectangularShape,
                    at thisPosition: Vector,
                    and otherPosition: Vector) -> Double? {

        // Calculate corners of this rectangle
        let thisCorners = self.corners(centerPosition: thisPosition)

        // Calculate corners of the other rectangle
        let otherCorners = rectangle.corners(centerPosition: otherPosition)

        // Check if any corner of this rectangle is inside the other rectangle
        for corner in thisCorners {
            if let distance = rectangle.contains(point: corner, at: otherPosition) {
                Logger.log("Collision detected: first rectangle inside the second.", self)
                return distance
            }
        }

        // Check if any corner of the other rectangle is inside this rectangle
        for corner in otherCorners {
            if let distance = self.contains(point: corner, at: thisPosition) {
                Logger.log("Collision detected: second rectangle inside the first", self)
                return distance
            }
        }

        // No collision detected
        return nil
    }

    // Helper method to check if a point is inside this rectangle, considering rotation
    func contains(point: Vector, at centerPosition: Vector) -> Double? {

        // Translate the point to the rectangle's coordinate system (center as origin)
        let translatedPointX = point.x - centerPosition.x
        let translatedPointY = point.y - centerPosition.y

        // Rotate the point by the negative of the rectangle's rotation to align the rectangle axis
        let rotatedPointX = translatedPointX * cos(-rotation) - translatedPointY * sin(-rotation)
        let rotatedPointY = translatedPointX * sin(-rotation) + translatedPointY * cos(-rotation)

        // Check if the rotated point is within the bounds of the rectangle
        let halfWidth = width / 2
        let halfHeight = height / 2

        let inside = rotatedPointX >= -halfWidth && rotatedPointX <= halfWidth &&
        rotatedPointY >= -halfHeight && rotatedPointY <= halfHeight

        if inside {
            // For an inside point, calculate a "overlap" as the min distance to an edge
            let distToLeft = rotatedPointX + halfWidth
            let distToRight = halfWidth - rotatedPointX
            let distToTop = rotatedPointY + halfHeight
            let distToBottom = halfHeight - rotatedPointY
            let minDistToEdge = min(distToLeft, distToRight, distToTop, distToBottom)
            Logger.log("Contains method: IF INSIDE entered with \(-minDistToEdge)", self)
            return minDistToEdge
        }

        return nil
    }
}
