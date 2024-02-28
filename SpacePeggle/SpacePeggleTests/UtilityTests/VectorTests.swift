import XCTest
import SwiftUI
@testable import SpacePeggle

class VectorTests: XCTestCase {

    func testInitializationWithComponents() {
        let vector = Vector(x: 3.0, y: 4.0)
        XCTAssertEqual(vector.x, 3.0, "Vector's x compontent should be correctly initialized.")
        XCTAssertEqual(vector.y, 4.0, "Vector's y component should be correctly initialized.")
    }

    func testInitializationWithCGPoint() {
        let point = CGPoint(x: 3.0, y: 4.0)
        let vector = Vector(with: point)
        XCTAssertEqual(vector.x, point.x, "Vector initialized with CGPoint should have the same x value.")
        XCTAssertEqual(vector.y, point.y, "Vector initialized with CGPoint should have the same y value.")
    }

    func testMagnitude() {
        let vector = Vector(x: 3.0, y: 4.0)
        XCTAssertEqual(vector.magnitude, 5.0, "Magnitude of a 3-4-5 vector should be 5.")
    }

    func testAngle() {
        let vector = Vector(x: 0.0, y: 1.0)
        XCTAssertEqual(vector.angle.radians, Angle(degrees: 90).radians,
                       accuracy: 0.01, "Angle should be 90 degrees for a vector with components (0,1).")
    }

    func testAngleFromCenterAxis() {
        let vector = Vector(x: 0.0, y: 1.0)
        XCTAssertEqual(vector.angleFromCenterAxis.degrees, 180.0, accuracy: 0.01,
                       "Angle from center axis should be 180 degrees for a vector with components (0,1).")
    }

    func testInvert() {
        var vector = Vector(x: 3.0, y: -4.0)
        vector.invert()
        XCTAssertEqual(vector.x, -3.0, "Inverting a vector should negate its x component.")
        XCTAssertEqual(vector.y, 4.0, "Inverting a vector should negate its y component.")
    }

    func testUnitVectorX() {
        let vector = Vector.unitVectorX()
        XCTAssertEqual(vector.x, 1.0, "Unit vector in X direction should have x component of 1.")
        XCTAssertEqual(vector.y, 0.0, "Unit vector in X direction should have y component of 0.")
    }

    func testUnitVectorY() {
        let vector = Vector.unitVectorY()
        XCTAssertEqual(vector.x, 0.0, "Unit vector in Y direction should have x component of 0.")
        XCTAssertEqual(vector.y, 1.0, "Unit vector in Y direction should have y component of 1.")
    }

    func testUnitVector() {
        let vector = Vector.unitVector()
        XCTAssertEqual(vector.magnitude, 1.0, accuracy: 0.01, "Magnitude of a normalized unit vector should be 1.")
    }

    func testZeroVector() {
        let vector = Vector.zero
        XCTAssertEqual(vector.x, 0.0, "Zero vector should have x component of 0.")
        XCTAssertEqual(vector.y, 0.0, "Zero vector should have y component of 0.")
    }

    func testNormalized() {
        let vector = Vector(x: 3.0, y: 4.0).normalized()
        XCTAssertEqual(vector.magnitude, 1.0, accuracy: 0.01, "Normalized vector should have a magnitude of 1.")
    }

    func testApplyDamping() {
        let vector = Vector(x: 2.0, y: 3.0)
        let dampedVector = vector.applyDamping(0.5)
        XCTAssertEqual(dampedVector.x, 1.0,
                       "Damping a vector's x component by 0.5 should halve its value.")
        XCTAssertEqual(dampedVector.y, 1.5,
                       "Damping a vector's y component by 0.5 should halve its value.")
    }

    // Arithmetic operations tests
    func testAddition() {
        let vector1 = Vector(x: 1.0, y: 2.0)
        let vector2 = Vector(x: 3.0, y: 4.0)
        let result = vector1 + vector2
        XCTAssertEqual(result.x, 4.0,
                       "Adding two vectors should correctly sum their x components.")
        XCTAssertEqual(result.y, 6.0,
                       "Adding two vectors should correctly sum their y components.")
    }

    func testSubtraction() {
        let vector1 = Vector(x: 3.0, y: 4.0)
        let vector2 = Vector(x: 1.0, y: 2.0)
        let result = vector1 - vector2
        XCTAssertEqual(result.x, 2.0,
                       "Subtracting two vectors should correctly subtract their x components.")
        XCTAssertEqual(result.y, 2.0,
                       "Subtracting two vectors should correctly subtract their y components.")
    }

    func testScalarMultiplication() {
        let vector = Vector(x: 3.0, y: 4.0)
        let result = vector * 2.0
        XCTAssertEqual(result.x, 6.0,
                       "Multiplying a vector by a scalar should multiply its x component by that scalar.")
        XCTAssertEqual(result.y, 8.0,
                       "Multiplying a vector by a scalar should multiply its y component by that scalar.")
    }

    func testScalarDivision() {
        let vector = Vector(x: 4.0, y: 8.0)
        let result = vector / 2.0
        XCTAssertEqual(result.x, 2.0,
                       "Dividing a vector by a scalar should divide its x component by that scalar.")
        XCTAssertEqual(result.y, 4.0,
                       "Dividing a vector by a scalar should divide its y component by that scalar.")
    }

    func testDotProduct() {
        let vector1 = Vector(x: 1.0, y: 2.0)
        let vector2 = Vector(x: 3.0, y: 4.0)
        let result = Vector.dot(vector1, vector2)
        XCTAssertEqual(result, 11.0,
                       "Dot product should correctly calculate the sum of the products of the vectors' components.")
    }

    func testCrossProduct() {
        let vector1 = Vector(x: 1.0, y: 2.0)
        let vector2 = Vector(x: 3.0, y: 4.0)
        let result = Vector.cross(vector1, vector2)
        XCTAssertEqual(result, -2.0,
                       "Cross product should correctly calculate the determinant of the vectors' components.")
    }
}
