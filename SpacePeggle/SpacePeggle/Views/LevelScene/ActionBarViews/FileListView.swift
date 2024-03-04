import SwiftUI

/// This View presents the File selection view for selecting levels to load,
/// but also contains some helper methods conventionally delegated to a ViewModel.
struct FileListView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    var showingDeleteAllAlert: Bool {
        get { viewModel.options.showingDeleteAllAlert }
        set { viewModel.options.showingDeleteAllAlert = newValue }
    }
    var isPresented: Bool { viewModel.options.isPresented }
    var files: [String] { viewModel.options.files }

    var onSelect: (String) -> Void

    var body: some View {
        NavigationView {
            List {
                ForEach(files, id: \.self) { file in
                    Button(file) { onSelect(file) }
                }
                .onDelete(perform: viewModel.deleteSingleFile)
            }
            .navigationBarTitle("Select a Level to load", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                viewModel.options.showingDeleteAllAlert = true
            }, label: {
                Text("Delete All").foregroundColor(.red)
            }), trailing: Button("Done") {
                viewModel.options.isPresented = true
            })
            .alert(isPresented: viewModel.showingDeleteAllAlertBinding) {
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete all files? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete All")) {
                        viewModel.handleDeleteAllFiles()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

}
