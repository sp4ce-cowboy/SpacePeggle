import SwiftUI

struct PowerUpSettingsView: View {
    @EnvironmentObject var viewModel: StartSceneViewModel

    var body: some View {
        VStack {
            Spacer()
            Spacer()

            Text(" CHOOSE GAMEMASTER ")
                .font(.system(size: StyleSheet.getScaledWidth(4.5)))
                .fontDesign(.monospaced)
                .fontWeight(.heavy)
                .foregroundStyle(Color.white)
                .padding()

            Text("Current: \(viewModel.handleGetCurrentPowerUp())")
                .font(.system(size: StyleSheet.getScaledWidth(4.5)))
                .fontDesign(.monospaced)
                .fontWeight(.heavy)
                .foregroundStyle(Color.white)
                .padding()

            Spacer()

            StyleSheet.getRectangleButtonWithAction(
                text: "KABOOM - Exploding Pegs!",
                action: { viewModel.handleKaboomButton() })

            StyleSheet.getRectangleButtonWithAction(
                text: "SPOOKY - Magical Pegs!",
                action: { viewModel.handleSpookyButton() })

            StyleSheet.getRectangleButtonWithAction(
                text: "RETURN",
                action: { viewModel.handleReturnToSettingsButton() })

            Spacer()
        }
    }
}
