import SwiftUI

/// This View presents the File selection view for selecting levels to load,
/// but also contains some helper methods conventionally delegated to a ViewModel.
struct FileListView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel
    @State var showingAlert = false

    var files: [String] { viewModel.options.files }
    var onSelect: (String) -> Void

    var alertTitle: String { viewModel.deletionAlertTitle }
    var alertMessage: String { viewModel.deletionAlertMessage }
    var alertButtonText: String { viewModel.deletionAlertButtonText }

    var body: some View {
        NavigationStack {
            List {
                ForEach(files, id: \.self) { file in
                    Button(file) { onSelect(file) }
                }
                .onDelete(perform: viewModel.deleteSingleFile)
            }
            .navigationBarTitle("Select a Level to load", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                showingAlert = true
            }, label: {
                Text("Delete All").foregroundColor(.red)
            }), trailing: Button("Done") {
                viewModel.updateShowingFileListToFalse()
            })
            .alert(Text(alertTitle),
                   isPresented: $showingAlert,
                   actions: { Button(alertButtonText, role: .destructive) { viewModel.handleDeleteAllFiles() } },
                   message: { Text(alertMessage) }
            )
        }
    }

}
