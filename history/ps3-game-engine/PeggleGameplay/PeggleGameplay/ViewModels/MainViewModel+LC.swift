import SwiftUI

protocol LauncherControl {
    var launcher: Launcher { get set }
    func updateLauncherRotation(with dragValue: DragGesture.Value)
    func handleBallLaunch()
    var ballIsLaunched: Bool { get }
}

extension MainViewModel: LauncherControl {
    var launcher: Launcher {
        get { peggleGameEngine.launcher }
        set { peggleGameEngine.launcher = newValue }
    }

    // LauncherView tells MainViewModel and MainViewModel tells the game engine
    func updateLauncherRotation(with dragValue: DragGesture.Value) {
        peggleGameEngine
            .updateLauncherRotation(
                with: dragValue, for: CGSize(width: currentViewSize.width,
                                             height: peggleGameEngine.launcher.launcherHeight))
    }

    var ballIsLaunched: Bool {
        peggleGameEngine.isBallLaunched
    }

    func handleBallLaunch() {
        peggleGameEngine.launchBall()
    }
}
