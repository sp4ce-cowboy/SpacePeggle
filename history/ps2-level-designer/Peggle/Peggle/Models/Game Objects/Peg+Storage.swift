import SwiftUI

/// This extension to the Peg model allows for file-IO Operations
extension Peg {
    static let folderName = Utility.STORAGE_CONTAINER_NAME

    static func saveLevel(_ pegs: [Peg], withName name: String = UUID().uuidString,
                          folderName: String = folderName) {
        guard !name.isEmpty else {
            return
        }
        let fileName = name + ".json"

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(pegs)
            let folderURL = try Storage.createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(fileName)

            try data.write(to: fileURL)
            print("Saved Level at: \(fileURL.path)")
        } catch {
            print("Error saving level: \(error)")
        }
    }

    static func loadLevel(from fileName: String, folderName: String = folderName) -> [Peg]? {
        do {
            let folderURL = try Storage.createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(fileName)
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode([Peg].self, from: data)
        } catch {
            print("Error loading level: \(error)")
            return nil
        }
    }
}
