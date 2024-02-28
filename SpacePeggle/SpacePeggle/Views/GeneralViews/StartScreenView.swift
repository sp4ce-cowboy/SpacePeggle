import SwiftUI

struct StartScreenView: View {
    var proxy: GeometryProxy

    var body: some View {
            ZStack {
                StyleSheet
                    .getRectangleOverlay()
                    .overlay {
                        VStack {
                            Spacer()
                            Spacer()

                            Text("SPACE PEGGLE")
                                .font(.largeTitle)
                                .fontDesign(.monospaced)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.white)
                                .padding()

                            Spacer()

                            StyleSheet.getRectangleButtonWithAction(
                                text: "LOAD LEVEL",
                                action: { SceneController.shared.transitionToGameScene() })

                            StyleSheet.getRectangleButtonWithAction(
                                text: "DESIGN LEVEL",
                                action: { SceneController.shared.transitionToGameScene() })

                            StyleSheet.getRectangleButtonWithAction(
                                text: "SETTINGS",
                                action: { SceneController.shared.transitionToGameScene() })

                            Spacer()
                        }
                    }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background { StartBackgroundView(proxy: proxy) }
    }
}
