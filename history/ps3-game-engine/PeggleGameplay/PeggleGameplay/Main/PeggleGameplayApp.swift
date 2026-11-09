import SwiftUI

@main
struct PeggleGameplayApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { proxy in
                MainView(forGeometry: proxy)
            }
        }
    }
}
