import SwiftUI

struct EnvironmentMenuView: View {
    @EnvironmentObject var viewModel: StartSceneViewModel

    var body: some View {
        VStack {
            Spacer()
            Spacer()

            Text("CHOOSE YOUR PLANET")
                .font(.system(size: StyleSheet.getScaledWidth(4.5)))
                .fontDesign(.monospaced)
                .fontWeight(.heavy)
                .foregroundStyle(Color.white)
                .padding()

            Spacer()

            StyleSheet.getRectangleButtonWithAction(
                text: "EARTH 🌍",
                action: { viewModel.handleEarth() })

            StyleSheet.getRectangleButtonWithAction(
                text: "SATURN 🪐",
                action: { viewModel.handleSaturn() })

            StyleSheet.getRectangleButtonWithAction(
                text: "MARS ☄️",
                action: { viewModel.handleMars() })

            StyleSheet.getRectangleButtonWithAction(
                text: "SPACE 🌌",
                action: { viewModel.handleSpace() })

            StyleSheet.getRectangleButtonWithAction(
                text: "RETURN",
                action: { viewModel.handleReturnButton() })

            Spacer()
        }
    }
}
