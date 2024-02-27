import SwiftUI

protocol LauncherControl {
    var launcher: Launcher { get set }
    var ballIsLaunched: Bool { get }
    func updateLauncherRotation(with dragValue: DragGesture.Value)
    func handleBallLaunch()
}

extension MainViewModel: LauncherControl {
    var launcher: Launcher {
        get { peggleGameEngine.launcher }
        set { peggleGameEngine.launcher = newValue }
    }

    // LauncherView tells MainViewModel and MainViewModel tells the game engine
    func updateLauncherRotation(with dragValue: DragGesture.Value) {
        peggleGameEngine.updateLauncherRotation(with: dragValue,
                                                for: CGSize(width: currentViewSize.width,
                                                            height: launcher.launcherHeight))
    }

    var ballIsLaunched: Bool {
        peggleGameEngine.isBallLaunched
    }

    func handleBallLaunch() {
        peggleGameEngine.launchBall()
    }

    func calculateTrajectory() -> some View {
        Path { path in
            let startPoint = launcher.launcherTipPosition.point
            path.move(to: startPoint)

            let launchVelocity = Constants.UNIVERSAL_LAUNCH_FORCE
            let gravity = Constants.UNIVERSAL_GRAVITY.y
            let timeInterval: CGFloat = 0.01 // Smaller for a smoother curve

            var time: CGFloat = 0
            var trajectoryPoint = startPoint
            let maxTrajectoryLength: CGFloat = launcher.launcherHeight * 2 // Max trajectory line length

            while Constants.distance(from: startPoint, to: trajectoryPoint) <= maxTrajectoryLength {
                // Calculate the next point using kinematic equations
                let dx = launchVelocity * sin(launcher.rotationAngle.radians) * Double(time)
                let dy = launchVelocity * -cos(launcher.rotationAngle.radians)
                * Double(time) - 0.5 * gravity * Double(time * time)

                trajectoryPoint = CGPoint(x: startPoint.x + CGFloat(dx), y: startPoint.y - CGFloat(dy))
                path.addLine(to: trajectoryPoint)
                time += timeInterval
            }
        }
        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .bevel, dash: [3, 10]))
        .if(ballIsLaunched) { view in
            view.foregroundStyle(Color.red)
                .opacity(0.2)
        }
        .if(!ballIsLaunched) { view in
            view.foregroundStyle(Color.green)
                .opacity(0.9)
        }
    }
}
