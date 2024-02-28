import XCTest
import SwiftUI

@testable import SpacePeggle

class BallTests: XCTestCase {

    func testBallInitialization() {
        let centerPosition = Vector(x: 100, y: 200)
        let velocity = Vector(x: 10, y: 15)
        let mass = 10.0
        let ball = Ball(mass: mass, velocity: velocity, centerPosition: centerPosition)

        XCTAssertEqual(ball.centerPosition, centerPosition,
                       "Ball's centerPosition should be initialized to the given value.")
        XCTAssertEqual(ball.velocity, velocity,
                       "Ball's velocity should be initialized to the given value.")
        XCTAssertEqual(ball.mass, mass,
                       "Ball's mass should be initialized to the given value.")
        XCTAssertTrue(ball.shape is CircleShape,
                      "Ball's shape should be a CircleShape.")
        XCTAssertEqual((ball.shape as? CircleShape)?.radius, Ball.BALL_RADIUS,
                       "Ball's shape radius should match BALL_RADIUS.")
    }

    func testUpdatePosition() {
        let ball = Ball()
        let newLocation = Vector(x: 300, y: 400)
        ball.updatePosition(to: newLocation)

        XCTAssertEqual(ball.centerPosition, newLocation,
                       "Ball's centerPosition should be updated to the new location.")
        XCTAssertEqual((ball.shape as? CircleShape)?.center, newLocation,
                       "Ball's shape center should be updated to match the new centerPosition.")
    }

    func testApplyPhysics() {
        let ball = Ball(mass: 1.0, velocity: .zero, centerPosition: .zero)
        let timeStep: TimeInterval = 1.0

        ball.applyPhysics(timeStep: timeStep)

        // After applying physics for 1 second, check gravity effect on velocity and position
        let expectedForce = Constants.UNIVERSAL_GRAVITY.y * ball.mass
        let expectedAcceleration = expectedForce / ball.mass
        let expectedVelocity = Vector(x: 0, y: expectedAcceleration) * timeStep
        let expectedPosition = ball.centerPosition + expectedVelocity * timeStep

        XCTAssertEqual(ball.force.y, expectedForce,
                       "Ball's force should be updated to reflect gravity.")
        XCTAssertEqual(ball.velocity.y, expectedVelocity.y, accuracy: 0.01,
                       "Ball's velocity should be updated based on gravity acceleration.")
        XCTAssertEqual(ball.centerPosition.y, expectedPosition.y / 2, accuracy: 0.01,
                       "Ball's position should be updated based on velocity.")
    }

    func testSubjectToGravity() {
        let ball = Ball(mass: 1.0)
        ball.subjectToGravity()

        let expectedForce = Constants.UNIVERSAL_GRAVITY * ball.mass
        XCTAssertEqual(ball.force, expectedForce,
                       "Ball should be subjected to gravity, updating its force accordingly.")
    }

}
