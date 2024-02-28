import XCTest
import SwiftUI

@testable import SpacePeggle

class PhysicsModelsTests: XCTestCase {

    // Mock PhysicsObject for testing
    class MockPhysicsObject: PhysicsObject {
        var id = UUID()
        var centerPosition: Vector
        var mass: Double
        var velocity: Vector
        var force: Vector
        var shape: PhysicsShape

        required init(mass: Double, velocity: Vector, centerPosition: Vector, force: Vector, id: UUID) {
            self.mass = mass
            self.velocity = velocity
            self.centerPosition = centerPosition
            self.force = force
            self.shape = CircleShape(center: centerPosition, radius: 10) // Arbitrary radius for testing
        }

        func activateGameObject() {
            // Implementation not required for physics tests
        }
    }

    func testAccelerationCalculation() {
        let object = MockPhysicsObject(mass: 2.0, velocity: .zero,
                                       centerPosition: .zero, force: Vector(x: 0, y: 10), id: UUID())
        XCTAssertEqual(object.acceleration, Vector(x: 0, y: 5),
                       "Acceleration should be correctly calculated as force divided by mass.")
    }

    func testApplyPhysics() {
        var object = MockPhysicsObject(mass: 1.0, velocity: Vector(x: 1, y: 0),
                                       centerPosition: Vector(x: 0, y: 0), force: Vector(x: 2, y: 0), id: UUID())
        object.applyPhysics(timeStep: 1)

        XCTAssertEqual(object.velocity, Vector(x: 3, y: 0),
                       "Velocity should be correctly updated based on force and mass over a time step.")
    }

    func testIntersectsWithCircle() {
        let shape1 = CircleShape(center: Vector(x: 0, y: 0), radius: 5)
        let shape2 = CircleShape(center: Vector(x: 9, y: 0), radius: 5)

        XCTAssertTrue(shape1.intersects(with: shape2),
                      "Two circles should intersect if the distance between their centers"
                      + "is less than or equal to the sum of their radii.")
    }

    func testDoesNotIntersectWithCircle() {
        let shape1 = CircleShape(center: Vector(x: 0, y: 0), radius: 5)
        let shape2 = CircleShape(center: Vector(x: 11, y: 0), radius: 5)

        XCTAssertFalse(shape1.intersects(with: shape2),
                       "Two circles should not intersect if the distance between"
                       + "their centers is greater than the sum of their radii.")
    }

}
