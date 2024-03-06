import SwiftUI

/// This View contains the Function Bar with the Load, Save, Reset, and Start buttons
struct FunctionBarView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    var options: Options { viewModel.options }
    var isFileNameValid: Bool { options.isFileNameValid }
    var levelNameInput: String { options.levelNameInput }

    @State var showingAlert = false

    var alertTitle: String { viewModel.saveAlertTitle }
    var alertMessage: String { viewModel.saveAlertMessage }
    var alertButtonText: String { viewModel.saveAlertButtonText }

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
        .alert(Text(alertTitle),
               isPresented: $showingAlert,
               actions: { Button(alertButtonText) { } },
               message: { Text(alertMessage) }
        )
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
            showingAlert = true
            viewModel.handleSave()
        }
        .disabled(!isFileNameValid || !viewModel.isStartEnabled())
        .foregroundColor(isFileNameValid && viewModel.isStartEnabled() ? .blue : .gray)
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
            .padding()
    }

    var startButton: some View {
        Button("START") {
            viewModel.handleStart()
        }
        .disabled(!viewModel.isStartEnabled()) // Need at least one goal peg to proceed.
        .foregroundColor(viewModel.isStartEnabled() ? .blue : .gray)
        .padding(.trailing, 20)
    }
}
