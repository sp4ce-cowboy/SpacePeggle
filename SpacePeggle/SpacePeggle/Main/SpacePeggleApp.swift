import SwiftUI

@main
struct SpacePeggleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var sceneController = AppSceneController.shared

    /// Load scenes into scene controller
    init() {
        AppSceneController.uploadScene(withName: "StartScene") { geometry in
            AnyView(StartScene(forGeometry: geometry))
        }

        AppSceneController.uploadScene(withName: "GameScene") { geometry in
            AnyView(GameScene(forGeometry: geometry))
        }

        AppSceneController.uploadScene(withName: "LevelScene") { _ in
            AnyView(LevelScene())
        }

    }

    var body: some Scene {
        WindowGroup {
            CurrentScene().environmentObject(sceneController)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        AudioManager.shared.setupAudioPlayer()
        Logger.log("AppDelegate has completed delegated tasks", self)
        return true
    }
}
