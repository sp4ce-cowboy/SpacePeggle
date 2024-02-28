import SwiftUI

/// A View that presents the backdrop of the start screen
struct StartBackgroundView: View {
    @State var proxy: GeometryProxy

    // The width is required to ensure that the backgroud is displayed consistently
    // across iPads of different sizes.
    var currentWidth: Double {
        proxy.size.width
    }

    var body: some View {
        Image("space-background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: proxy.size.width)
            .clipped()   // To crop the image to the bounds of the frame
            .ignoresSafeArea()
    }
}
