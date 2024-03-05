import SwiftUI

/// A View that presents the backdrop of the playable area
struct GameBackgroundView: View {
    @EnvironmentObject var viewModel: GameSceneViewModel

    // The width is required to ensure that the backgroud is displayed consistently
    // across iPads of different sizes. 
    var width: Double {
        viewModel.geometryState.size.width
    }

    var body: some View {
        Image(Constants.BACKGROUND_IMAGE)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width)
            .clipped()   // To crop the image to the bounds of the frame
            .ignoresSafeArea()
    }
}
