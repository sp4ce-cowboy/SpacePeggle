import SwiftUI

@main
struct SpacePeggleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        Logger.log("App is initialized", self)
    }

    var body: some Scene {
        WindowGroup {
            AppScene()
                .preferredColorScheme(.light)
        }
    }
}
