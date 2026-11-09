import XCTest
@testable import Peggle

class PegStorageTests: XCTestCase {

    let testFolderName = "PegTests"

    override func setUpWithError() throws {
        // Setup - Create a test directory
        _ = try Storage.createFolderIfNeeded(folderName: testFolderName)
    }

    override func tearDownWithError() throws {
        // Teardown - Delete the test directory
        let folderURL = try Storage.createFolderIfNeeded(folderName: testFolderName)
        let contents = try FileManager.default.contentsOfDirectory(atPath: folderURL.path)
        for fileName in contents {
            let fileURL = folderURL.appendingPathComponent(fileName)
            try FileManager.default.removeItem(at: fileURL)
        }
    }

    /// Tests for saveLevel(_:withName:folderName:)
    func testSaveLevel() throws {
        // This test checks if the saveLevel function correctly writes Peg data to a file.
        let pegs = [Peg(centerPosition: CGPoint(x: 50, y: 50), color: .blue)]
        let levelName = "testLevel"
        Peg.saveLevel(pegs, withName: levelName, folderName: testFolderName)

        let folderURL = try Storage.createFolderIfNeeded(folderName: testFolderName)
        let fileURL = folderURL.appendingPathComponent(levelName + ".json")

        let exists = FileManager.default.fileExists(atPath: fileURL.path)

        XCTAssertTrue(exists, "The file should exist after saving the level.")
    }

    /// Tests for loadLevel(from:folderName:)
    func testLoadLevel() throws {
        // This test checks if the loadLevel function correctly reads Peg data from a file.
        let originalPegs = [Peg(centerPosition: CGPoint(x: 100, y: 100), color: .blue)]
        let levelName = "testLoadLevel"
        Peg.saveLevel(originalPegs, withName: levelName, folderName: testFolderName)

        if let loadedPegs = Peg.loadLevel(from: levelName + ".json", folderName: testFolderName) {
            XCTAssertEqual(loadedPegs.count, originalPegs.count,
                           "The number of Pegs loaded should match the number saved.")

            XCTAssertEqual(loadedPegs.first?.centerPosition, originalPegs.first?.centerPosition,
                           "The Peg's positions should match.")

            XCTAssertEqual(loadedPegs.first?.color, originalPegs.first?.color,
                           "The Peg's colors should match.")
        } else {

            XCTFail("The level should have loaded successfully.")
        }
    }
}
