import XCTest
@testable import SpacePeggle

// Running this test class might sometimes cause an exception to be thrown.
class DisplayLinkTests: XCTestCase {

    var displayLink: DisplayLink!

    override func setUp() {
        super.setUp()
        // Initialize DisplayLink instance before each test
        displayLink = DisplayLink.sharedInstance
    }

    override func tearDown() {
        // Invalidate and clean up after each test
        displayLink.invalidate()
        displayLink = nil
        super.tearDown()
    }

    func testSingletonInstance() {
        // Verify that the sharedInstance returns the same instance
        XCTAssertNotNil(DisplayLink.sharedInstance, "Singleton instance should not be nil.")
        XCTAssertTrue(displayLink === DisplayLink.sharedInstance,
                      "Singleton instance should return the same DisplayLink instance.")
    }

    func testSetupDisplayLink() {
        // This test assumes the DisplayLink setup does not crash and is correctly assigned
        displayLink.setupDisplayLink()
        XCTAssertNotNil(displayLink.displayLink, "displayLink should not be nil after setupDisplayLink is called.")
    }

    func testInvalidate() {
        // This test checks if the display link is correctly invalidated and set to nil
        displayLink.setupDisplayLink()
        XCTAssertNotNil(displayLink.displayLink, "displayLink should not be nil after setup.")
        displayLink.invalidate()
        XCTAssertNil(displayLink.displayLink, "displayLink should be nil after invalidate is called.")
    }
}
