import SwiftUI

struct BallView: View {
    @EnvironmentObject var viewModel: MainViewModel

    var ballWidth: Double {
        Double(ObjectSet.defaultGameObjectSet["Ball"]?.size.width ?? CGFloat(Constants.UNIVERSAL_LENGTH))
    }

    var ballHeight: Double {
        Double(ObjectSet.defaultGameObjectSet["Ball"]?.size.height ?? CGFloat(Constants.UNIVERSAL_LENGTH))
    }

    var imageName: String {
        ObjectSet.defaultGameObjectSet["Ball"]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB
    }

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
