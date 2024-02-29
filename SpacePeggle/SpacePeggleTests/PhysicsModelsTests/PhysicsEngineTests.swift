import XCTest
import SwiftUI

@testable import SpacePeggle

class PhysicsEngineTests: XCTestCase {

    func testAddPhysicsObject() {
        let engine = PhysicsEngine(domain: CGRect(x: 0, y: 0, width: 100, height: 100))
        let ball = Ball(centerPosition: Vector(x: 50, y: 50))

        engine.addPhysicsObject(object: ball)
        XCTAssertEqual(engine.physicsObjects.count, 1,
                       "PhysicsEngine should correctly add a physics object.")
    }

    func testUpdatePhysicsWithBoundaryCollision() {
        let domain = CGRect(x: 0, y: 0, width: 100, height: 100)
        let engine = PhysicsEngine(domain: domain)
        let ball = Ball(velocity: Vector(x: 10, y: 0), centerPosition: Vector(x: 99, y: 50))

        engine.addPhysicsObject(object: ball)
        engine.updatePhysics(timeStep: 1)

        let updatedBall = engine.physicsObjects[ball.id]
        XCTAssertLessThanOrEqual(updatedBall!.centerPosition.x, domain.width,
                                 "Ball should collide and stay within the right boundary.")
    }

    func testCollisionActivatesGameObject() {
        let engine = PhysicsEngine(domain: CGRect(x: 0, y: 0, width: 300, height: 300))
        let peg = NormalPeg(centerPosition: Vector(x: 150, y: 150))
        let ball = Ball(velocity: Vector(x: 5, y: 0), centerPosition: Vector(x: 145, y: 150))

        engine.addPhysicsObject(object: peg)
        engine.addPhysicsObject(object: ball)
        engine.detectAndHandleCollisions()

        let updatedPeg = engine.physicsObjects[peg.id] as? NormalPeg
        XCTAssertTrue(updatedPeg!.isActive,
                      "Peg should be activated upon collision with the ball.")
    }

    // Testing for objects at the edge of the boundary to ensure they don't escape or behave unexpectedly
    func testObjectsAtBoundaryEdge() {
        let engine = PhysicsEngine(domain: CGRect(x: 0, y: 0, width: 300, height: 300))
        let edgeBall = Ball(velocity: Vector(x: -10, y: 0), centerPosition: Vector(x: 0, y: 150))

        engine.addPhysicsObject(object: edgeBall)
        engine.updatePhysics(timeStep: 1)

        let updatedEdgeBall = engine.physicsObjects[edgeBall.id]!

        XCTAssertTrue(updatedEdgeBall.centerPosition.x >= 0,
                      "Ball at the edge should not move past the boundary.")
        XCTAssertTrue(updatedEdgeBall.velocity.x > 0,
                      "Ball's velocity should be reflected upon hitting the boundary.")
    }
}
