import SwiftUI

struct LevelSelectionMenuView: View {
    @EnvironmentObject var viewModel: StartSceneViewModel

    var body: some View {
        VStack {
            Spacer()
            Spacer()

            Text("🪐 CHOOSE A LEVEL 🪐")
                .font(.system(size: StyleSheet.getScaledWidth(4.5)))
                .fontDesign(.monospaced)
                .fontWeight(.heavy)
                .foregroundStyle(Color.white)
                .padding()

            Spacer()

            StyleSheet.getRectangleButtonWithAction(
                text: "LOAD LEVEL 1",
                action: { viewModel.handleLoadLevelOne() })

            StyleSheet.getRectangleButtonWithAction(
                text: "LOAD LEVEL 2",
                action: { viewModel.handleLoadLevelTwo() })

            StyleSheet.getRectangleButtonWithAction(
                text: "LOAD LEVEL 3",
                action: { viewModel.handleLoadLevelThree() })

            StyleSheet.getRectangleButtonWithAction(
                text: "RETURN",
                action: { viewModel.handleReturnButton() })

            Spacer()
        }

    }
}
