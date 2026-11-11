import SwiftUI

struct StartSettingsMenuView: View {
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
                text: "SELECT ENVIRONMENT",
                action: { viewModel.handleEnvironmentButton() })

            StyleSheet.getRectangleButtonWithAction(
                text: "CHOOSE POWER-UP",
                action: { viewModel.handleGamePowerUpButton() })

            StyleSheet.getRectangleButtonWithAction(
                text: "RETURN",
                action: { viewModel.handleReturnButton() })

            Text("""
                CREDITS
                Space background: Solar System Vectors by Vecteezy (vecteezy.com)
                Music: "Bravery Run" (CC0, OpenGameArt.org) · Sound effects: Pixabay
                """)
                .font(.system(size: StyleSheet.getScaledWidth(1.4)))
                .fontDesign(.monospaced)
                .foregroundStyle(Color.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.top)

            Spacer()
        }
    }
}
