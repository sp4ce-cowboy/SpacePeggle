import XCTest
import SwiftUI
@testable import SpacePeggle

class LevelTests: XCTestCase {

    final class TestGameObject: GameObject {
        var gameObjectType: SpacePeggle.Enums.GameObjectType

        var shape: SpacePeggle.UniversalShape

        var rotation = Angle(degrees: 0)
        var magnification: Double = 1.0
        var centerPosition: Vector
        var id = UUID()
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

    func testLevelInitialization() {
        let gameObjects: [UUID: any GameObject] = [
            UUID(): TestGameObject(centerPosition: Vector(x: 1, y: 2),
                                   id: UUID(), gameObjectType: "Test")]
        let level = Level(name: "TestLevel", gameObjects: gameObjects)

        XCTAssertEqual(level.name,
                       "TestLevel", "Level name should be initialized correctly.")
        XCTAssertEqual(level.gameObjects.count, gameObjects.count,
                       "Level gameObjects count should match the initialized gameObjects count.")
    }

    func testStoreGameObject() {
        let level = Level(name: "TestLevel", gameObjects: [:])
        let gameObject = TestGameObject(centerPosition: Vector(x: 3, y: 4), id: UUID(), gameObjectType: "Test")

        level.storeGameObject(gameObject)
        XCTAssertEqual(level.gameObjects[gameObject.id]?.id, gameObject.id,
                       "Stored gameObject should be retrievable with its ID.")
    }

    func testGetGameObject() {
        let gameObject = TestGameObject(centerPosition: Vector(x: 5, y: 6),
                                        id: UUID(), gameObjectType: "Test")
        let gameObjects: [UUID: any GameObject] = [gameObject.id: gameObject]
        let level = Level(name: "TestLevel", gameObjects: gameObjects)

        let fetchedGameObject = level.getGameObject(id: gameObject.id)
        XCTAssertNotNil(fetchedGameObject, "GameObject should be fetched successfully with its ID.")
        XCTAssertEqual(fetchedGameObject?.id, gameObject.id, "Fetched GameObject's ID should match the requested ID.")
    }

    func testGetGameObjectWithNonExistingId() {
        let level = Level(name: "TestLevel", gameObjects: [:])
        let nonExistingId = UUID()

        let fetchedGameObject = level.getGameObject(id: nonExistingId)
        XCTAssertNil(fetchedGameObject, "Fetching a GameObject with a non-existing ID should return nil.")
    }

    func testVerifyGameObjectsIntegrity() {
        let gameObject = TestGameObject(centerPosition: Vector(x: 7, y: 8),
                                        id: UUID(), gameObjectType: "Test")
        let gameObjects: [UUID: any GameObject] = [gameObject.id: gameObject]
        let level = Level(name: "TestLevel", gameObjects: gameObjects)

        XCTAssertTrue(level.verify(),
                      "Level should verify the integrity of gameObjects successfully when all IDs match.")
    }

    func testVerifyGameObjectsIntegrityFailsWithCorruptId() {
        let corruptId = UUID()
        let gameObject = TestGameObject(centerPosition: Vector(x: 9, y: 10),
                                        id: UUID(), gameObjectType: "Test")
        let gameObjects: [UUID: any GameObject] = [corruptId: gameObject]
        let level = Level(name: "MismatchLevel", gameObjects: gameObjects)

        gameObject.id = UUID() // Simulating a corruption by changing the ID to something different than the key
        XCTAssertFalse(level.verify(), "Level should fail to verify the integrity of gameObjects" +
                       " when a GameObject's ID does not match its key.")
    }
}
