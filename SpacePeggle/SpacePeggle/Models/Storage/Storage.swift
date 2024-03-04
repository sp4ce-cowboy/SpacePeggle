import SwiftUI

/// This storage utility class provides standard storage operations and interaction with
/// the on device files storage system.
class Storage {
    static let folderName = Constants.STORAGE_CONTAINER_NAME

    static func fileURL(for directory: FileManager.SearchPathDirectory, withName name: String) throws -> URL {
        let fileManager = FileManager.default

        return try fileManager.url(for: directory, in: .userDomainMask,
                                   appropriateFor: nil, create: true).appendingPathComponent(name)
    }

    static func createFolderIfNeeded(folderName: String) throws -> URL {
        let fileManager = FileManager.default
        let documentsURL: URL = try fileManager.url(for: .documentDirectory, in: .userDomainMask,
                                                    appropriateFor: nil, create: false)

        let folderURL = documentsURL.appendingPathComponent(folderName)
        if !fileManager.fileExists(atPath: folderURL.path) {
            try fileManager.createDirectory(at: folderURL,
                                            withIntermediateDirectories: true, attributes: nil)
        }

        return folderURL
    }

    static func listSavedFiles(folderName: String = folderName) -> [String] {
        do {
            let folderURL = try createFolderIfNeeded(folderName: folderName)
            let contents = try FileManager.default.contentsOfDirectory(at: folderURL,
                                                                       includingPropertiesForKeys: nil)

            let files = contents
                .filter { $0.pathExtension == "json" }
                .map { $0.lastPathComponent }

            return files

        } catch {
            Logger.log("Error listing files: \(error)")
            return []
        }
    }

    static func deleteAllFiles(_ fileList: [String], _ folder: String = Constants.STORAGE_CONTAINER_NAME) {
        for fileName in fileList {
            do {
                let folderURL = try createFolderIfNeeded(folderName: folder)
                let fileURL = folderURL.appendingPathComponent(fileName)
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                Logger.log("Error deleting file: \(fileName), \(error)")
            }
        }

        Logger.log("All files deleted.")
    }

    static func saveLevel(_ level: Level,
                          withName name: String = UUID().uuidString,
                          folderName: String = folderName) {
        guard !name.isEmpty else {
            return
        }
        let fileName = name + ".json"

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(level)
            let folderURL = try Storage.createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(fileName)

            try data.write(to: fileURL)
            Logger.log("Saved Level at: \(fileURL.path)")
        } catch {
            Logger.log("Error saving level: \(error)")
        }
    }

    static func loadLevel(from fileName: String, folderName: String = folderName) -> AbstractLevel? {
        do {
            let folderURL = try Storage.createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(fileName)
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(Level.self, from: data)
        } catch {
            Logger.log("Error loading level: \(error)")
            return nil
        }
    }

}
