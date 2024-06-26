import SwiftUI

/// A class to model a vector quantity with 2 generic doubles.
/// Each vector is stored and retrieved as a unit point based on the size of
/// the screen. This ensures that the game remains consistent across iPads of different
/// sizes.
struct Vector: Codable, Equatable, CustomStringConvertible {

    static let widthScale = Constants.UI_SCREEN_WIDTH
    static let heightScale = Constants.UI_SCREEN_HEIGHT

    private var rawX: Double
    private var rawY: Double

    var description: String {
        "Vector(x: \(rawX * Vector.widthScale), y: \(rawY * Vector.heightScale), rawX: \(rawX), rawY: \(rawY)"
    }

    var x: Double {
        get { self.rawX * Vector.widthScale }
        set { self.rawX = newValue / Vector.widthScale }
    }

    var y: Double {
        get { self.rawY * Vector.heightScale }
        set { self.rawY = newValue / Vector.heightScale }
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
        rawX = x / Vector.widthScale
        rawY = y / Vector.heightScale
    }

    init(scaled_x: Double, scaled_y: Double) {
        self.rawX = scaled_x
        self.rawY = scaled_y
    }

    /// Initialize with magnitude and angle (in radians)
    init(magnitude: Double, angle: Angle) {
        self.rawX = (magnitude * sin(angle.radians)) / Vector.widthScale
        self.rawY = (magnitude * cos(angle.radians)) / Vector.heightScale
    }

    init(with point: CGPoint) {
        self.rawX = Double(point.x) / Vector.widthScale
        self.rawY = Double(point.y) / Vector.heightScale
    }

    init(withScaledPoint point: CGPoint) {
        self.rawX = Double(point.x)
        self.rawY = Double(point.y)
    }

    static var screenCenter: Vector {
        Vector(x: Vector.widthScale.half, y: Vector.heightScale.half)
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

/// This extension provides static functions to return special vectors
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

    // Scalar multiplication to make swift compiler do less work
    static func * (_ scalar: Double, _ vector: Vector) -> Vector {
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

    static func project(this a: Vector, onto that: Vector) -> Vector {
        // The dot product of a and b gives the magnitude of the projection of a onto b,
        // when b is a unit vector.
        let dotProduct = dot(a, that)
        let ontoMagnitudeSquared = dot(that, that)

        let scalarProjection = dotProduct / ontoMagnitudeSquared
        return that * scalarProjection
    }

}
