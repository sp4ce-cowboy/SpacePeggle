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
                            action: { viewModel.handlePause() })

                        StyleSheet.getRectangleButtonWithAction(
                            text: "Exit to Menu",
                            action: {
                                viewModel.handlePause()
                                AppSceneController.transitionToStartScene()
                            })
                        .foregroundColor(Color.red)

                    }
                }
        }

    }
}
