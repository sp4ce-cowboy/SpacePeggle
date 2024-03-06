import SwiftUI

/// An encapsulation of options selected with the LevelSceneViewModel

class Options: ObservableObject {
    @Published var levelNameInput: String = ""
    @Published var showingSuccessAlert = false
    @Published var showingFileList = false
    @Published var showingDeleteAllAlert = false
    @Published var isPresented = false
    @Published var files: [String] = []
    @Published var level: AbstractLevel = Level()

    var isFileNameValid: Bool {
        !levelNameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
