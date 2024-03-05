import SwiftUI

struct LevelMenuView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    var body: some View {
        ZStack {
            StyleSheet
                .getRectangleOverlay()
                .overlay {
                    VStack {
                        StyleSheet.getRectangleButtonWithAction(
                            text: "Return to Level",
                            action: { viewModel.handleReturnButton() })

                        StyleSheet.getRectangleButtonWithAction(
                            text: "Exit to Menu",
                            action: {
                                viewModel.handleExitButton()
                            })
                        .foregroundColor(Color.red)

                    }
                }
        }

    }
}
