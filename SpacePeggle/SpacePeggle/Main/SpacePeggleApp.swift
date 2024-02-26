import SwiftUI

@main
struct SpacePeggleApp: App {

    var body: some Scene {
        WindowGroup {
            GeometryReader { proxy in
                MainView(forGeometry: proxy)
                    // .ignoresSafeArea()
                    .onAppear {
                        print(proxy.size)
                    }
            }
        }
    }
}
