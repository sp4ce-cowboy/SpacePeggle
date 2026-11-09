import SwiftUI

/// This View presents the File selection view for selecting levels to load,
/// but also contains some helper methods conventionally delegated to a ViewModel.
struct FileListView: View {
    @State private var showingDeleteAllAlert = false
    @Binding var isPresented: Bool
    @Binding var files: [String]
    var onSelect: (String) -> Void

    var body: some View {
        NavigationView {
            List {
                ForEach(files, id: \.self) { file in
                    Button(file) { onSelect(file) }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("Select a Level to load", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                showingDeleteAllAlert = true

            }, label: {
                Text("Delete All").foregroundColor(.red)
            }), trailing: Button("Done") {
                isPresented = false
            })
            .alert(isPresented: $showingDeleteAllAlert) {
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete all files? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete All")) {

                        Storage.deleteAllFiles(files)
                        files.removeAll() // Clear the internal files array after deletion
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    /// Helper function to facilitate the swipe to delete functionality
    private func delete(at offsets: IndexSet) {
        // Find files to delete using the offsets
        let filesToDelete = offsets.compactMap { files[$0] }

        for fileName in filesToDelete {
            // Construct the URL for the file to delete
            do {
                let folderURL = try Storage.createFolderIfNeeded(
                    folderName: Utility.STORAGE_CONTAINER_NAME)

                let fileURL = folderURL.appendingPathComponent(fileName)
                try FileManager.default.removeItem(at: fileURL)

                // Remove the file name from the internal files array
                files.removeAll { $0 == fileName }

                print("Deleted file: \(fileName)")
            } catch {
                print("Error deleting file: \(error)")
            }
        }
    }

}
