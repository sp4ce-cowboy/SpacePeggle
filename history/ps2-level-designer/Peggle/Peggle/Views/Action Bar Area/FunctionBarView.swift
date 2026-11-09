import SwiftUI

/// This View contains the Function Bar with the Load, Save, Reset, and Start buttons
struct FunctionBarView: View {
    @Binding var levelNameInput: String
    @Binding var pegs: [Peg]

    @State var showingFileList = false
    @State var showingSuccessAlert = false
    @State private var files = [String]()

    var isFileNameValid: Bool {
        !levelNameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        HStack {
            Button("LOAD") {
                files = Storage.listSavedFiles()
                clearEmptyTextFieldAndDismissKeyboard()
                showingFileList = true
            }
            .padding(.leading, 20)

            Button("SAVE") {
                guard isFileNameValid else {
                    return
                }
                saveLevel(withName: levelNameInput, pegs: pegs)
                clearEmptyTextFieldAndDismissKeyboard()
            }
            .disabled(!isFileNameValid)
            .foregroundColor(isFileNameValid ? .blue : .gray).padding()

            Button("RESET") {
                pegs = []
                clearEmptyTextFieldAndDismissKeyboard()
            }

            TextField("Level Name", text: $levelNameInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .environment(\.colorScheme, .light)
                .keyboardType(.default).autocorrectionDisabled()
                .background(Color.white).padding()

            Button("START") {
                clearEmptyTextFieldAndDismissKeyboard()
            }
            .padding(.trailing, 20)
        }
        .background(Color.white)
        .ignoresSafeArea()
        .sheet(isPresented: $showingFileList) {
            FileListView(isPresented: $showingFileList, files: $files) { selectedFile in
                if let loadedPegs = Peg.loadLevel(from: selectedFile) {
                    pegs = loadedPegs
                }
                showingFileList = false
            }
        }
        .alert(isPresented: $showingSuccessAlert) { // Alert for successful save
            Alert(title: Text("Level \(levelNameInput) Saved"),
                  message: Text("The level has been saved successfully."),
                  dismissButton: .default(Text("OK")))
        }
    }

    /// Helper function to consolidate the save file sequence of operations
    private func saveLevel(withName name: String, pegs: [Peg]) {
        let trimmedFileName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        Peg.saveLevel(pegs, withName: trimmedFileName)
        showingSuccessAlert = true
        levelNameInput = ""
        files = Storage.listSavedFiles() // Update the file list
    }

    /// A self-explanatory helper function to faciliate a more seamless
    /// UX by auto-dimissing the keyboard and text field as needed.
    private func clearEmptyTextFieldAndDismissKeyboard() {

        // Clear out the text field before dismissing the keyboard
        if !isFileNameValid {
            levelNameInput = ""
        }
        Utility.dismissKeyboard()
    }

}
