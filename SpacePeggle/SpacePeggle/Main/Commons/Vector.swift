import SwiftUI
import Foundation

/// A class to model a vector quantity with 2 generic doubles
struct Vector: Equatable {

    private var rawX: Double
    private var rawY: Double

    var x: Double {
        get { self.rawX * Constants.UI_SCREEN_WIDTH }
        set { self.rawX = newValue / Constants.UI_SCREEN_WIDTH }
    }

    var y: Double {
        get { self.rawY * Constants.UI_SCREEN_HEIGHT }
        set { self.rawY = newValue / Constants.UI_SCREEN_HEIGHT }
    }

    var area: Double {
        x * y
    }

    var normalVector: Vector {
        Vector(magnitude: self.magnitude,
               angle: Angle(degrees: (self.angle.degrees - 90)))
    }

    /// Returns a normalized unit Vector
    var normalized: Vector {
        self / self.magnitude
    }

    // Initialize with components
    init(x: Double, y: Double) {
        self.rawX = x / Constants.UI_SCREEN_WIDTH
        self.rawY = y / Constants.UI_SCREEN_HEIGHT
    }

    init(scaled_x: Double, scaled_y: Double) {
        self.rawX = scaled_x
        self.rawY = scaled_y
    }

    /// Initialize with magnitude and angle (in radians)
    init(magnitude: Double, angle: Angle) {
        self.rawX = (magnitude * sin(angle.radians)) / Constants.UI_SCREEN_WIDTH
        self.rawY = (magnitude * cos(angle.radians)) / Constants.UI_SCREEN_HEIGHT
    }

    init(with point: CGPoint) {
        self.rawX = Double(point.x) / Constants.UI_SCREEN_WIDTH
        self.rawY = Double(point.y) / Constants.UI_SCREEN_HEIGHT
    }

    init(withScaledPoint point: CGPoint) {
        self.rawX = Double(point.x)
        self.rawY = Double(point.y)
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

    var unitPoint: UnitPoint {
        UnitPoint(x: rawX, y: rawY)
    }

    mutating func invert() {
        x.negate()
        y.negate()
    }

}

/// This extension provides static functions to return normalized vectors
extension Vector {

    /// Returns a zero vector
    static var zero: Vector {
        Vector(x: .zero, y: .zero)
    }

    /// Returns a unit 2D Vector
    static func unitVector() -> Vector {
        Vector(x: 1, y: 1).normalized
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
            return .zero
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

    static func == (lhs: Vector, rhs: Vector) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }

}
