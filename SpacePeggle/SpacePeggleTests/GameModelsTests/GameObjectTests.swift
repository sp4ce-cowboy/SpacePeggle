import XCTest
import SwiftUI
@testable import SpacePeggle

class GameObjectTests: XCTestCase {

    final class TestGameObject: GameObject {
        var rotation = Angle(degrees: 0)
        var magnification: Double = 1.0
        var centerPosition: Vector
        var id: UUID
        var gameObjectType: String
        var isActive = false

        func activateGameObject() {
            isActive = true
        }

        init(centerPosition: Vector, id: UUID, gameObjectType: String) {
            self.centerPosition = centerPosition
            self.id = UUID()
            self.gameObjectType = gameObjectType
        }
    }

    func testGameObjectEncodingAndDecoding() throws {

        let originalGameObject = TestGameObject(centerPosition: Vector(x: 100, y: 200),
                                                id: UUID(),
                                                gameObjectType: "TestType")

        // Encoding
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalGameObject)

        // Decoding
        let decoder = JSONDecoder()
        let decodedGameObject = try decoder.decode(TestGameObject.self, from: data)

        // Assertions
        XCTAssertEqual(decodedGameObject.centerPosition.x, originalGameObject.centerPosition.x,
                       "Decoded GameObject should have the same centerPosition.x as the original.")
        XCTAssertEqual(decodedGameObject.centerPosition.y, originalGameObject.centerPosition.y,
                       "Decoded GameObject should have the same centerPosition.y as the original.")
        XCTAssertEqual(decodedGameObject.gameObjectType, originalGameObject.gameObjectType,
                       "Decoded GameObject should have the same gameObjectType as the original.")
    }

    func testGameObjectActivation() {
        let gameObject = TestGameObject(centerPosition: Vector(x: 0, y: 0),
                                        id: UUID(),
                                        gameObjectType: "TestType")
        XCTAssertFalse(gameObject.isActive,
                       "GameObject should initially be inactive.")
        gameObject.activateGameObject()
        XCTAssertTrue(gameObject.isActive,
                      "GameObject should be active after calling activateGameObject().")
    }
}
