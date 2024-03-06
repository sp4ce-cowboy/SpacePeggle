import SwiftUI

struct StartMenuDefaultView: View {
    @EnvironmentObject var viewModel: StartSceneViewModel
    @State var showingLevelList = false

    var body: some View {
        VStack {
            Spacer()
            Spacer()

            Text("🪐 SPACE PEGGLE 🪐")
                .font(.system(size: StyleSheet.getScaledWidth(4.5)))
                .fontDesign(.monospaced)
                .fontWeight(.heavy)
                .foregroundStyle(Color.white)
                .padding()

            Spacer()

            StyleSheet.getRectangleButtonWithAction(
                text: "START GAME",
                action: { viewModel.handleStartGameButton() })

            StyleSheet.getRectangleButtonWithAction(
                text: "LOAD LEVEL",
                action: { showingLevelList = true })

            StyleSheet.getRectangleButtonWithAction(
                text: "DESIGN LEVEL",
                action: { viewModel.handleDesignButton() })

            StyleSheet.getRectangleButtonWithAction(
                text: "SETTINGS",
                action: { viewModel.handleSettingsButton() })

            Spacer()
        }
        .sheet(isPresented: $showingLevelList) {
            LevelLoadingView(showingLevelList: $showingLevelList) { selectedFile in
                if let loadedLevel = Storage.loadLevel(from: selectedFile) {
                    viewModel.handleLoadLevel(loadedLevel)
                }
                showingLevelList = false
            }
        }
    }
}
