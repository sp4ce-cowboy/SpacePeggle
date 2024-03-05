import SwiftUI

/// A View that presents the backdrop of the start screen
struct StartBackgroundView: View {
    @EnvironmentObject var viewModel: StartSceneViewModel

    // The width is required to ensure that the backgroud is displayed consistently
    // across iPads of different sizes.
    var currentWidth: Double {
        viewModel.geometryState.size.width
    }

    var body: some View {
        Image(Constants.BACKGROUND_IMAGE)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: currentWidth)
            .clipped()   // To crop the image to the bounds of the frame
            .ignoresSafeArea()
    }
}
