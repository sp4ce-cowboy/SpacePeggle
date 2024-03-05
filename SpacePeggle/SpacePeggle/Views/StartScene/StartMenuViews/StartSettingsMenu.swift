import SwiftUI

struct StartSettingsView: View {
    @EnvironmentObject var viewModel: StartSceneViewModel

    var body: some View {
        VStack {
            Spacer()
            Spacer()

            Text("🪐 SETTINGS 🪐")
                .font(.system(size: StyleSheet.getScaledWidth(4.5)))
                .fontDesign(.monospaced)
                .fontWeight(.heavy)
                .foregroundStyle(Color.white)
                .padding()

            Spacer()

            StyleSheet.getRectangleButtonWithAction(
                text: "SET GRAVITY",
                action: { viewModel.handleGravityButton() })

            StyleSheet.getRectangleButtonWithAction(
                text: "SELECT ENVIRONMENT",
                action: { viewModel.handleEnvironmentButton() })

            StyleSheet.getRectangleButtonWithAction(
                text: "CHOOSE GAMEMASTER",
                action: { viewModel.handleGameMasterButton() })

            StyleSheet.getRectangleButtonWithAction(
                text: "RETURN",
                action: { viewModel.handleReturnButton() })

            Spacer()
        }
    }
}
