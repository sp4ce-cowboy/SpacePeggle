import SwiftUI

/// This extension allows for safe, pre-defined transitions between scenes.
///
/// As opposed to having views call the `updateScene` method directly, the
/// call predefined transition triggers that encapsulate the calling of
/// the `updateScene` method with the appropriate scene name.
///
/// This approach allows for the retention of the dictionary's cyclomatic
/// "non-complexity" as opposed to a non-extendable enum while preserving the
/// sub-type safety offered by enums. Essentially, the scene collection can be
/// extended with more scenes (via a simple store method) and this new scene
/// can be safely retrieved from the dictionary by adding an extension to the
/// `AppSceneController` class that includes a method to transition to this new
/// state.
///
/// Unlike enums whose cases need to be modified to add scenes, this
/// approach respects the open-closed principle. Additionally, unlike dictionaries
/// whose retrieval mechanisms are entirely open-ended as compared to enums,
/// this approach enforces a certain restriction on the transitions available.
extension AppSceneController {

    func transitionToStartScene() {
        AudioManager.shared.stop()
        updateScene(to: .StartScene)
    }

    func transitionToGameScene() {
        updateScene(to: .GameScene)
        AudioManager.shared.play()
    }
}

extension AppSceneController {
    func transitionToLevelScene() {
        updateScene(to: .LevelScene)
    }
}

extension AppSceneController {
    func transitionToGameScene(with level: any AbstractLevel) {
        updateLevel(to: level)
        updateScene(to: .GameScene)
        AudioManager.shared.play()
    }
}
