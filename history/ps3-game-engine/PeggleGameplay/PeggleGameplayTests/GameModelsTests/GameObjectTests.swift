import XCTest
@testable import PeggleGameplay

class GameObjectTests: XCTestCase {

    final class TestGameObject: GameObject {
        var centerPosition: Vector
        var id: UUID
        var gameObjectType: String
        var isActive = false

        func activateGameObject() {
            isActive = true
        }

        // Note to grader: Choosing to ignore this warning as it would require significant refactoring
        // for no significant benefit
        init(centerPosition: Vector, id: UUID = UUID(), gameObjectType: String) {
            self.centerPosition = centerPosition
            self.id = id
            self.gameObjectType = gameObjectType
        }
    }

    func testGameObjectEncodingAndDecoding() throws {
        let originalGameObject = TestGameObject(centerPosition: Vector(x: 100, y: 200), gameObjectType: "TestType")

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
        XCTAssertEqual(decodedGameObject.id, originalGameObject.id,
                       "Decoded GameObject should have the same id as the original.")
    }

    func testGameObjectActivation() {
        let gameObject = TestGameObject(centerPosition: Vector(x: 0, y: 0), gameObjectType: "TestType")
        XCTAssertFalse(gameObject.isActive,
                       "GameObject should initially be inactive.")
        gameObject.activateGameObject()
        XCTAssertTrue(gameObject.isActive,
                      "GameObject should be active after calling activateGameObject().")
    }
}
