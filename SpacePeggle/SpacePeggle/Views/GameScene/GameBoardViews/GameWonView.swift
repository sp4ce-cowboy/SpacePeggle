import SwiftUI

struct GameWonView: View {
    @EnvironmentObject var viewModel: GameSceneViewModel

    var body: some View {
        ZStack {
            StyleSheet
                .getRectangleOverlay()
                .overlay {
                    VStack {
                        Spacer()
                        Spacer()

                        Text("🪐 YOU WIN !!! 🪐")
                            .font(.system(size: StyleSheet.getScaledWidth(4.5)))
                            .fontDesign(.monospaced)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color.green)
                            .padding()

                        Text("SCORE = \(viewModel.getHighScore())")
                            .font(.system(size: StyleSheet.getScaledWidth(4.5)))
                            .fontDesign(.monospaced)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color.green)
                            .padding()

                        Spacer()

                        StyleSheet.getRectangleButtonWithAction(
                            text: "RETURN TO MENU",
                            action: { viewModel.handleExitButton() })

                        Spacer()
                        Spacer()
                    }
                }
        }
    }
}
