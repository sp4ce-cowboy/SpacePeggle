import SwiftUI

/// This View contains the Function Bar with the Load, Save, Reset, and Start buttons
struct FunctionBarView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    var options: Options { viewModel.options }
    var isFileNameValid: Bool { options.isFileNameValid }
    var levelNameInput: String { options.levelNameInput }

    var body: some View {
        HStack {
            loadButton
            saveButton
            resetButton
            levelInputTextField
            startButton
        }
        .sheet(isPresented: viewModel.showingFileListBinding) {
            FileListView { selectedFile in
                if let loadedLevel = Storage.loadLevel(from: selectedFile) {
                    viewModel.updateLevel(with: loadedLevel)
                }
                viewModel.updateShowingFileListToFalse()
            }
        }
        /*.alert(isPresented: viewModel.showingSuccessAlertBinding) {
            Alert(title: Text("Level \(levelNameInput) Saved"),
                  message: Text("The level has been saved successfully."),
                  dismissButton: .default(Text("OK")))
        }*/
    }

    var loadButton: some View {
        Button("LOAD") {
            viewModel.handleLoad()
        }
        .padding(.leading, 20)
    }

    var saveButton: some View {
        Button("SAVE") {
            guard isFileNameValid else {
                return
            }
            viewModel.handleSave()
        }
        .disabled(!isFileNameValid)
        .foregroundColor(isFileNameValid ? .blue : .gray)
        .padding()
    }

    var resetButton: some View {
        Button("RESET") {
            viewModel.handleReset()
        }
    }

    var levelInputTextField: some View {
        TextField("Level Name", text: viewModel.levelNameInputBinding)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .environment(\.colorScheme, .light)
            .keyboardType(.default)
            // .autocorrectionDisabled()
            .padding()
    }

    var startButton: some View {
        Button("START") {
            viewModel.handleStart()
        }
        .padding(.trailing, 20)
    }
}
