import XCTest
@testable import Peggle

class StorageTests: XCTestCase {

    override func tearDownWithError() throws {
        // Removes the test folder, if created.
        try FileManager.default.removeItem(at: try
                        Storage.createFolderIfNeeded(folderName: "TestFolder"))
    }

    /// Tests for fileURL(for:withName:)
    func testFileURLForDirectoryWithName() throws {
        // This test ensures the fileURL(for:withName:) function returns a
        // valid URL for a given directory and file name.
        let fileName = "testFile.json"
        let fileURL = try Storage.fileURL(for: .documentDirectory, withName: fileName)

        XCTAssertEqual(fileURL.lastPathComponent, fileName, "The last path component should match the file name.")
    }

    func testCreateFolderIfNeeded() throws {
        // This test verifies that a folder is created if it doesn't already exist.
        let folderName = UUID().uuidString // Use a unique name to avoid conflicts
        let folderURL = try Storage.createFolderIfNeeded(folderName: folderName)

        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDir)

        XCTAssertTrue(exists && isDir.boolValue, "The folder should exist and be a directory.")
    }

    /// Tests for listSavedFiles(folderName:)
    func testListSavedFiles() throws {
        // This test checks if listing files in a newly created folder returns an empty array.
        let folderName = UUID().uuidString // Use a unique name to ensure the folder is empty
        _ = try Storage.createFolderIfNeeded(folderName: folderName)
        let files = Storage.listSavedFiles(folderName: folderName)

        XCTAssertTrue(files.isEmpty, "The list of files should be empty for a new folder.")
    }

    /// Tests for deleteAllFiles(_:)
    func testDeleteAllFiles() throws {
        // This test verifies that all specified files are deleted.
        let folderName = "TestFolder"
        let testFileNames = ["file1.json", "file2.json"]

        // Setup - Create a folder and files to delete
        let folderURL = try Storage.createFolderIfNeeded(folderName: folderName)
        for fileName in testFileNames {
            let fileURL = folderURL.appendingPathComponent(fileName)
            FileManager.default.createFile(atPath: fileURL.path,
                                           contents: Data(),
                                           attributes: nil)
        }

        // Execute mass delete
        Storage.deleteAllFiles(testFileNames, "TestFolder")

        // Verify deletion complete
        for fileName in testFileNames {
            let fileURL = folderURL.appendingPathComponent(fileName)
            let exists = FileManager.default.fileExists(atPath: fileURL.path)
            XCTAssertFalse(exists, "The file \(fileName) should have been deleted.")
        }
    }
}
