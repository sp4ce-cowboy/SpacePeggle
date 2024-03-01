import SwiftUI

/// This storage utility class provides standard storage operations and interaction with
/// the on device files storage system.
class Storage {
    static let folderName = Constants.STORAGE_CONTAINER_NAME

    static func fileURL(for directory: FileManager.SearchPathDirectory,
                        withName name: String) throws -> URL {

        try FileManager.default.url(for: directory, in: .userDomainMask, appropriateFor: nil,
                                    create: true).appendingPathComponent(name)
    }

    static func createFolderIfNeeded(folderName: String) throws -> URL {
        let fileManager = FileManager.default
        let documentsURL = try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask, appropriateFor: nil, create: false)

        let folderURL = documentsURL.appendingPathComponent(folderName)

        if !fileManager.fileExists(atPath: folderURL.path) {

            try fileManager.createDirectory(at: folderURL,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        }

        return folderURL
    }

    static func listSavedFiles(folderName: String = folderName) -> [String] {
        do {
            let folderURL = try createFolderIfNeeded(folderName: folderName)
            let contents = try FileManager.default.contentsOfDirectory(
                at: folderURL, includingPropertiesForKeys: nil)

            let files = contents.filter { $0.pathExtension == "json" }
                .map { $0.lastPathComponent }

            return files

        } catch {
            print("Error listing files: \(error)")
            return []
        }
    }

    static func deleteAllFiles(_ fileList: [String],
                               _ folder: String = Constants.STORAGE_CONTAINER_NAME) {

        for fileName in fileList {
            do {
                let folderURL = try createFolderIfNeeded(
                    folderName: folder)

                let fileURL = folderURL.appendingPathComponent(fileName)
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Error deleting file: \(fileName), \(error)")
            }
        }

        print("All files deleted.")
    }

}
