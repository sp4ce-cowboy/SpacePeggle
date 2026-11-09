import XCTest
@testable import Peggle

class PegTests: XCTestCase {

    // Tests for init(centerPosition:color:id:)
    func testInitWithId() {
        // This test ensures that the Peg initializes correctly with a provided ID.
        let id = UUID()
        let position = CGPoint(x: 100, y: 100)
        let color = PegColor.blue

        let peg = Peg(centerPosition: position, color: color, id: id)

        XCTAssertEqual(peg.id, id,
                       "The Peg's id should be the one that was initialized.")
        XCTAssertEqual(peg.centerPosition, position,
                       "The Peg's position should be the one that was initialized.")
        XCTAssertEqual(peg.color, color.rawValue,
                       "The Peg's color should be the one that was initialized.")
    }

    // Tests for init(centerPosition:color:)
    func testInitWithoutId() {
        // This test ensures that the Peg initializes correctly and generates a new UUID.
        let position = CGPoint(x: 200, y: 200)
        let color = PegColor.orange

        let peg = Peg(centerPosition: position, color: color)

        XCTAssertNotNil(peg.id,
                        "The Peg's id should not be nil.")
        XCTAssertEqual(peg.centerPosition, position,
                       "The Peg's position should be the one that was initialized.")
        XCTAssertEqual(peg.color, color.rawValue,
                       "The Peg's color should be the one that was initialized.")
    }

    // Tests for encode(to:) and init(from:)
    func testCodableConformance() throws {

        // This test ensures that a Peg can be encoded and decoded properly.
        let peg = Peg(centerPosition: CGPoint(x: 300, y: 300), color: .blue)

        let data = try JSONEncoder().encode(peg)
        let decodedPeg = try JSONDecoder().decode(Peg.self, from: data)

        XCTAssertEqual(decodedPeg.id, peg.id,
                       "The Peg should maintain its id after encoding and decoding.")
        XCTAssertEqual(decodedPeg.centerPosition, peg.centerPosition,
                       "The Peg should maintain its position after encoding and decoding.")
        XCTAssertEqual(decodedPeg.color, peg.color,
                       "The Peg should maintain its color after encoding and decoding.")
    }

    // Tests for containsPeg(pegs:containsPegAt:)
    func testContainsPeg() {
        // This test checks if the containsPeg function correctly identifies a peg at a specified position.
        let peg1 = Peg(centerPosition: CGPoint(x: 50, y: 50), color: .orange)
        let peg2 = Peg(centerPosition: CGPoint(x: 150, y: 150), color: .orange)
        let pegs = [peg1, peg2]

        let searchPoint = CGPoint(x: 50, y: 50)

        let foundPeg = Peg.containsPeg(pegs: pegs, containsPegAt: searchPoint)

        XCTAssertNotNil(foundPeg,
                        "A peg should be found at the search point.")
        XCTAssertEqual(foundPeg?.id, peg1.id,
                       "The found peg should have the same id as peg1.")
    }

    func testDoesNotContainPeg() {
        // This test verifies that the containsPeg function returns nil when
        // there is no peg at the specified position.
        let peg1 = Peg(centerPosition: CGPoint(x: 50, y: 50), color: .blue)
        let peg2 = Peg(centerPosition: CGPoint(x: 150, y: 150), color: .blue)
        let pegs = [peg1, peg2]

        let searchPoint = CGPoint(x: 200, y: 200)

        let foundPeg = Peg.containsPeg(pegs: pegs, containsPegAt: searchPoint)

        XCTAssertNil(foundPeg,
                     "No peg should be found at the search point, since it is outside of any peg's radius.")
    }

}
