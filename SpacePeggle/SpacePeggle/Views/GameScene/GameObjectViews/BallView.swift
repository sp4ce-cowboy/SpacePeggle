import SwiftUI

struct BallView: View {
    @EnvironmentObject var viewModel: GameSceneViewModel

    var ballShape: UniversalShape { viewModel.getCurrentBallShape()}
    var ballWidth: Double { ballShape.trueWidth }
    var ballHeight: Double { ballShape.trueHeight }
    var imageName: String { ObjectSet.defaultGameObjectSet["Ball"]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB }

    var body: some View {
        if viewModel.ballIsLaunched {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: ballWidth, height: ballHeight)
                .position(viewModel.getCurrentBallPosition().point)
        }
    }
}
