import SwiftUI

/// A View that presents the backdrop of the level designer area.
///
struct LevelBackgroundView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    var width: Double {
        viewModel.geometryState.size.width
    }

    var body: some View {
        Image(Constants.BACKGROUND_IMAGE.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width)
            .clipped()
            .ignoresSafeArea()
    }
}
