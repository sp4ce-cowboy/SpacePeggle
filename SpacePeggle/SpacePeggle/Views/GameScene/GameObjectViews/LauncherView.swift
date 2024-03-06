import SwiftUI

/// This View displays the cannon at the top of the gameplay area.
struct LauncherView: View {
    @EnvironmentObject var viewModel: GameSceneViewModel

    var launcher: Launcher { viewModel.launcher }
    var isBallLaunched: Bool { viewModel.ballIsLaunched }
    var screenWidthCenter: Double { launcher.centerPosition.x }
    var launcherHeightCenter: Double { launcher.centerPosition.y }
    var launcherHeight: Double { launcher.launcherHeight }
    var launcherWidth: Double { viewModel.getLauncherWidth() }
    var launcherImageString: String { viewModel.getLauncherImage() }

    var body: some View {
        ZStack {
            viewModel.calculateTrajectory()
            Image(launcherImageString)
                .resizable()
                .frame(width: launcherWidth, height: launcherHeight)
                .rotationEffect(-launcher.rotationAngle, anchor: .center)
                .position(x: screenWidthCenter, y: launcherHeightCenter)
                .gesture(handleRotation.exclusively(before: handleTap))
                .disabled(viewModel.isLauncherDisabled())
        }
    }

    /// While launcher rotation can be handled directly, passage through the ViewModel
    /// ensures that the proper MVVM architecture is preserved.
    private var handleRotation: some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.updateLauncherRotation(with: value)
            }
    }

    private var handleTap: some Gesture {
        SpatialTapGesture()
            .onEnded { _ in
                viewModel.handleLongPress()
            }
    }

}
