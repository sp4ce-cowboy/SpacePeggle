import SwiftUI

struct StartScene: View {
    var proxy: GeometryProxy

    init(forGeometry proxy: GeometryProxy) {
        self.proxy = proxy
    }

    var body: some View {
            ZStack {
                StyleSheet
                    .getRectangleOverlay()
                    .overlay {
                        StartMenuView()
                    }
            }
            .frame(width: proxy.size.width,
                   height: proxy.size.height)
            .background {
                StartBackgroundView(proxy: proxy)
            }
    }
}

#Preview {
    GeometryReader { proxy in
        StartScene(forGeometry: proxy)
    }
}
