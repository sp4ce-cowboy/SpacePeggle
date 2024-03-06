import XCTest
import SwiftUI
@testable import SpacePeggle

class LauncherTests: XCTestCase {

    func testLauncherInitialization() {
        let layoutSize = CGSize(width: 100, height: 200)
        let launcher = Launcher(layoutSize: layoutSize)

        XCTAssertEqual(round(Double(launcher.centerPosition.x)), round(Double(layoutSize.width / 2.0)),
                       "Launcher's centerPosition.x should be initialized to half of layoutSize.width.")
        XCTAssertEqual(round(Double(launcher.centerPosition.y)), round(Double(launcher.launcherHeight / 2.0)),
                       "Launcher's centerPosition.y should be initialized to half of launcherHeight.")
        XCTAssertEqual(launcher.rotationAngle.degrees, 0.0,
                       "Launcher's rotationAngle should be initialized to 0 degrees.")
        XCTAssertEqual(launcher.launcherVelocity, Constants.UNIVERSAL_LAUNCH_FORCE,
                       "Launcher's velocity should be initialized to the universal launch force.")
    }

    func testSetRotationAngle() {
        let launcher = Launcher(layoutSize: CGSize(width: 100, height: 200))
        let newAngle = Angle(degrees: 45.0)
        launcher.setRotationAngle(to: newAngle)

        XCTAssertEqual(launcher.rotationAngle, newAngle,
                       "Launcher's rotation angle should be updated to the new angle.")
    }
}
