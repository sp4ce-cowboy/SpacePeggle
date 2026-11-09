import SwiftUI

/// A class to model a vector quantity with 2 generic doubles
struct Vector: Equatable {
    var x: Double
    var y: Double

    // Initialize with components
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    /// Initialize with magnitude and angle (in radians)
    init(magnitude: Double, angle: Angle) {
        self.x = magnitude * sin(angle.radians)
        self.y = magnitude * cos(angle.radians)
    }

    init(with point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }

    /// Compute the magnitude of the vector
    var magnitude: Double {
        sqrt(pow(x, 2) + pow(y, 2))
    }

    /// Compute the angle of the vector (in radians)
    var angle: Angle {
        Angle(radians: atan2(y, x))
    }

    /// Local angle is based on the central axis that runs down from
    /// the middle of the screen.
    var angleFromCenterAxis: Angle {
        Angle(degrees: 90) + angle
    }

    var point: CGPoint {
        CGPoint(x: self.x, y: self.y)
    }

    mutating func invert() {
        x.negate()
        y.negate()
    }

}

/// This extension provides static functions to return normalized vectors
extension Vector {
    /// Returns a unit vector in the X direction
    static func unitVectorX() -> Vector {
        Vector(x: 1, y: .zero)
    }

    /// Returns a unit vector in the Y direction
    static func unitVectorY() -> Vector {
        Vector(x: .zero, y: 1)
    }

    /// Returns a unit 2D Vector
    static func unitVector() -> Vector {
        Vector(x: 1, y: 1).normalized()
    }

    /// Returns a zero vector
    static func zeroVector() -> Vector {
        Vector(x: .zero, y: .zero)
    }

    /// Returns a normalized unit Vector
    func normalized() -> Vector {
        self / self.magnitude
    }

    func applyDamping(_ factor: Double) -> Vector {
        self * factor
    }
}

/// This extension to the vector struct allows for vector arithmetic
/// using standard arithmetic operators
extension Vector {
    // Vector addition
    static func + (left: Vector, right: Vector) -> Vector {
        Vector(x: left.x + right.x, y: left.y + right.y)

    }

    // Vector subtraction
    static func - (left: Vector, right: Vector) -> Vector {
        Vector(x: left.x - right.x, y: left.y - right.y)
    }

    // Scalar multiplication
    static func * (_ vector: Vector, _ scalar: Double) -> Vector {
        Vector(x: vector.x * scalar, y: vector.y * scalar)
    }

    // Scalar division
    static func / (_ vector: Vector, _ scalar: Double) -> Vector {
        guard scalar != 0 else {
            return .zeroVector()
        }
        return Vector(x: vector.x / scalar, y: vector.y / scalar)
    }

    // Dot product of two vectors
    static func dot(_ left: Vector, _ right: Vector) -> Double {
        left.x * right.x + left.y * right.y
    }

    // Pseudo-cross product of two vectors (result is a scalar)
    static func cross(_ left: Vector, _ right: Vector) -> Double {
        left.x * right.y - left.y * right.x
    }

}
