import SwiftUI

struct LevelLoadingView: View {
    @EnvironmentObject var viewModel: StartSceneViewModel
    @Binding var showingLevelList: Bool

    var files: [String] { viewModel.handleLoadLevelButton() }
    var onSelect: (String) -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(files, id: \.self) { file in
                    Button(file) { onSelect(file) }
                }
            }
            .navigationBarTitle("Select a Level to load", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
            }, label: {
            }), trailing: Button("Done") {
                showingLevelList = false
            })
        }
    }

}
