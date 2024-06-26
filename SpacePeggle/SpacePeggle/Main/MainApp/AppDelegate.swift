import Foundation
import SwiftUI

/// App delegate adaptor to help with setting up the application without
/// overloading the entry point of the main application.
///
/// The integration of AppDelegate using @UIApplicationDelegateAdaptor allows for a
/// smooth transition and compatibility between UIKit's app lifecycle management and
/// SwiftUI's modern declarative approach to building UIs.
class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        AudioManager.shared.setupAudioPlayer()

        Logger.log("AppDelegate has completed delegated tasks", self)

        /// Load default scenes into scene controller
        AppSceneController.uploadScene(withName: .StartScene) { geometry, sceneController in
            AnyView(StartScene(forGeometry: geometry, with: sceneController))
        }

        AppSceneController.uploadScene(withName: .GameScene) { geometry, sceneController in
            AnyView(GameScene(forGeometry: geometry, with: sceneController))
        }

        AppSceneController.uploadScene(withName: .LevelScene) { geometry, sceneController in
            AnyView(LevelScene(forGeometry: geometry, with: sceneController))
        }

        Logger.log("AppDelegate has uploaded app scenes", self)
        return true
    }
}
