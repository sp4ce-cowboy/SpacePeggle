import SwiftUI

/// A View that presents the backdrop of the playable area
struct BackgroundView: View {
    // The vertical offset is used to adjust the background as needed depending on the
    // organization of content on the image used as the background.
    let verticalOffset = -(UIScreen.main.bounds.height * Utility.BOTTOM_HEIGHT_MODIFER)

    // The width is required to ensure that the backgroud is displayed consistently
    var width: Double

    var body: some View {
        Image("background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width)
            .offset(y: verticalOffset)
            .clipped()   // To crop the image to the bounds of the frame
            .ignoresSafeArea()
    }
}
