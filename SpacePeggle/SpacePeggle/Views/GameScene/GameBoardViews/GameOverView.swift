import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var viewModel: GameSceneViewModel

    var body: some View {
        ZStack {
            StyleSheet
                .getRectangleOverlay()
                .overlay {
                    VStack {
                        Spacer()
                        Spacer()

                        Text("🪐 YOU LOST :( 🪐")
                            .font(.system(size: StyleSheet.getScaledWidth(4.5)))
                            .fontDesign(.monospaced)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color.red)
                            .padding()


                        Text("SCORE = \(viewModel.getHighScore())")
                            .font(.system(size: StyleSheet.getScaledWidth(4.5)))
                            .fontDesign(.monospaced)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color.red)
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
