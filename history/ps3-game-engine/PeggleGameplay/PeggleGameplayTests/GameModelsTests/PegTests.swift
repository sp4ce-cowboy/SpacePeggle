import XCTest
import SwiftUI

@testable import PeggleGameplay

class PegTests: XCTestCase {

    func testPegInitialization() {
        let centerPosition = Vector(x: 50, y: 100)
        let peg = Peg(centerPosition: centerPosition)

        XCTAssertEqual(peg.centerPosition, centerPosition,
                       "Peg's centerPosition should match the initialized value.")
        XCTAssertEqual(peg.mass, .infinity,
                       "Peg's mass should be infinity.")
        XCTAssertEqual(peg.velocity, Vector.zeroVector(),
                       "Peg's initial velocity should be a zero vector.")
        XCTAssertFalse(peg.isActive,
                       "Peg should initially be inactive.")
    }

    func testNormalPegInitializationAndActivation() {
        let centerPosition = Vector(x: 75, y: 150)
        let normalPeg = NormalPeg(centerPosition: centerPosition)

        XCTAssertEqual(normalPeg.gameObjectType,
                       "NormalPeg", "NormalPeg's gameObjectType should be 'NormalPeg'.")

        normalPeg.activateGameObject()

        XCTAssertTrue(normalPeg.isActive,
                      "NormalPeg should be active after activation.")
        XCTAssertEqual(normalPeg.gameObjectType,
                       "NormalPegActive",
                       "NormalPeg's gameObjectType should change to 'NormalPegActive' upon activation.")
    }

    func testGoalPegInitializationAndActivation() {
        let centerPosition = Vector(x: 100, y: 200)
        let goalPeg = GoalPeg(centerPosition: centerPosition)

        XCTAssertEqual(goalPeg.gameObjectType,
                       "GoalPeg", "GoalPeg's gameObjectType should be 'GoalPeg'.")

        goalPeg.activateGameObject()

        XCTAssertTrue(goalPeg.isActive,
                      "GoalPeg should be active after activation.")
        XCTAssertEqual(goalPeg.gameObjectType,
                       "GoalPegActive", "GoalPeg's gameObjectType should change to 'GoalPegActive' upon activation.")
    }

}
