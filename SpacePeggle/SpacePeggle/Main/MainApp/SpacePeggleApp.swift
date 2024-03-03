import SwiftUI

@main
struct SpacePeggleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var sceneController = AppSceneController.shared

    init() {
        Logger.log("App is initialized", self)
    }

    var body: some Scene {
        WindowGroup {
            AppScene()
                .environmentObject(sceneController)
                .preferredColorScheme(.dark)
                // .aspectRatio(3 / 4, contentMode: .fit)
        }
    }
}
